import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../providers/auth.dart';
import 'common.dart';

const HOST_SHARED_KEY = 'HOST';
const EMAIL_SHARED_KEY = 'EMAIL';
const ENCRYPTION_KEY_SHARED_KEY = 'ENCRYPTION_KEY';
const TOKEN_SHARED_KEY = 'TOKEN';
const SYM_KEY_SHARED_KEY = 'SYM_KEY';

final _logger = Logger('hooks/auth');

LoadingDataCallback<bool, void> useIsSecureStorageAvailable(
    BuildContext context) {
  var loading = useState<bool>(false);
  var isAvailable = useState<bool>(false);
  final checkAvailable = useCallback(([void _]) async {
    loading.value = true;
    try {
      final storage = FlutterSecureStorage();
      var random = Random.secure();
      final keyBytes = List<int>.generate(32, (i) => random.nextInt(256));
      final key = base64Encode(keyBytes);
      final valueBytes = List<int>.generate(32, (i) => random.nextInt(256));
      final value = base64Encode(valueBytes);
      await storage.write(key: key, value: value);
      final read = await storage.read(key: key);
      isAvailable.value = read == value;
    } catch (e, s) {
      _logger.warning(e.toString(), e, s);
      isAvailable.value = false;
    } finally {
      loading.value = false;
    }
  }, []);
  return LoadingDataCallback<bool, void>(
      loading.value, isAvailable.value, checkAvailable);
}

LoadingVoidCallback useLoadFromLocal(WidgetRef ref) {
  var loading = useState<bool>(false);
  final loadFromLocal = useCallback(() {
    loading.value = true;
    SharedPreferences.getInstance().then((instance) async {
      final host = instance.getString(HOST_SHARED_KEY);
      final email = instance.getString(EMAIL_SHARED_KEY);
      _logger.fine(host);
      if (host != null && email != null) {
        final storage = FlutterSecureStorage();
        final storageReads = await Future.wait([
          storage.read(key: TOKEN_SHARED_KEY),
          storage.read(key: ENCRYPTION_KEY_SHARED_KEY),
          storage.read(key: SYM_KEY_SHARED_KEY),
        ]);
        final token = storageReads[0];
        final encryptionKey = storageReads[1];
        final symKey = storageReads[2];
        _logger.fine(token);
        _logger.fine(encryptionKey);
        _logger.fine(symKey);
        if (token != null && encryptionKey != null && symKey != null) {
          ApiController.instance.auth.setToken(token);
          ApiController.instance.auth.encryptionKey = encryptionKey;
          ApiController.instance.auth.symKey = base64Decode(symKey);
          ref.read(authProvider.notifier).loggedIn(host, email);
        } else {
          ref.read(authProvider.notifier).loaded(host, email);
        }
        loading.value = false;
      } else {
        ref.read(authProvider.notifier).loggedOut();
        loading.value = false;
      }
    }).catchError((e, s) {
      _logger.warning(e.toString(), e, s);
      loading.value = false;
    });
  }, []);
  return LoadingVoidCallback(loading.value, loadFromLocal);
}

LoadingCallback<bool> useSaveToLocal(WidgetRef ref) {
  var loading = useState<bool>(false);
  final saveToLocal = useCallback((bool saveSecure) async {
    loading.value = true;
    final instance = await SharedPreferences.getInstance();
    final auth = ref.read(authProvider);
    final email = auth.email;
    final host = auth.host;
    await instance.setString(HOST_SHARED_KEY, host);
    _logger.fine(email);
    if (email != null) {
      await instance.setString(EMAIL_SHARED_KEY, email);
      _logger.fine(saveSecure);
      if (saveSecure) {
        final encryptionKey = ApiController.instance.auth.encryptionKey;
        final symKey = ApiController.instance.auth.symKey;
        final token = ApiController.instance.auth.getToken();
        _logger.fine(token);
        _logger.fine(encryptionKey);
        if (token != null && encryptionKey != null && symKey != null) {
          final storage = FlutterSecureStorage();
          await storage.write(key: TOKEN_SHARED_KEY, value: token);
          await storage.write(
              key: ENCRYPTION_KEY_SHARED_KEY, value: encryptionKey);
          await storage.write(
              key: SYM_KEY_SHARED_KEY, value: base64Encode(symKey));
        }
      }
    }
    loading.value = false;
  }, []);
  return LoadingCallback<bool>(loading.value, saveToLocal);
}

LoadingVoidCallback useResetLocal(BuildContext context) {
  var loading = useState<bool>(false);
  final resetLocal = useCallback(() {
    loading.value = true;
    SharedPreferences.getInstance().then((instance) async {
      await instance.remove(HOST_SHARED_KEY);
      await instance.remove(EMAIL_SHARED_KEY);
      final storage = FlutterSecureStorage();
      await storage.deleteAll();
      loading.value = false;
    }).catchError((e) {
      loading.value = false;
    });
  }, []);
  return LoadingVoidCallback(loading.value, resetLocal);
}

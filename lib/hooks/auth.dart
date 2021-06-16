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

final _logger = Logger('hooks/auth');

LoadingVoidCallback useLoadFromLocal(BuildContext context) {
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
          storage.read(key: ENCRYPTION_KEY_SHARED_KEY)
        ]);
        final token = storageReads[0];
        final encryptionKey = storageReads[1];
        _logger.fine(token);
        _logger.fine(encryptionKey);
        if (token != null && encryptionKey != null) {
          ApiController.instance.auth.setToken(token);
          ApiController.instance.auth.encryptionKey = encryptionKey;
          try {
            await ApiController.instance.keys.fetchKeys();
            context.read(authProvider.notifier).loggedIn(host, email);
          } catch (e) {
            context.read(authProvider.notifier).loggedOut();
          }
        } else {
          context.read(authProvider.notifier).loaded(host, email);
        }
        loading.value = false;
      } else {
        context.read(authProvider.notifier).loggedOut();
        loading.value = false;
      }
    }).catchError((e) {
      loading.value = false;
    });
  }, []);
  return LoadingVoidCallback(loading.value, loadFromLocal);
}

LoadingCallback<bool> useSaveToLocal(BuildContext context) {
  var loading = useState<bool>(false);
  final saveToLocal = useCallback((bool saveSecure) async {
    loading.value = true;
    final instance = await SharedPreferences.getInstance();
    final auth = context.read(authProvider);
    final email = auth.email;
    final host = auth.host;
    await instance.setString(HOST_SHARED_KEY, host);
    _logger.fine(email);
    if (email != null) {
      await instance.setString(EMAIL_SHARED_KEY, email);
      _logger.fine(saveSecure);
      if (saveSecure) {
        final encryptionKey = ApiController.instance.auth.encryptionKey;
        final token = ApiController.instance.auth.getToken();
        _logger.fine(token);
        _logger.fine(encryptionKey);
        if (token != null && encryptionKey != null) {
          final storage = FlutterSecureStorage();
          await storage.write(key: TOKEN_SHARED_KEY, value: token);
          await storage.write(
              key: ENCRYPTION_KEY_SHARED_KEY, value: encryptionKey);
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

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

LoadingCallback useLoadFromLocal(BuildContext context) {
  var loading = useState<bool>(false);
  final loadFromLocal = useCallback(() {
    loading.value = true;
    SharedPreferences.getInstance().then((instance) async {
      final host = instance.getString(HOST_SHARED_KEY);
      final email = instance.getString(EMAIL_SHARED_KEY);
      _logger.fine(host);
      if (host != null && email != null) {
        final storage = FlutterSecureStorage();
        final token = await storage.read(key: TOKEN_SHARED_KEY);
        final encryptionKey =
            await storage.read(key: ENCRYPTION_KEY_SHARED_KEY);
        _logger.fine(token);
        _logger.fine(encryptionKey);
        if (token != null && encryptionKey != null) {
          ApiController.instance.auth.setToken(token);
          ApiController.instance.auth.encryptionKey = encryptionKey;
          await ApiController.instance.keys.fetchKeys();
          context.read(authProvider.notifier).loggedIn(host, email);
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
  return LoadingCallback(loading.value, loadFromLocal);
}

LoadingCallback useSaveToLocal(BuildContext context) {
  var loading = useState<bool>(false);
  final auth = useProvider(authProvider);
  final saveToLocal = useCallback(() {
    loading.value = true;
    SharedPreferences.getInstance().then((instance) async {
      final email = auth.email;
      await instance.setString(HOST_SHARED_KEY, auth.host);
      if (email != null) {
        await instance.setString(EMAIL_SHARED_KEY, email);
      }
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
      loading.value = false;
    }).catchError((e) {
      loading.value = false;
    });
  }, []);
  return LoadingCallback(loading.value, saveToLocal);
}

LoadingCallback useResetLocal(BuildContext context) {
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
  return LoadingCallback(loading.value, resetLocal);
}

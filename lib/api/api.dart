import '../constants.dart';
import 'auth.dart';
import 'account.dart';
import 'keys.dart';

class ApiController {
  static ApiController instance = ApiController(DEFAULT_HOST);

  static void setInstance(String host) {
    instance = ApiController(host);
  }

  String host;
  AuthController auth;

  ApiController(this.host) : auth = AuthController(host);

  AccountController get account => AccountController(auth);
  KeysController get keys => KeysController(auth);
}

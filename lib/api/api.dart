import 'auth.dart';
import 'account.dart';
import 'keys.dart';

class ApiController {
  String host;
  AuthController auth;

  ApiController(this.host) : auth = AuthController(host);

  AccountController get account => AccountController(auth);
  KeysController get keys => KeysController(auth);
}

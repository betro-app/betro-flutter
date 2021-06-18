import '../constants.dart';
import 'auth.dart';
import 'account.dart';
import 'feed.dart';
import 'keys.dart';
import 'post.dart';
import 'user.dart';

class ApiController {
  static ApiController instance = ApiController(DEFAULT_HOST);

  static void setInstance(String host) {
    instance = ApiController(host);
  }

  String host;
  AuthController auth;

  ApiController(this.host) : auth = AuthController(host);

  AccountController get account => AccountController(auth);
  FeedController get feed => FeedController(auth);
  KeysController get keys => KeysController(auth);
  PostController get post => PostController(auth);
  UserController get user => UserController(auth);
}

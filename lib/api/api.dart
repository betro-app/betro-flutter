import '../constants.dart';
import 'auth.dart';
import 'account.dart';
import 'conversation.dart';
import 'feed.dart';
import 'follow.dart';
import 'group.dart';
import 'keys.dart';
import 'notification.dart';
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
  ConversationController get conversation => ConversationController(auth);
  FollowController get follow => FollowController(auth);
  GroupController get group => GroupController(auth);
  KeysController get keys => KeysController(auth);
  NotificationController get notification => NotificationController(auth);
  PostController get post => PostController(auth);
  UserController get user => UserController(auth);
}

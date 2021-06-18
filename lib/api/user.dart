import 'dart:convert';
import 'dart:typed_data';

import './auth.dart';
import './helper.dart';
import './types/UserInfo.dart';
import './types/UserInfoResponse.dart';

class UserController {
  final AuthController auth;
  UserController(this.auth);

  Future<UserInfo?> fetchUserInfo(String username) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    final response = await auth.http1Client.get('/api/user/$username');
    final data = response.data;
    if (data == null) return null;
    final user = UserInfoResponse.fromJson(data);
    final parsedUser = await parseUserGrant(encryptionKey, user);
    final profile_picture = parsedUser.profile_picture;
    return UserInfo(
      id: user.id,
      is_following: user.is_following,
      is_approved: user.is_approved,
      username: user.username,
      public_key: user.public_key,
      first_name: parsedUser.first_name,
      last_name: parsedUser.last_name,
      profile_picture:
          profile_picture == null ? null : Uint8List.fromList(profile_picture),
    );
  }
}

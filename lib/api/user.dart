import './auth.dart';
import './helper.dart';
import './types/UserInfo.dart';
import './types/UserInfoResponse.dart';
import './types/UserEcdhKeyResponse.dart';
import './types/SearchUserResource.dart';
import './types/SearchUserResponse.dart';

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
    return UserInfo(
      id: user.id,
      is_following: user.is_following,
      is_approved: user.is_approved,
      username: user.username,
      public_key: user.public_key,
      first_name: parsedUser.first_name,
      last_name: parsedUser.last_name,
      profile_picture: parsedUser.profile_picture,
    );
  }

  Future<List<SearchUserResource>?> fetchSearchUser(
    String query,
  ) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    final response =
        await auth.http1Client.get('/api/user/search?query=$query');
    final resp = (response.data as List<dynamic>)
        .map((a) => SearchUserResponse.fromJson(a))
        .toList();
    final list = <SearchUserResource>[];
    for (var item in resp) {
      final user = await parseUserGrant(encryptionKey, item);
      list.add(
        SearchUserResource(
          id: item.id,
          username: item.username,
          is_following: item.is_following,
          is_following_approved: item.is_following_approved,
          public_key: item.public_key,
          first_name: user.first_name,
          last_name: user.last_name,
          profile_picture: user.profile_picture,
        ),
      );
    }
    return list;
  }

  Future<UserEcdhKeyResponse> fetchUserEcdhKey(String id) async {
    final response = await auth.http1Client.get('/api/keys/ecdh/user/$id');
    return UserEcdhKeyResponse.fromJson(response.data);
  }
}

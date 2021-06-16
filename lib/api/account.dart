import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:betro_dart_lib/betro_dart_lib.dart';

import './auth.dart';
import './types/CountResponse.dart';
import './types/UserProfilePutRequest.dart';
import './types/UserProfileResponse.dart';
import './types/WhoamiResponse.dart';

final _logger = Logger('api/account');

class AccountController {
  final AuthController auth;
  AccountController(this.auth);

  Future<List<int>?> fetchProfilePicture() async {
    final symKey = auth.symKey;
    if (symKey == null) return null;
    try {
      final response = await auth.http1Client.get<String>(
          '/api/account/profile_picture',
          options: Options(responseType: ResponseType.plain));
      final data = response.data;
      if (data != null && data.isNotEmpty) {
        return await symDecryptBuffer(symKey, data);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
    return null;
  }

  Future<WhoamiResponse?> fetchWhoAmi() async {
    final symKey = auth.symKey;
    if (symKey == null) return null;
    try {
      final response = await auth.client.get('/api/account/whoami');
      final whoami = WhoamiResponse.fromJson(response.data);
      final first_name = whoami.first_name;
      final last_name = whoami.last_name;
      return WhoamiResponse(
        whoami.user_id,
        whoami.username,
        whoami.email,
        (first_name == null || first_name.isEmpty)
            ? null
            : utf8.decode(await symDecryptBuffer(symKey, first_name)),
        (last_name == null || last_name.isEmpty)
            ? null
            : utf8.decode(await symDecryptBuffer(symKey, last_name)),
      );
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  Future<CountResponse?> fetchCounts() async {
    const include_fields = [
      'notifications',
      'settings',
      'groups',
      'followers',
      'followees',
      'approvals',
      'posts',
    ];
    final response = await auth.client
        .get('/api/account/count?include_fields=${include_fields.join(",")}');
    final count = CountResponse.fromJson(response.data);
    return count;
  }

  Future<UserProfile?> _transformProfileResponse(
      UserProfileResponse response) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    final sym_key = response.sym_key;
    if (sym_key == null) return null;
    final symDecrypted = base64Encode(await symDecrypt(
      encryptionKey,
      sym_key,
    ));
    final first_name = response.first_name;
    final last_name = response.last_name;
    final profile_picture = response.profile_picture;
    return UserProfile(
      sym_key: symDecrypted,
      first_name: first_name == null
          ? null
          : utf8.decode(await symDecrypt(symDecrypted, first_name)),
      last_name: last_name == null
          ? null
          : utf8.decode(await symDecrypt(symDecrypted, last_name)),
      profile_picture: profile_picture == null
          ? null
          : await symDecrypt(symDecrypted, profile_picture),
    );
  }

  Future<UserProfile?> createProfile({
    String? first_name,
    String? last_name,
    List<int>? profile_picture,
  }) async {
    final symKey = auth.symKey;
    if (symKey == null) return null;
    final request = UserProfilePutRequest(
      first_name: first_name == null
          ? null
          : await symEncryptBuffer(symKey, utf8.encode(first_name)),
      last_name: last_name == null
          ? null
          : await symEncryptBuffer(symKey, utf8.encode(last_name)),
      profile_picture: profile_picture == null
          ? null
          : await symEncryptBuffer(symKey, profile_picture),
    );
    _logger.finer(jsonEncode(request));
    final response = await auth.http1Client
        .post('/api/account/profile', data: jsonEncode(request));
    final profile = UserProfileResponse.fromJson(response.data);
    return _transformProfileResponse(profile);
  }

  Future<UserProfile?> updateProfile({
    String? first_name,
    String? last_name,
    List<int>? profile_picture,
  }) async {
    final symKey = auth.symKey;
    if (symKey == null) return null;
    final request = UserProfilePutRequest(
      first_name: first_name == null
          ? null
          : await symEncryptBuffer(symKey, utf8.encode(first_name)),
      last_name: last_name == null
          ? null
          : await symEncryptBuffer(symKey, utf8.encode(last_name)),
      profile_picture: profile_picture == null
          ? null
          : await symEncryptBuffer(symKey, profile_picture),
    );
    _logger.finer(jsonEncode(request));
    final response = await auth.http1Client
        .put('/api/account/profile', data: jsonEncode(request));
    final profile = UserProfileResponse.fromJson(response.data);
    return _transformProfileResponse(profile);
  }
}

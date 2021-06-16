import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:betro_dart_lib/betro_dart_lib.dart';

import './auth.dart';
import './types/WhoamiResponse.dart';

final _logger = Logger('api/account');

class AccountController {
  final AuthController auth;
  AccountController(this.auth);

  Future<List<int>?> fetchProfilePicture() async {
    final symKey = auth.symKey;
    if (symKey == null) return null;
    final response = await auth.http1Client.get<String>(
        '/api/account/profile_picture',
        options: Options(responseType: ResponseType.plain));
    final data = response.data;
    if (data != null) {
      return await symDecryptBuffer(symKey, data);
    }
    return null;
  }

  Future<WhoamiResponse?> fetchWhoAmi() async {
    final symKey = auth.symKey;
    if (symKey == null) return null;
    final response = await auth.client.get('/api/account/whoami');
    final whoami = WhoamiResponse.fromJson(response.data);
    return WhoamiResponse(
      whoami.user_id,
      whoami.username,
      whoami.email,
      utf8.decode(await symDecryptBuffer(symKey, whoami.first_name ?? '')),
      utf8.decode(await symDecryptBuffer(symKey, whoami.last_name ?? '')),
    );
  }
}

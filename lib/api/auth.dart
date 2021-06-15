import 'dart:convert';

import 'package:betro_dart_lib/betro_dart_lib.dart';
import 'package:dio/dio.dart';

import './types/LoginRequest.dart';
import './types/TokenResponse.dart';

class AuthController {
  final String host;
  final Dio client;
  String? encryptionKey;
  String? symKey;
  AuthController(this.host) : client = Dio(BaseOptions(baseUrl: host));

  Future<bool> login(String email, String password) async {
    final masterKey = await getMasterKey(email, password);
    final masterHash = await getMasterHash(masterKey, password);
    final response = await client.post('/api/login',
        data: jsonEncode(LoginRequest(email, masterHash)));
    encryptionKey = await getEncryptionKeys(masterKey);
    final token = TokenResponse.fromJson(response.data).token;
    if (token.isNotEmpty) {
      client.options.headers['Authorization'] = 'Bearer $token';
      return true;
    }
    return false;
  }
}

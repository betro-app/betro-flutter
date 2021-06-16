import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:betro_dart_lib/betro_dart_lib.dart';

import './types/LoginRequest.dart';
import './types/TokenResponse.dart';

final _logger = Logger('api/auth');

class AuthController {
  final String host;
  final Dio client;
  String? encryptionKey;
  Uint8List? symKey;
  AuthController(this.host) : client = Dio(BaseOptions(baseUrl: host));

  void setToken(String token) {
    if (token.isNotEmpty) {
      client.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  String? getToken() {
    final String? bearer = client.options.headers['Authorization'];
    if (bearer != null && bearer.isNotEmpty) {
      final splitted = bearer.split('Bearer');
      _logger.fine(splitted);
      return splitted.length < 2 ? null : splitted[1].trim();
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    final masterKey = await getMasterKey(email, password);
    final masterHash = await getMasterHash(masterKey, password);
    final response = await client.post('/api/login',
        data: jsonEncode(LoginRequest(email, masterHash)));
    encryptionKey = await getEncryptionKeys(masterKey);
    final token = TokenResponse.fromJson(response.data).token;
    _logger.finest(token);
    setToken(token);
  }

  Future<void> logout() async {
    // await client.post('/api/logout');
    symKey = null;
    encryptionKey = null;
    client.options.headers['Authorization'] = null;
  }
}

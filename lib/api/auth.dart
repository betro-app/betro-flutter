import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
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
  AuthController(this.host) : client = Dio(BaseOptions(baseUrl: host)) {
    client.options.headers['accept-encoding'] = 'gzip, deflate, br';
    client.options.headers['charset'] = 'UTF-8';
    client.options.headers['accept'] = 'application/json, text/plain, */*';
    client.options.headers['content-type'] = 'application/json';
    if (_logger.level <= Level.FINER) {
      client.interceptors.add(LogInterceptor());
    }
    final httpClientAdapter = Http2Adapter(
      ConnectionManager(
        idleTimeout: 100000,
      ),
    );
    client.httpClientAdapter = httpClientAdapter;
  }

  Dio get http1Client {
    final dio = Dio(BaseOptions(baseUrl: host));
    dio.options = client.options;
    dio.interceptors.addAll(client.interceptors);
    return dio;
  }

  void setToken(String token) {
    if (token.isNotEmpty) {
      client.options.headers['authorization'] = 'Bearer $token';
    }
  }

  String? getToken() {
    final String? bearer = client.options.headers['authorization'];
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
    client.options.headers['authorization'] = null;
  }
}

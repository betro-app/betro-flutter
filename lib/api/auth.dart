import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:logging/logging.dart';
import 'package:betro_dart_lib/betro_dart_lib.dart';

import './types/LoginRequest.dart';
import './types/RegisterRequest.dart';
import './types/TokenResponse.dart';
import './types/EcdhKeyResource.dart';

final _logger = Logger('api/auth');
bool enableCache = false;

// Global options
Future<CacheOptions> getCacheOptions() async {
  final appDocDir = await getTemporaryDirectory();
  _logger.info(appDocDir);
  return CacheOptions(
    // A default store is required for interceptor.
    store: HiveCacheStore('${appDocDir.absolute.path}/hive'),
    // Default.
    policy: CachePolicy.request,
    // Optional. Returns a cached response on error but for statuses 401 & 403.
    hitCacheOnErrorExcept: [401, 403, 404],
    // Optional. Overrides any HTTP directive to delete entry past this duration.
    maxStale: const Duration(days: 7),
    // Default. Allows 3 cache sets and ease cleanup.
    priority: CachePriority.normal,
    // Default. Body and headers encryption with your own algorithm.
    cipher: null,
    // Default. Key builder to retrieve requests.
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    // Default. Allows to cache POST requests.
    // Overriding [keyBuilder] is strongly recommended.
    allowPostMethod: false,
  );
}

class AuthController {
  final String host;
  final Dio client;
  String? encryptionKey;
  Uint8List? symKey;
  Map<String, EcdhKeyResource> ecdhKeys = {};
  AuthController(this.host) : client = Dio(BaseOptions(baseUrl: host)) {
    client.options.headers['accept-encoding'] = 'gzip, deflate, br';
    client.options.headers['charset'] = 'UTF-8';
    client.options.headers['accept'] = 'application/json, text/plain, */*';
    client.options.headers['content-type'] = 'application/json';
    if (_logger.level <= Level.FINER) {
      client.interceptors.add(LogInterceptor());
    }
    if (enableCache) {
      getCacheOptions().then((value) =>
          client.interceptors.add(DioCacheInterceptor(options: value)));
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
    ecdhKeys = {};
    client.options.headers['authorization'] = null;
  }

  Future<bool> isAvailableUsername(String username) async {
    try {
      final response = await client
          .get('/api/register/available/username?username=$username');
      return response.data['available'] == true;
    } on DioError catch (e, s) {
      _logger.warning(e.toString(), e, s);
      return false;
    }
  }

  Future<bool> isAvailableEmail(String email) async {
    try {
      final response =
          await client.get('/api/register/available/email?email=$email');
      return response.data['available'] == true;
    } on DioError catch (e, s) {
      _logger.warning(e.toString(), e, s);
      return false;
    }
  }

  Future<void> register(String username, String email, String password) async {
    final masterKey = await getMasterKey(email, password);
    final masterHash = await getMasterHash(masterKey, password);
    final encryptionKey = await getEncryptionKeys(masterKey);
    final symKey = generateSymKey();
    final encryptedSymKey =
        await symEncrypt(encryptionKey, base64Decode(symKey));
    final request = RegisterRequest(
      email: email,
      username: username,
      master_hash: masterHash,
      sym_key: encryptedSymKey,
      inhibit_login: true,
    );
    final response =
        await client.post('/api/register', data: jsonEncode(request));
    final String? token = response.data?['token'];
    if (token != null) {
      setToken(token);
      this.encryptionKey = encryptionKey;
    }
  }
}

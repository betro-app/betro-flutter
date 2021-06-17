import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import './auth.dart';
import './helper.dart';
import './types/FeedResource.dart';

final _logger = Logger('api/feed');

class FeedController {
  final AuthController auth;
  FeedController(this.auth);

  Future<FeedResource?> fetchHomeFeed([String? after]) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    const limit = 20;
    after ??= base64Encode(utf8.encode(DateTime.now().toIso8601String()));
    final response = await auth.http1Client
        .get<Map<String, dynamic>>('/api/feed?limit=$limit&after=$after');
    final data = response.data;
    if (data != null) {
      return compute(
        defaultTransformFunction,
        TransformPostFeedPayload(encryptionKey, data),
      );
    } else {
      return null;
    }
  }
}

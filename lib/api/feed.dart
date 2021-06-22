import 'dart:convert';
import 'dart:typed_data';

import 'package:betro_dart_lib/sym.dart';
import 'package:flutter/foundation.dart';

import './auth.dart';
import './helper.dart';
import './types/FeedResource.dart';

class FeedController {
  final AuthController auth;
  FeedController(this.auth);

  Future<FeedResource?> fetchHomeFeed([String? after]) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    const limit = 20;
    after ??= base64Encode(utf8.encode(DateTime.now().toIso8601String()));
    final response = await auth.client
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

  Future<FeedResource?> fetchUserPosts(String username, [String? after]) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    const limit = 20;
    after ??= base64Encode(utf8.encode(DateTime.now().toIso8601String()));
    final response = await auth.client.get<Map<String, dynamic>>(
        '/api/user/$username/posts?limit=$limit&after=$after');
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

  Future<FeedResource?> fetchOwnPosts([String? after]) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    const limit = 20;
    after ??= base64Encode(utf8.encode(DateTime.now().toIso8601String()));
    final response = await auth.client.get<Map<String, dynamic>>(
        '/api/account/posts?limit=$limit&after=$after');
    final data = response.data;
    if (data != null) {
      return defaultTransformFunction(
        TransformPostFeedPayload(encryptionKey, data),
        (
          encryptionKey,
          post,
          keys,
          users,
        ) async {
          final key = keys[post.key_id];
          if (key == null) return null;
          final symKey = await symDecrypt(encryptionKey, key);
          return Uint8List.fromList(symKey);
        },
      );
    } else {
      return null;
    }
  }
}

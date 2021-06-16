import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:betro_dart_lib/betro_dart_lib.dart';

import './auth.dart';
import './types/FeedResource.dart';
import './types/PostResponse.dart';
import './types/PostUserResponse.dart';
import './types/ProfileGrantRow.dart';
import './types/PostsFeedResponse.dart';

final _logger = Logger('api/feed');

typedef Future<Uint8List?> PostToSymKeyFunction(PostResponse post,
    Map<String, String> keys, Map<String, PostUserResponse> users);

class FeedController {
  final AuthController auth;
  FeedController(this.auth);

  Future<UserProfile> parseUserGrant(
      String encryptionKey, ProfileGrantRow row) async {
    final response = UserProfile();
    final first_name = row.first_name;
    final last_name = row.last_name;
    final profile_picture = row.profile_picture;
    final public_key = row.public_key;
    final own_private_key = row.own_private_key;
    final encrypted_profile_sym_key = row.encrypted_profile_sym_key;
    if (own_private_key == null) return response;
    final privateKey =
        base64Encode(await symDecrypt(encryptionKey, own_private_key));
    response.own_private_key = privateKey;
    if (public_key == null || encrypted_profile_sym_key == null) {
      return response;
    }
    final derivedKey = await deriveExchangeSymKey(public_key, privateKey);
    final sym_key_bytes = Uint8List.fromList(
        await symDecrypt(derivedKey, encrypted_profile_sym_key));
    final first_name_bytes = first_name == null
        ? null
        : await symDecryptBuffer(sym_key_bytes, first_name);
    final last_name_bytes = last_name == null
        ? null
        : await symDecryptBuffer(sym_key_bytes, last_name);
    final profile_picture_bytes = profile_picture == null
        ? null
        : await symDecryptBuffer(sym_key_bytes, profile_picture);
    response.first_name =
        first_name_bytes == null ? null : utf8.decode(first_name_bytes);
    response.last_name =
        last_name_bytes == null ? null : utf8.decode(last_name_bytes);
    response.profile_picture = profile_picture_bytes;
    return response;
  }

  Future<PostResource> parsePost(PostResponse post, Uint8List sym_key) async {
    final text_content = post.text_content == null
        ? null
        : await symDecryptBuffer(sym_key, post.text_content!);
    final media_content = post.media_content == null
        ? null
        : await symDecryptBuffer(sym_key, post.media_content!);
    return PostResource(
      id: post.id,
      text_content: text_content == null ? null : utf8.decode(text_content),
      media_content: media_content,
      media_encoding: post.media_encoding,
      likes: post.likes,
      is_liked: post.is_liked,
      created_at: post.created_at,
    );
  }

  Future<List<PostResource>?> transformPostFeed(
      PostsFeedResponse feed, PostToSymKeyFunction postToSymKey) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    final posts = <PostResource>[];
    final users = <String, PostResourceUser>{};
    for (final user_id in feed.users.keys) {
      final user = feed.users[user_id];
      if (user != null) {
        final parsedUser = await parseUserGrant(encryptionKey, user);
        users[user_id] = PostResourceUser(
          username: user.username,
          first_name: parsedUser.first_name,
          last_name: parsedUser.last_name,
          profile_picture: parsedUser.profile_picture,
        );
      }
    }

    for (var post in feed.posts) {
      final sym_key = await postToSymKey(post, feed.keys, feed.users);
      if (sym_key != null) {
        final parsedPost = await parsePost(post, sym_key);
        parsedPost.user = users[post.user_id];
        posts.add(parsedPost);
      }
    }

    return posts;
  }

  Future<Uint8List?> feedDefaultTransform(PostResponse post,
      Map<String, String> keys, Map<String, PostUserResponse> users) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    final user = users[post.user_id];
    if (user == null) return null;
    final own_private_key = user.own_private_key;
    final public_key = user.public_key;
    if (own_private_key == null || public_key == null) {
      return null;
    }
    final privateKey = await symDecrypt(encryptionKey, own_private_key);
    final derivedKey =
        await deriveExchangeSymKey(public_key, base64Encode(privateKey));
    final encryptedSymKey = keys[post.key_id];
    if (encryptedSymKey == null) return null;
    final symKey = await symDecrypt(derivedKey, encryptedSymKey);
    return Uint8List.fromList(symKey);
  }

  Future<FeedResource?> fetchHomeFeed([String? after]) async {
    const limit = 5;
    after ??= base64Encode(utf8.encode(DateTime.now().toIso8601String()));
    final response =
        await auth.http1Client.get('/api/feed?limit=$limit&after=$after');
    final data = response.data;
    if (data != null) {
      final feed = PostsFeedResponse.fromJson(data);
      final posts = await transformPostFeed(feed, feedDefaultTransform);
      return FeedResource(
        data: posts ?? [],
        pageInfo: feed.pageInfo,
      );
    }
  }
}

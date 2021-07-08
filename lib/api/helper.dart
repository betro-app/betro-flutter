import 'dart:convert';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:betro_dart_lib/betro_dart_lib.dart';

import './types/FeedResource.dart';
import './types/PostResource.dart';
import './types/PostResourceUser.dart';
import './types/PostResponse.dart';
import './types/ProfileGrantRow.dart';
import './types/PostUserResponse.dart';
import './types/PostsFeedResponse.dart';

final _logger = Logger('api/helper');

typedef PostToSymKeyFunction = Future<Uint8List?> Function(
    String encryptionKey,
    PostResponse post,
    Map<String, String> keys,
    Map<String, PostUserResponse> users);

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
  response.profile_picture = profile_picture_bytes == null
      ? null
      : Uint8List.fromList(profile_picture_bytes);
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
    user_id: post.user_id,
    text_content: text_content == null ? null : utf8.decode(text_content),
    media_content:
        media_content == null ? null : Uint8List.fromList(media_content),
    media_encoding: post.media_encoding,
    likes: post.likes ?? 0,
    is_liked: post.is_liked ?? false,
    created_at: post.created_at,
  );
}

Future<List<PostResource>?> transformPostFeed(
    String encryptionKey, PostsFeedResponse feed,
    [PostToSymKeyFunction postToSymKey = feedDefaultTransform]) async {
  final users = <String, PostResourceUser>{};
  final userFutures = <String, Future<UserProfile>>{};
  for (final user_id in feed.users.keys) {
    final user = feed.users[user_id];
    if (user != null) {
      userFutures[user_id] = parseUserGrant(encryptionKey, user);
    }
  }
  await Future.wait(userFutures.values);
  for (final user_id in userFutures.keys) {
    final user = feed.users[user_id];
    if (user != null) {
      final parsedUser = await userFutures[user_id];
      if (parsedUser != null) {
        final profile_picture = parsedUser.profile_picture;
        users[user_id] = PostResourceUser(
          username: user.username,
          first_name: parsedUser.first_name,
          last_name: parsedUser.last_name,
          profile_picture: profile_picture == null
              ? null
              : Uint8List.fromList(profile_picture),
        );
      }
    }
  }
  _logger.finest(users);

  final postFutures = <Future<PostResource>>[];

  for (var post in feed.posts) {
    final sym_key =
        await postToSymKey(encryptionKey, post, feed.keys, feed.users);
    if (sym_key != null) {
      postFutures.add(parsePost(post, sym_key));
    }
  }
  final posts = await Future.wait(postFutures);
  for (var post in posts) {
    post.user = users[post.user_id];
  }

  return posts;
}

Future<Uint8List?> feedDefaultTransform(
  String encryptionKey,
  PostResponse post,
  Map<String, String> keys,
  Map<String, PostUserResponse> users,
) async {
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

class TransformPostFeedPayload {
  String encryptionKey;
  Map<String, dynamic> feedJson;

  TransformPostFeedPayload(this.encryptionKey, this.feedJson);
}

Future<FeedResource> defaultTransformFunction(TransformPostFeedPayload payload,
    [PostToSymKeyFunction postToSymKey = feedDefaultTransform]) async {
  final feed = PostsFeedResponse.fromJson(payload.feedJson);
  final posts =
      await transformPostFeed(payload.encryptionKey, feed, postToSymKey);
  _logger.finest(posts);
  return FeedResource(
    data: posts ?? [],
    pageInfo: feed.pageInfo,
  );
}

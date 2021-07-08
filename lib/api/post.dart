import 'dart:convert';
import 'dart:typed_data';

import 'package:betro_dart_lib/betro_dart_lib.dart';

import './auth.dart';
import './helper.dart';
import './types/PostResource.dart';
import './types/PostResourceUser.dart';
import './types/GetPostResponse.dart';
import './types/LikeResponse.dart';
import './types/PostResponse.dart';
import './types/CreatePostRequest.dart';

class PostController {
  final AuthController auth;
  PostController(this.auth);

  Future<PostResource?> getPost(String id) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    final response =
        await auth.client.get<Map<String, dynamic>>('/api/post/$id');
    final data = response.data;
    if (data == null) {
      return null;
    }
    final resp = GetPostResponse.fromJson(data);
    final parsedUser = await parseUserGrant(encryptionKey, resp.user);
    final user = PostResourceUser(
      username: resp.user.username,
      first_name: parsedUser.first_name,
      last_name: parsedUser.last_name,
      profile_picture: parsedUser.profile_picture,
    );
    final own_private_key = resp.user.own_private_key;
    final public_key = resp.user.public_key;
    if (public_key == null || own_private_key == null) return null;
    final privateKey = await symDecrypt(encryptionKey, own_private_key);
    final derivedKey = await deriveExchangeSymKey(
      public_key,
      base64Encode(privateKey),
    );
    final symKey = await symDecrypt(derivedKey, resp.post.key);
    final parsedPost = await parsePost(resp.post, Uint8List.fromList(symKey));
    parsedPost.user_id = id;
    parsedPost.user = user;
    return parsedPost;
  }

  Future<LikeResponse> like(String id) async {
    final response = await auth.client.post('/api/post/$id/like');
    return LikeResponse.fromJson(response.data);
  }

  Future<LikeResponse> unlike(String id) async {
    final response = await auth.client.post('/api/post/$id/unlike');
    return LikeResponse.fromJson(response.data);
  }

  Future<PostResponse?> createPost(
    String group_id,
    String encrypted_sym_key, {
    String? text,
    Uint8List? media,
  }) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    final sym_key = await symDecrypt(encryptionKey, encrypted_sym_key);
    String? encryptedText;
    if (text != null) {
      encryptedText = await symEncrypt(
        base64Encode(sym_key),
        utf8.encode(text),
      );
    }
    String? encryptedMedia;
    if (media != null) {
      encryptedMedia = await symEncrypt(
        base64Encode(sym_key),
        media,
      );
    }
    final req = CreatePostRequest(
      group_id: group_id,
      text_content: encryptedText,
      media_content: encryptedMedia,
    );
    final response = await auth.client.post('/api/post', data: jsonEncode(req));
    return PostResponse.fromJson(response.data);
  }
}

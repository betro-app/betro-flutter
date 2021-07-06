import 'dart:typed_data';

import 'PageInfo.dart';

class FeedResource {
  final List<PostResource> data;
  final PageInfo pageInfo;

  FeedResource({
    required this.data,
    required this.pageInfo,
  });
}

class UserProfile {
  String? first_name;
  String? last_name;
  Uint8List? profile_picture;
  String? own_private_key;

  UserProfile({
    this.first_name,
    this.last_name,
    this.profile_picture,
    this.own_private_key,
  });
}

class PostResource {
  final String id;
  String user_id;
  final String? text_content;
  final Uint8List? media_content;
  final String? media_encoding;
  final int likes;
  final bool is_liked;
  PostResourceUser? user;
  final DateTime created_at;

  PostResource({
    required this.id,
    required this.user_id,
    this.text_content,
    this.media_content,
    this.media_encoding,
    required this.likes,
    required this.is_liked,
    this.user,
    required this.created_at,
  });
}

class PostResourceUser {
  final String username;
  final String? first_name;
  final String? last_name;
  final Uint8List? profile_picture;

  PostResourceUser({
    required this.username,
    this.first_name,
    this.last_name,
    this.profile_picture,
  });
}

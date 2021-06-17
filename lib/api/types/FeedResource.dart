import 'dart:typed_data';

import 'PageInfo.dart';

class FeedResource {
  List<PostResource> data;
  PageInfo pageInfo;

  FeedResource({
    required this.data,
    required this.pageInfo,
  });
}

class UserProfile {
  String? first_name;
  String? last_name;
  List<int>? profile_picture;
  String? own_private_key;

  UserProfile({
    this.first_name,
    this.last_name,
    this.profile_picture,
    this.own_private_key,
  });
}

class PostResource {
  String id;
  String user_id;
  String? text_content;
  Uint8List? media_content;
  String? media_encoding;
  int likes;
  bool is_liked;
  PostResourceUser? user;
  DateTime created_at;

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
  String username;
  String? first_name;
  String? last_name;
  Uint8List? profile_picture;

  PostResourceUser({
    required this.username,
    this.first_name,
    this.last_name,
    this.profile_picture,
  });
}

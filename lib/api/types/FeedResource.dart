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
  String? text_content;
  List<int>? media_content;
  String? media_encoding;
  int likes;
  bool is_liked;
  PostResourceUser? user;
  DateTime created_at;

  PostResource({
    required this.id,
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
  List<int>? profile_picture;

  PostResourceUser({
    required this.username,
    this.first_name,
    this.last_name,
    this.profile_picture,
  });
}

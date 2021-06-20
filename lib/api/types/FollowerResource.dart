import 'dart:typed_data';

class FollowerResource {
  String follow_id;
  String group_id;
  bool group_is_default;
  String group_name;
  String user_id;
  String username;
  bool is_following;
  bool is_following_approved;
  String? public_key;
  String? first_name;
  String? last_name;
  Uint8List? profile_picture;

  FollowerResource({
    required this.follow_id,
    required this.group_id,
    required this.group_is_default,
    required this.group_name,
    required this.user_id,
    required this.username,
    required this.is_following,
    required this.is_following_approved,
    this.public_key,
    this.first_name,
    this.last_name,
    this.profile_picture,
  });
}

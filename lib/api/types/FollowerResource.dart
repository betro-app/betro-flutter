import 'dart:typed_data';

class FollowerResource {
  final String follow_id;
  final String group_id;
  final bool group_is_default;
  final String group_name;
  final String user_id;
  final String username;
  final bool is_following;
  final bool is_following_approved;
  final String? public_key;
  final String? first_name;
  final String? last_name;
  final Uint8List? profile_picture;

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

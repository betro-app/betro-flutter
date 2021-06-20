import 'dart:typed_data';

class FolloweeResource {
  final String follow_id;
  final bool is_approved;
  final String user_id;
  final String username;
  final String? public_key;
  final String? first_name;
  final String? last_name;
  final Uint8List? profile_picture;

  FolloweeResource({
    required this.follow_id,
    required this.is_approved,
    required this.user_id,
    required this.username,
    this.public_key,
    this.first_name,
    this.last_name,
    this.profile_picture,
  });
}

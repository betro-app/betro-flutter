import 'dart:typed_data';

class ApprovalResource {
  final String id;
  final String follower_id;
  final String username;
  final DateTime created_at;
  final String? first_name;
  final String? last_name;
  final Uint8List? profile_picture;
  final String? public_key;
  final String? own_key_id;
  final String? own_private_key;

  ApprovalResource({
    required this.id,
    required this.follower_id,
    required this.username,
    required this.created_at,
    this.first_name,
    this.last_name,
    this.profile_picture,
    this.public_key,
    this.own_key_id,
    this.own_private_key,
  });
}

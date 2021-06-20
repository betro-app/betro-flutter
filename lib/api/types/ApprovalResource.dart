import 'dart:typed_data';

class ApprovalResource {
  String id;
  String follower_id;
  String username;
  DateTime created_at;
  String? first_name;
  String? last_name;
  Uint8List? profile_picture;
  String? public_key;
  String? own_key_id;
  String? own_private_key;

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

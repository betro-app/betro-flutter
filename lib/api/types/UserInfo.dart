import 'dart:typed_data';

class UserInfo {
  final String id;
  final bool is_following;
  final bool is_approved;
  final String username;
  final String? public_key;
  final String? first_name;
  final String? last_name;
  final Uint8List? profile_picture;

  UserInfo({
    required this.id,
    required this.is_following,
    required this.is_approved,
    required this.username,
    this.public_key,
    this.first_name,
    this.last_name,
    this.profile_picture,
  });
}

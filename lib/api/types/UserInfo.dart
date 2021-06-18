import 'dart:typed_data';

class UserInfo {
  String id;
  bool is_following;
  bool is_approved;
  String username;
  String? public_key;
  String? first_name;
  String? last_name;
  Uint8List? profile_picture;

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

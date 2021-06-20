import 'dart:typed_data';

class SearchUserResource {
  final String id;
  final String username;
  final bool is_following;
  final bool is_following_approved;
  final String? public_key;
  final String? first_name;
  final String? last_name;
  final Uint8List? profile_picture;

  SearchUserResource({
    required this.id,
    required this.username,
    required this.is_following,
    required this.is_following_approved,
    this.public_key,
    this.first_name,
    this.last_name,
    this.profile_picture,
  });
}

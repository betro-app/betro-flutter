import 'dart:typed_data';

class ConversationResource {
  final String id;
  final String user_id;
  final String username;
  final String? first_name;
  final String? last_name;
  final Uint8List? profile_picture;
  final String? public_key;
  final String? own_key_id;
  final String? own_private_key;

  ConversationResource({
    required this.id,
    required this.user_id,
    required this.username,
    this.first_name,
    this.last_name,
    this.profile_picture,
    this.public_key,
    this.own_key_id,
    this.own_private_key,
  });
}

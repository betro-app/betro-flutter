import 'package:json_annotation/json_annotation.dart';

import 'ProfileGrantRow.dart';
part 'ConversationResponse.g.dart';

@JsonSerializable()
class ConversationResponse extends ProfileGrantRow {
  final String id;
  final String user_id;
  final String username;

  ConversationResponse({
    required this.id,
    required this.user_id,
    required this.username,
    String? first_name,
    String? last_name,
    String? profile_picture,
    String? public_key,
    String? own_key_id,
    String? own_private_key,
    String? encrypted_profile_sym_key,
  }) : super(
          first_name: first_name,
          last_name: last_name,
          profile_picture: profile_picture,
          public_key: public_key,
          own_key_id: own_key_id,
          own_private_key: own_private_key,
          encrypted_profile_sym_key: encrypted_profile_sym_key,
        );
  factory ConversationResponse.fromJson(Map<String, dynamic> json) =>
      _$ConversationResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ConversationResponseToJson(this);
}

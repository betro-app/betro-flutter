import 'package:json_annotation/json_annotation.dart';

import './ProfileGrantRow.dart';
part 'ApprovalResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class ApprovalResponse extends ProfileGrantRow {
  String id;
  String follower_id;
  String username;
  DateTime created_at;

  ApprovalResponse({
    required this.id,
    required this.follower_id,
    required this.username,
    required this.created_at,
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
  factory ApprovalResponse.fromJson(Map<String, dynamic> json) =>
      _$ApprovalResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ApprovalResponseToJson(this);
}

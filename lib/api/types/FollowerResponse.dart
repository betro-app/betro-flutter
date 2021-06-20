import 'package:json_annotation/json_annotation.dart';

import './ProfileGrantRow.dart';
part 'FollowerResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class FollowerResponse extends ProfileGrantRow {
  String user_id;
  String follow_id;
  String username;
  String group_id;
  String group_name;
  bool group_is_default;
  bool is_following;
  bool is_following_approved;

  FollowerResponse({
    required this.user_id,
    required this.follow_id,
    required this.username,
    required this.group_id,
    required this.group_name,
    required this.group_is_default,
    required this.is_following,
    required this.is_following_approved,
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
  factory FollowerResponse.fromJson(Map<String, dynamic> json) =>
      _$FollowerResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FollowerResponseToJson(this);
}

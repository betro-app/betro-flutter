import 'package:json_annotation/json_annotation.dart';

part 'FollowUserRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class FollowUserRequest {
  String followee_id;
  String own_key_id;
  String followee_key_id;
  String? encrypted_profile_sym_key;

  FollowUserRequest({
    required this.followee_id,
    required this.own_key_id,
    required this.followee_key_id,
    required this.encrypted_profile_sym_key,
  });
  factory FollowUserRequest.fromJson(Map<String, dynamic> json) =>
      _$FollowUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FollowUserRequestToJson(this);
}

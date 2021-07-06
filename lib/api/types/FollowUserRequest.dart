import 'package:json_annotation/json_annotation.dart';

part 'FollowUserRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class FollowUserRequest {
  final String followee_id;
  final String own_key_id;
  final String followee_key_id;
  final String? encrypted_profile_sym_key;

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

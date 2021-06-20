import 'package:json_annotation/json_annotation.dart';

part 'ApproveUserRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class ApproveUserRequest {
  String follow_id;
  String group_id;
  String encrypted_group_sym_key;
  String own_key_id;
  String? encrypted_profile_sym_key;

  ApproveUserRequest({
    required this.follow_id,
    required this.group_id,
    required this.encrypted_group_sym_key,
    required this.own_key_id,
    required this.encrypted_profile_sym_key,
  });
  factory ApproveUserRequest.fromJson(Map<String, dynamic> json) =>
      _$ApproveUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ApproveUserRequestToJson(this);
}

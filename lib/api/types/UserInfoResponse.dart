import 'package:json_annotation/json_annotation.dart';

import './ProfileGrantRow.dart';
part 'UserInfoResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class UserInfoResponse extends ProfileGrantRow {
  String id;
  String username;
  bool is_following;
  bool is_approved;

  UserInfoResponse({
    required this.id,
    required this.username,
    required this.is_following,
    required this.is_approved,
  });
  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UserInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoResponseToJson(this);
}

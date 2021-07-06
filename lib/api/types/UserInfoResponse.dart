import 'package:json_annotation/json_annotation.dart';

import './ProfileGrantRow.dart';
part 'UserInfoResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class UserInfoResponse extends ProfileGrantRow {
  final String id;
  final String username;
  final bool is_following;
  final bool is_approved;

  UserInfoResponse({
    required this.id,
    required this.username,
    required this.is_following,
    required this.is_approved,
  });
  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UserInfoResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserInfoResponseToJson(this);
}

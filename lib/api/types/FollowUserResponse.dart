import 'package:json_annotation/json_annotation.dart';

part 'FollowUserResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class FollowUserResponse {
  final bool is_following;
  final bool is_approved;
  final String email;

  FollowUserResponse(
    this.is_following,
    this.is_approved,
    this.email,
  );
  factory FollowUserResponse.fromJson(Map<String, dynamic> json) =>
      _$FollowUserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FollowUserResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'UserProfilePutRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class UserProfilePutRequest {
  String? profile_picture;
  String? first_name;
  String? last_name;

  UserProfilePutRequest({
    this.profile_picture,
    this.first_name,
    this.last_name,
  });
  factory UserProfilePutRequest.fromJson(Map<String, dynamic> json) =>
      _$UserProfilePutRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfilePutRequestToJson(this);
}

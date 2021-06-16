import 'package:json_annotation/json_annotation.dart';

part 'UserProfilePostRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class UserProfilePostRequest {
  String? sym_key;
  String? profile_picture;
  String? first_name;
  String? last_name;

  UserProfilePostRequest({
    this.sym_key,
    this.profile_picture,
    this.first_name,
    this.last_name,
  });
  factory UserProfilePostRequest.fromJson(Map<String, dynamic> json) =>
      _$UserProfilePostRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfilePostRequestToJson(this);
}

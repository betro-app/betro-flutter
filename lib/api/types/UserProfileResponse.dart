import 'package:json_annotation/json_annotation.dart';

part 'UserProfileResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class UserProfileResponse {
  String? sym_key;
  String? profile_picture;
  String? first_name;
  String? last_name;

  UserProfileResponse({
    this.sym_key,
    this.profile_picture,
    this.first_name,
    this.last_name,
  });
  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileResponseToJson(this);
}

class UserProfile {
  String? sym_key;
  List<int>? profile_picture;
  String? first_name;
  String? last_name;

  UserProfile({
    this.sym_key,
    this.profile_picture,
    this.first_name,
    this.last_name,
  });
}

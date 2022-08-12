import 'package:json_annotation/json_annotation.dart';

part 'LoginRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class LoginRequest {
  final String email;
  final String master_hash;
  final String device_display_name;

  LoginRequest(this.email, this.master_hash, this.device_display_name);
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

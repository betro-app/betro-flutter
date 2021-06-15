import 'package:json_annotation/json_annotation.dart';

part 'LoginRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class LoginRequest {
  String email;
  String master_hash;

  LoginRequest(this.email, this.master_hash);
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

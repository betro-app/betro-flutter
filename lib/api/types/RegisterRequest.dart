import 'package:json_annotation/json_annotation.dart';

part 'RegisterRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class RegisterRequest {
  final String username;
  final String email;
  final String master_hash;
  final String sym_key;
  final bool inhibit_login;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.master_hash,
    required this.sym_key,
    this.inhibit_login = false,
  });
  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

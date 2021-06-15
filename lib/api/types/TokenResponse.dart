import 'package:json_annotation/json_annotation.dart';

part 'TokenResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class TokenResponse {
  String token;

  TokenResponse(this.token);
  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}

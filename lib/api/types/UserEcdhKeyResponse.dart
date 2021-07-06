import 'package:json_annotation/json_annotation.dart';

part 'UserEcdhKeyResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class UserEcdhKeyResponse {
  final String id;
  final String public_key;

  UserEcdhKeyResponse({
    required this.id,
    required this.public_key,
  });
  factory UserEcdhKeyResponse.fromJson(Map<String, dynamic> json) =>
      _$UserEcdhKeyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserEcdhKeyResponseToJson(this);
}

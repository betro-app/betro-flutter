import 'package:json_annotation/json_annotation.dart';

part 'EcdhKeyResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class EcdhKeyResponse {
  String id;
  String user_id;
  String public_key;
  String private_key;
  bool claimed;

  EcdhKeyResponse({
    required this.id,
    required this.user_id,
    required this.public_key,
    required this.private_key,
    required this.claimed,
  });
  factory EcdhKeyResponse.fromJson(Map<String, dynamic> json) =>
      _$EcdhKeyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EcdhKeyResponseToJson(this);
}

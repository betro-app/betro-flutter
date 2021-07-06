import 'package:json_annotation/json_annotation.dart';

part 'EcPairRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class EcPairRequest {
  final String public_key;
  final String private_key;

  EcPairRequest(
    this.public_key,
    this.private_key,
  );
  factory EcPairRequest.fromJson(Map<String, dynamic> json) =>
      _$EcPairRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EcPairRequestToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'KeysResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class KeysResponse {
  final int ecdh_max_keys;
  final int ecdh_unclaimed_keys;
  final String sym_key;

  KeysResponse(this.sym_key, this.ecdh_max_keys, this.ecdh_unclaimed_keys);
  factory KeysResponse.fromJson(Map<String, dynamic> json) =>
      _$KeysResponseFromJson(json);
  Map<String, dynamic> toJson() => _$KeysResponseToJson(this);
}

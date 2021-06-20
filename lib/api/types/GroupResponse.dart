import 'package:json_annotation/json_annotation.dart';

part 'GroupResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class GroupResponse {
  String id;
  String sym_key;
  String name;
  bool is_default;

  GroupResponse({
    required this.id,
    required this.sym_key,
    required this.name,
    required this.is_default,
  });
  factory GroupResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GroupResponseToJson(this);
}

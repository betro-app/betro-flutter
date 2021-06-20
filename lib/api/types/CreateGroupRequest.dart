import 'package:json_annotation/json_annotation.dart';

part 'CreateGroupRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class CreateGroupRequest {
  String sym_key;
  String name;
  bool is_default;

  CreateGroupRequest({
    required this.sym_key,
    required this.name,
    required this.is_default,
  });
  factory CreateGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateGroupRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateGroupRequestToJson(this);
}

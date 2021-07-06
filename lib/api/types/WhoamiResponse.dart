import 'package:json_annotation/json_annotation.dart';

part 'WhoamiResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class WhoamiResponse {
  final String? user_id;
  final String? username;
  final String? email;
  final String? first_name;
  final String? last_name;

  WhoamiResponse(
      this.user_id, this.username, this.email, this.first_name, this.last_name);
  factory WhoamiResponse.fromJson(Map<String, dynamic> json) =>
      _$WhoamiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WhoamiResponseToJson(this);
}

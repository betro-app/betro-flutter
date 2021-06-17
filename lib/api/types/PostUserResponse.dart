import 'package:json_annotation/json_annotation.dart';

import 'ProfileGrantRow.dart';

part 'PostUserResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class PostUserResponse extends ProfileGrantRow {
  String username;

  PostUserResponse({
    required this.username,
  });
  factory PostUserResponse.fromJson(Map<String, dynamic> json) =>
      _$PostUserResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PostUserResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'dart:typed_data';

part 'PostResourceUser.g.dart';

@JsonSerializable()
class PostResourceUser {
  final String username;
  final String? first_name;
  final String? last_name;
  @JsonKey(ignore: true)
  final Uint8List? profile_picture;

  PostResourceUser({
    required this.username,
    this.first_name,
    this.last_name,
    this.profile_picture,
  });
  factory PostResourceUser.fromJson(Map<String, dynamic> json) =>
      _$PostResourceUserFromJson(json);
  Map<String, dynamic> toJson() => _$PostResourceUserToJson(this);
}

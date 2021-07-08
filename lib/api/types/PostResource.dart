import 'package:json_annotation/json_annotation.dart';
import 'dart:typed_data';

import './PostResourceUser.dart';

part 'PostResource.g.dart';

@JsonSerializable()
class PostResource {
  final String id;
  String user_id;
  final String? text_content;
  @JsonKey(ignore: true)
  final Uint8List? media_content;
  final String? media_encoding;
  final int likes;
  final bool is_liked;
  PostResourceUser? user;
  final DateTime created_at;

  PostResource({
    required this.id,
    required this.user_id,
    this.text_content,
    this.media_content,
    this.media_encoding,
    required this.likes,
    required this.is_liked,
    this.user,
    required this.created_at,
  });
  factory PostResource.fromJson(Map<String, dynamic> json) =>
      _$PostResourceFromJson(json);
  Map<String, dynamic> toJson() => _$PostResourceToJson(this);
}

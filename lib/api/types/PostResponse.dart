import 'package:json_annotation/json_annotation.dart';

part 'PostResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class PostResponse {
  final String id;
  final String user_id;
  final String? media_content;
  final String? media_encoding;
  final String? text_content;
  final String key_id;
  final int? likes;
  final bool? is_liked;
  final DateTime created_at;

  PostResponse({
    required this.id,
    required this.user_id,
    this.media_content,
    this.media_encoding,
    this.text_content,
    required this.key_id,
    this.likes,
    this.is_liked,
    required this.created_at,
  });
  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PostResponseToJson(this);
}

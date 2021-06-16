import 'package:json_annotation/json_annotation.dart';

part 'PostResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class PostResponse {
  String id;
  String user_id;
  String? media_content;
  String? media_encoding;
  String? text_content;
  String key_id;
  int likes;
  bool is_liked;
  DateTime created_at;

  PostResponse({
    required this.id,
    required this.user_id,
    this.media_content,
    this.media_encoding,
    this.text_content,
    required this.key_id,
    required this.likes,
    required this.is_liked,
    required this.created_at,
  });
  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PostResponseToJson(this);
}

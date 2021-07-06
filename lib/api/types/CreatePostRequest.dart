import 'package:json_annotation/json_annotation.dart';

part 'CreatePostRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class CreatePostRequest {
  final String group_id;
  final String? text_content;
  final String? media_content;

  CreatePostRequest({
    required this.group_id,
    this.text_content,
    this.media_content,
  });
  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePostRequestToJson(this);
}

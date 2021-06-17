import 'package:json_annotation/json_annotation.dart';

part 'CreatePostRequest.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class CreatePostRequest {
  String group_id;
  String? text_content;
  String? media_content;

  CreatePostRequest({
    required this.group_id,
    this.text_content,
    this.media_content,
  });
  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePostRequestToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import './PostResponse.dart';
import './PostUserResponse.dart';

part 'GetPostResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class GetPostResponse {
  final GetPost post;
  PostUserResponse user;

  GetPostResponse(this.post, this.user);
  factory GetPostResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPostResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetPostResponseToJson(this);
}

@JsonSerializable()
class GetPost extends PostResponse {
  final String key;

  GetPost({
    required this.key,
    required String id,
    required String user_id,
    String? media_content,
    String? media_encoding,
    String? text_content,
    required String key_id,
    required int likes,
    required bool is_liked,
    required DateTime created_at,
  }) : super(
          id: id,
          user_id: user_id,
          media_content: media_content,
          media_encoding: media_encoding,
          text_content: text_content,
          key_id: key_id,
          likes: likes,
          is_liked: is_liked,
          created_at: created_at,
        );
  factory GetPost.fromJson(Map<String, dynamic> json) =>
      _$GetPostFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GetPostToJson(this);
}

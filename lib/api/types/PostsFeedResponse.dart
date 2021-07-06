import 'package:json_annotation/json_annotation.dart';

import 'PostUserResponse.dart';
import 'PostResponse.dart';
import 'PageInfo.dart';

part 'PostsFeedResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class PostsFeedResponse {
  final List<PostResponse> posts;
  final Map<String, PostUserResponse> users;
  final Map<String, String> keys;
  final PageInfo pageInfo;

  PostsFeedResponse({
    required this.posts,
    required this.users,
    required this.keys,
    required this.pageInfo,
  });
  factory PostsFeedResponse.fromJson(Map<String, dynamic> json) =>
      _$PostsFeedResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PostsFeedResponseToJson(this);
}

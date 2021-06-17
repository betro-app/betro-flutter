import 'package:json_annotation/json_annotation.dart';

part 'LikeResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class LikeResponse {
  bool liked;
  int? likes;

  LikeResponse(this.liked, this.likes);
  factory LikeResponse.fromJson(Map<String, dynamic> json) =>
      _$LikeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LikeResponseToJson(this);
}

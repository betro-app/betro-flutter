import 'package:json_annotation/json_annotation.dart';

part 'CountResponse.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class CountResponse {
  final int notifications;
  final int settings;
  final int groups;
  final int followers;
  final int followees;
  final int approvals;
  final int posts;

  CountResponse(
    this.notifications,
    this.settings,
    this.groups,
    this.followers,
    this.followees,
    this.approvals,
    this.posts,
  );
  factory CountResponse.fromJson(Map<String, dynamic> json) =>
      _$CountResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CountResponseToJson(this);
}

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
  final int conversations;

  CountResponse({
    required this.notifications,
    required this.settings,
    required this.groups,
    required this.followers,
    required this.followees,
    required this.approvals,
    required this.posts,
    required this.conversations,
  });
  factory CountResponse.fromJson(Map<String, dynamic> json) =>
      _$CountResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CountResponseToJson(this);
}

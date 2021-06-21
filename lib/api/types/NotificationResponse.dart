import 'package:json_annotation/json_annotation.dart';

part 'NotificationResponse.g.dart';

enum NotificationActions { notification_on_approved, notification_on_followed }

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class NotificationResponse {
  String id;
  String user_id;
  NotificationActions action;
  String content;
  bool read;
  dynamic payload;
  DateTime created_at;

  NotificationResponse({
    required this.id,
    required this.user_id,
    required this.action,
    required this.content,
    required this.read,
    required this.payload,
    required this.created_at,
  });
  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);

  NotificationResponse copyWith({
    String? id,
    String? user_id,
    NotificationActions? action,
    String? content,
    bool? read,
    dynamic payload,
    DateTime? created_at,
  }) =>
      NotificationResponse(
        id: id ?? this.id,
        user_id: user_id ?? this.user_id,
        action: action ?? this.action,
        content: content ?? this.content,
        read: read ?? this.read,
        payload: payload ?? this.payload,
        created_at: created_at ?? this.created_at,
      );
}

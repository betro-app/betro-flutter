import 'package:json_annotation/json_annotation.dart';

part 'MessageResponse.g.dart';

@JsonSerializable()
class MessageResponse {
  final String id;
  final String conversation_id;
  final String sender_id;
  final String message;
  final DateTime created_at;
  MessageResponse({
    required this.id,
    required this.conversation_id,
    required this.sender_id,
    required this.message,
    required this.created_at,
  });
  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessageResponseToJson(this);
}

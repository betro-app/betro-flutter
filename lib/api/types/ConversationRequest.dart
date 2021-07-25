import 'package:json_annotation/json_annotation.dart';

part 'ConversationRequest.g.dart';

@JsonSerializable()
class ConversationRequest {
  final String receiver_id;
  final String sender_key_id;
  final String receiver_key_id;

  ConversationRequest({
    required this.receiver_id,
    required this.sender_key_id,
    required this.receiver_key_id,
  });
  factory ConversationRequest.fromJson(Map<String, dynamic> json) =>
      _$ConversationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationRequestToJson(this);
}

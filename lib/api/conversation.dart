import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logging/logging.dart';
import 'package:betro_dart_lib/betro_dart_lib.dart';

import './types/PaginatedResponse.dart';
import './auth.dart';
import './helper.dart';
import './types/ConversationResponse.dart';
import './types/ConversationResource.dart';
import './types/ConversationRequest.dart';
import './types/MessageResponse.dart';

final _logger = Logger('api/conversation');

class ConversationController {
  final AuthController auth;
  ConversationController(this.auth);

  Future<PaginatedResponse<ConversationResource>?> fetchConversations([
    String? after,
  ]) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    const limit = 20;
    after ??= base64Encode(utf8.encode(DateTime.now().toIso8601String()));
    final response = await auth.client
        .get<Map<String, dynamic>>('/api/messages?limit=$limit&after=$after');
    final data = response.data;
    if (data == null) return null;
    final resp = PaginatedResponse<ConversationResponse>.fromJson(
        data, (json) => ConversationResponse.fromJson(json));
    final list = <ConversationResource>[];
    for (var item in resp.data) {
      final user = await parseUserGrant(encryptionKey, item);
      list.add(ConversationResource(
        id: item.id,
        user_id: item.user_id,
        username: item.username,
        first_name: user.first_name,
        last_name: user.last_name,
        profile_picture: user.profile_picture,
        public_key: item.public_key,
        own_key_id: item.own_key_id,
        own_private_key: user.own_private_key,
      ));
    }
    final conversations = PaginatedResponse<ConversationResource>(
      data: list,
      next: resp.next,
      limit: resp.limit,
      total: resp.total,
      after: resp.after,
    );
    return conversations;
  }

  Future<ConversationResource?> fetchConversation(
    String conversation_id,
  ) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    final response = await auth.client
        .get<Map<String, dynamic>>('/api/messages/$conversation_id');
    final data = response.data;
    if (data == null) return null;
    final item = ConversationResponse.fromJson(data);
    final user = await parseUserGrant(encryptionKey, item);
    final conversation = ConversationResource(
      id: item.id,
      user_id: item.user_id,
      username: item.username,
      first_name: user.first_name,
      last_name: user.last_name,
      profile_picture: user.profile_picture,
      public_key: item.public_key,
      own_key_id: item.own_key_id,
      own_private_key: user.own_private_key,
    );
    return conversation;
  }

  Future<ConversationResource?> createConversation(
    String user_id,
    String user_key_id,
  ) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    final ownKeyPair = auth.ecdhKeys.entries.first;
    final req = ConversationRequest(
      receiver_id: user_id,
      sender_key_id: ownKeyPair.value.id,
      receiver_key_id: user_key_id,
    );
    final response = await auth.client
        .post<Map<String, dynamic>>('/api/messages', data: jsonEncode(req));
    final data = response.data;
    if (data == null) return null;
    final item = ConversationResponse.fromJson(data);
    final user = await parseUserGrant(encryptionKey, item);
    final conversation = ConversationResource(
      id: item.id,
      user_id: item.user_id,
      username: item.username,
      first_name: user.first_name,
      last_name: user.last_name,
      profile_picture: user.profile_picture,
      public_key: item.public_key,
      own_key_id: item.own_key_id,
      own_private_key: user.own_private_key,
    );
    return conversation;
  }

  Future<MessageResponse?> sendMessage(String conversation_id,
      String private_key, String public_key, String text_content) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    final derivedKey = await deriveExchangeSymKey(
      public_key,
      private_key,
    );
    final encryptedMessage = await symEncrypt(
      derivedKey,
      Utf8Encoder().convert(text_content),
    );
    final req = <String, dynamic>{};
    req['message'] = encryptedMessage;
    final response = await auth.client.post<Map<String, dynamic>>(
      '/api/messages/$conversation_id/messages',
      data: jsonEncode(req),
    );
    final data = response.data;
    if (data == null) return null;
    final item = MessageResponse.fromJson(data);
    final message = await symDecrypt(derivedKey, item.message);
    return MessageResponse(
      id: item.id,
      conversation_id: item.conversation_id,
      sender_id: item.sender_id,
      message: Utf8Decoder().convert(message),
      created_at: item.created_at,
    );
  }

  Future<PaginatedResponse<MessageResponse>?> fetchMessages(
    String conversation_id,
    String private_key,
    String public_key, [
    String? after,
  ]) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    final derivedKey = await deriveExchangeSymKey(
      public_key,
      private_key,
    );
    const limit = 20;
    after ??= base64Encode(utf8.encode(DateTime.now().toIso8601String()));
    final response = await auth.client.get<Map<String, dynamic>>(
        '/api/messages/$conversation_id/messages?limit=$limit&after=$after');
    final data = response.data;
    if (data == null) return null;
    final resp = PaginatedResponse<MessageResponse>.fromJson(
        data, (json) => MessageResponse.fromJson(json));
    final list = <MessageResponse>[];
    for (var item in resp.data) {
      final message = await symDecrypt(derivedKey, item.message);
      list.add(MessageResponse(
        id: item.id,
        conversation_id: item.conversation_id,
        sender_id: item.sender_id,
        message: Utf8Decoder().convert(message),
        created_at: item.created_at,
      ));
    }
    final messages = PaginatedResponse<MessageResponse>(
      data: list,
      next: resp.next,
      limit: resp.limit,
      total: resp.total,
      after: resp.after,
    );
    return messages;
  }

  Future<String?> parseMessage(
    ConversationResource conversation,
    String message,
  ) async {
    final public_key = conversation.public_key;
    final own_private_key = conversation.own_private_key;
    if (public_key != null && own_private_key != null) {
      final derivedKey =
          await deriveExchangeSymKey(public_key, own_private_key);
      final decryptedMessage = await symDecrypt(derivedKey, message);
      return Utf8Decoder().convert(decryptedMessage);
    }
    return null;
  }

  void listenMessages(void Function(MessageResponse) messageEventListener) {
    if (auth.channel == null) {
      final hostArr = auth.host.split('://');
      final host = hostArr[1];
      final protocol = hostArr[0] == 'http' ? 'ws' : 'wss';
      final uri = Uri.parse('$protocol://$host/messages');
      final channel = WebSocketChannel.connect(uri);
      auth.channel = channel;
      final initialPayload = <String, dynamic>{
        'action': 'login',
        'token': auth.getToken()
      };
      channel.sink.add(jsonEncode(initialPayload));
      channel.stream.listen(
        (event) {
          final payload = jsonDecode(event);
          // if (payload['action'] == 'message') {
          messageEventListener(MessageResponse.fromJson(payload));
          // }
        },
        onError: (e, trace) {
          _logger.info('WebSocket Error', e, trace);
        },
        onDone: () {
          _logger.info('WebSocket Closed');
        },
      );
    }
  }
}

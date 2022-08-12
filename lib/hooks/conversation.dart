import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import 'common.dart';
import '../api/api.dart';
import '../api/types/ConversationResource.dart';
import '../api/types/MessageResponse.dart';
import '../providers/conversations.dart';

final _logger = Logger('hooks/conversation');

LoadingPaginatedDataCallback<ConversationResource> useFetchConversations(
    WidgetRef ref) {
  final loaded = useState<bool>(false);
  final loading = useState<bool>(false);
  final response = ref.read(conversationsProvider);
  final getResponse = useCallback(([bool forceRefresh = false]) async {
    loading.value = true;
    final after =
        response.after == null || forceRefresh ? null : response.after;
    final resp =
        await ApiController.instance.conversation.fetchConversations(after);
    _logger.finest(resp);
    loading.value = false;
    loaded.value = true;
    if (resp != null) {
      if (response.data.isEmpty || response.after == null) {
        ref.read(conversationsProvider.notifier).conversationsLoaded(resp);
      } else {
        final data = response.data;
        data.addAll(resp.data);
        ref.read(conversationsProvider.notifier).conversationsLoaded(
              resp.copyWith(
                data: data,
              ),
            );
      }
    }
  }, [response]);
  return LoadingPaginatedDataCallback<ConversationResource>(
    loaded: loaded.value,
    loading: loading.value,
    response: response,
    call: getResponse,
  );
}

LoadingCallback<void> useCreateConversation(
  String? user_id,
  String? user_key_id,
  WidgetRef ref,
) {
  final loading = useState<bool>(false);
  final getResponse = useCallback((void _) async {
    if (user_id == null || user_key_id == null) {
      return;
    }
    loading.value = true;
    final resp = await ApiController.instance.conversation
        .createConversation(user_id, user_key_id);
    loading.value = false;
    if (resp != null) {
      ref.read(conversationsProvider.notifier).conversationAdd(resp);
    }
  }, []);
  return LoadingCallback<void>(loading.value, getResponse);
}

LoadingPaginatedDataCallback<MessageResponse> useFetchMessages(
  String conversation_id,
  String? private_key,
  String? public_key,
  WidgetRef ref,
) {
  final loaded = useState<bool>(false);
  final loading = useState<bool>(false);
  final messages = ref.watch(conversationsProvider).messages[conversation_id];
  final after = messages?.after;
  final getResponse = useCallback(([bool forceRefresh = false]) async {
    if (private_key == null || public_key == null) {
      return;
    }
    loading.value = true;
    final resp = await ApiController.instance.conversation.fetchMessages(
      conversation_id,
      private_key,
      public_key,
      after,
    );
    loading.value = false;
    loaded.value = true;
    if (resp != null) {
      if (messages == null || messages.data.isEmpty || messages.after == null) {
        ref
            .read(conversationsProvider.notifier)
            .messagesLoaded(conversation_id, resp);
      } else {
        final data = messages.data;
        data.addAll(resp.data);
        ref.read(conversationsProvider.notifier).messagesLoaded(
              conversation_id,
              resp.copyWith(
                data: data,
              ),
            );
      }
    }
  }, [messages]);

  return LoadingPaginatedDataCallback<MessageResponse>(
    call: getResponse,
    loaded: loaded.value,
    loading: loading.value,
    response: messages,
  );
}

LoadingCallback<String> useSendMessage(
  String conversation_id,
  String? public_key,
  String? private_key,
  WidgetRef ref,
) {
  final loading = useState<bool>(false);
  final getResponse = useCallback((String text_content) async {
    if (private_key == null || public_key == null) {
      return;
    }
    loading.value = true;
    final resp = await ApiController.instance.conversation.sendMessage(
      conversation_id,
      private_key,
      public_key,
      text_content,
    );
    loading.value = false;
    if (resp != null) {
      ref
          .read(conversationsProvider.notifier)
          .messageAdd(conversation_id, resp);
    }
  }, []);
  return LoadingCallback<String>(loading.value, getResponse);
}

void Function(MessageResponse) useProcessIncomingMessage(WidgetRef ref) {
  final conversations = ref.read(conversationsProvider);
  final getResponse = useCallback((MessageResponse message) async {
    ConversationResource? _conversation;
    _logger.fine(message.toJson());
    if (conversations.data
            .any((element) => element.id == message.conversation_id) ==
        false) {
      _conversation = await ApiController.instance.conversation
          .fetchConversation(message.conversation_id);
      if (_conversation != null) {
        ref.read(conversationsProvider.notifier).conversationAdd(_conversation);
      }
    } else {
      _conversation = conversations.data
          .singleWhere((element) => element.id == message.conversation_id);
    }
    if (_conversation != null) {
      final decryptedMessage = await ApiController.instance.conversation
          .parseMessage(_conversation, message.message);
      if (decryptedMessage != null) {
        ref.read(conversationsProvider.notifier).messageAdd(
              message.conversation_id,
              MessageResponse(
                id: message.id,
                conversation_id: message.conversation_id,
                sender_id: message.sender_id,
                message: decryptedMessage,
                created_at: message.created_at,
              ),
            );
      }
    }
  }, []);
  return getResponse;
}

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../api/types/ConversationResource.dart';
import '../api/types/PaginatedResponse.dart';
import '../api/types/MessageResponse.dart';

final conversationsProvider =
    StateNotifierProvider<Conversations, ConversationsState>((ref) {
  return Conversations();
});

class Conversations extends StateNotifier<ConversationsState> {
  Conversations() : super(ConversationsState());

  void conversationsLoaded(PaginatedResponse<ConversationResource> resp) {
    state = state.copyWith(
      isLoaded: true,
      data: resp.data,
      next: resp.next,
      limit: resp.limit,
      total: resp.total,
      after: resp.after,
    );
  }

  void conversationAdd(ConversationResource conversation) {
    if (state.data.any((element) => element.id == conversation.id) == false) {
      state = state.copyWith(
        data: state.data..add(conversation),
      );
    }
  }

  void messagesLoaded(
      String conversation_id, PaginatedResponse<MessageResponse> messages) {
    final newMap = <String, MessagesState>{};
    newMap.addAll(state.messages);
    newMap.addAll(<String, MessagesState>{
      conversation_id: MessagesState(
        isLoaded: true,
        data: messages.data,
        next: messages.next,
        limit: messages.limit,
        total: messages.total,
        after: messages.after,
      )
    });
    state = state.copyWith(messages: newMap);
  }

  void messageAdd(String conversation_id, MessageResponse message) {
    if (state.messages.keys.contains(conversation_id)) {
      final messagesState = state.messages[conversation_id];
      if (messagesState != null) {
        final stateMessages = state.messages;
        stateMessages[conversation_id] = messagesState.copyWith(
          total: messagesState.total + 1,
          data: messagesState.data..insert(0, message),
        );
        state = state.copyWith(messages: stateMessages);
      }
    }
  }
}

class MessagesState extends PaginatedResponse<MessageResponse> {
  bool isLoaded;

  MessagesState({
    required this.isLoaded,
    List<MessageResponse> data = const <MessageResponse>[],
    bool next = false,
    int limit = 20,
    int total = 0,
    String? after,
  }) : super(
          data: data,
          next: next,
          limit: limit,
          total: total,
          after: after,
        );

  @override
  MessagesState copyWith({
    bool? isLoaded,
    List<MessageResponse>? data,
    bool? next,
    int? limit,
    int? total,
    String? after,
  }) =>
      MessagesState(
        isLoaded: isLoaded ?? this.isLoaded,
        data: data ?? this.data,
        next: next ?? this.next,
        limit: limit ?? this.limit,
        total: total ?? this.total,
        after: after ?? this.after,
      );
}

class ConversationsState extends PaginatedResponse<ConversationResource> {
  final bool isLoaded;
  final Map<String, MessagesState> messages;

  ConversationsState({
    this.isLoaded = false,
    this.messages = const <String, MessagesState>{},
    List<ConversationResource> data = const <ConversationResource>[],
    bool next = false,
    int limit = 20,
    int total = 0,
    String? after,
  }) : super(
          data: data,
          next: next,
          limit: limit,
          total: total,
          after: after,
        );

  @override
  ConversationsState copyWith({
    bool? isLoaded,
    Map<String, MessagesState>? messages,
    List<ConversationResource>? data,
    bool? next,
    int? limit,
    int? total,
    String? after,
  }) =>
      ConversationsState(
        isLoaded: isLoaded ?? this.isLoaded,
        messages: messages ?? this.messages,
        data: data ?? this.data,
        next: next ?? this.next,
        limit: limit ?? this.limit,
        total: total ?? this.total,
        after: after ?? this.after,
      );
}

import 'package:betro/providers/conversations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/fromNow.dart';
import '../api/types/ConversationResource.dart';
import '../api/types/MessageResponse.dart';
import '../components/drawer.dart';
import '../components/listfeed.dart';
import '../hooks/conversation.dart';
import '../providers/profile.dart';

bool loadOnScroll = true;

class MessagesScreenProps {
  String conversation_id;
  ConversationResource? initialData;

  MessagesScreenProps({required this.conversation_id, this.initialData});
}

class MessagesScreen extends HookConsumerWidget {
  MessagesScreen({Key? key, required this.props}) : super(key: key);

  final MessagesScreenProps props;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _conversation = props.initialData ??
        ref
            .watch(conversationsProvider)
            .data
            .firstWhere((element) => element.id == props.conversation_id);
    final fetchMessages = useFetchMessages(props.conversation_id,
        _conversation.own_private_key, _conversation.public_key, ref);
    useEffect(() {
      fetchMessages.call();
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(),
          title: Text('Messages ${_conversation.username}'),
          actions: [
            IconButton(
              onPressed: fetchMessages.loading
                  ? null
                  : () {
                      fetchMessages.call(true);
                    },
              icon: Icon(Icons.refresh),
            )
          ]),
      drawer: const AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: ListFeed<MessageResponse>(
              reverse: true,
              shrinkWrap: true,
              hook: fetchMessages,
              itemBuilder: (d) => MessageListTile(
                conversation: _conversation,
                message: d,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: MessageInput(
              conversation_id: _conversation.id,
              public_key: _conversation.public_key,
              private_key: _conversation.own_private_key,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageListTile extends HookConsumerWidget {
  const MessageListTile({
    required this.message,
    required this.conversation,
  });
  final MessageResponse message;
  final ConversationResource conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _expanded = useState<bool>(false);
    final profile = ref.watch(profileProvider);
    final is_own = profile.user_id == message.sender_id;
    final own_profile_picture = profile.profile_picture;
    final user_profile_picture = conversation.profile_picture;
    return ListTile(
      onTap: () => _expanded.value = !_expanded.value,
      leading: (!is_own && user_profile_picture != null)
          ? CircleAvatar(
              radius: 20,
              backgroundImage: MemoryImage(user_profile_picture),
            )
          : null,
      trailing: (is_own && own_profile_picture != null)
          ? CircleAvatar(
              radius: 20,
              backgroundImage: MemoryImage(own_profile_picture),
            )
          : null,
      title: Column(
        crossAxisAlignment:
            is_own ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(message.message),
          if (_expanded.value) Text(fromNow(message.created_at)),
        ],
      ),
    );
  }
}

class MessageInput extends HookConsumerWidget {
  const MessageInput({
    required this.conversation_id,
    required this.public_key,
    required this.private_key,
  });

  final String conversation_id;
  final String? public_key;
  final String? private_key;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _newMessageController =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final sendMessage =
        useSendMessage(conversation_id, public_key, private_key, ref);
    return TextField(
      controller: _newMessageController,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Type your message',
        suffixIcon: IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            sendMessage.call(_newMessageController.text);
            _newMessageController.text = '';
          },
        ),
      ),
      autofillHints: sendMessage.loading ? null : [AutofillHints.url],
      enabled: !sendMessage.loading,
      keyboardType: TextInputType.text,
    );
  }
}

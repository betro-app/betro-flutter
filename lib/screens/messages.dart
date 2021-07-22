import 'package:betro/providers/conversations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../api/types/ConversationResource.dart';
import '../api/types/MessageResponse.dart';
import '../components/drawer.dart';
import '../components/listfeed.dart';
import '../hooks/conversation.dart';

bool loadOnScroll = true;

class MessagesScreenProps {
  String conversation_id;
  ConversationResource? initialData;

  MessagesScreenProps({required this.conversation_id, this.initialData});
}

class MessagesScreen extends HookConsumerWidget {
  const MessagesScreen({Key? key, required this.props}) : super(key: key);

  final MessagesScreenProps props;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _conversation = props.initialData ??
        ref
            .watch(conversationsProvider)
            .data
            .firstWhere((element) => element.id == props.conversation_id);
    final messages =
        ref.watch(conversationsProvider).messages[props.conversation_id];
    final fetchMessages = useFetchMessages(props.conversation_id,
        _conversation.own_private_key, _conversation.public_key, ref);
    useEffect(() {
      fetchMessages.call();
    }, []);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Conversations'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchMessages.call(true);
        },
        child: ListFeed<MessageResponse>(
          hook: fetchMessages,
          itemBuilder: (d) => ListTile(
            title: Text(d.message),
          ),
        ),
      ),
    );
  }
}

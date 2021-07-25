import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../api/types/UserInfo.dart';
import '../components/userinfo.dart';
import '../api/types/ConversationResource.dart';
import '../components/drawer.dart';
import '../components/listfeed.dart';
import '../hooks/conversation.dart';
import './messages.dart';

bool loadOnScroll = true;

class ConversationsScreen extends HookConsumerWidget {
  const ConversationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchConversations = useFetchConversations(ref);
    useEffect(() {
      fetchConversations.call(true);
    }, []);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Conversations'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchConversations.call(true);
        },
        child: ListFeed<ConversationResource>(
          hook: fetchConversations,
          itemBuilder: (conversation) => UserListTile(
            user: UserInfo(
              id: conversation.user_id,
              is_approved: false,
              is_following: false,
              username: conversation.username,
              public_key: conversation.public_key,
              first_name: conversation.first_name,
              last_name: conversation.last_name,
              profile_picture: conversation.profile_picture,
            ),
            allowActions: false,
            allowNavigation: false,
            onTap: () {
              Navigator.of(context).pushNamed(
                '/messages',
                arguments: MessagesScreenProps(
                  conversation_id: conversation.id,
                  initialData: conversation,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

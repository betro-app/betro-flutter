import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/types/ApprovalResource.dart';
import '../components/drawer.dart';
import '../components/usersfeed.dart';
import '../hooks/follow.dart';
import '../api/types/UserInfo.dart';

bool loadOnScroll = true;

class ApprovalsScreen extends HookWidget {
  const ApprovalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchApprovals = useFetchPendingApprovals();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Approvals'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchApprovals.call(true);
        },
        child: UsersListFeed<ApprovalResource>(
          hook: fetchApprovals,
          mapUserInfo: (follower) => UserInfo(
            id: follower.id,
            is_approved: true,
            is_following: true,
            username: follower.username,
            first_name: follower.first_name,
            last_name: follower.last_name,
            profile_picture: follower.profile_picture,
          ),
        ),
      ),
    );
  }
}

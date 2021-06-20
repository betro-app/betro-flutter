import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/types/FolloweeResource.dart';
import '../components/drawer.dart';
import '../components/usersfeed.dart';
import '../hooks/follow.dart';
import '../api/types/UserInfo.dart';

bool loadOnScroll = true;

class FolloweesScreen extends HookWidget {
  const FolloweesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchFollowees = useFetchFollowees();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Followees'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchFollowees.call(true);
        },
        child: UsersListFeed<FolloweeResource>(
          hook: fetchFollowees,
          mapUserInfo: (follower) => UserInfo(
            id: follower.user_id,
            is_approved: follower.is_approved,
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

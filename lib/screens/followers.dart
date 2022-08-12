import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/types/FollowerResource.dart';
import '../components/drawer.dart';
import '../components/usersfeed.dart';
import '../hooks/follow.dart';
import '../api/types/UserInfo.dart';

bool loadOnScroll = true;

class FollowersScreen extends HookWidget {
  const FollowersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchFollowers = useFetchFollowers();
    useEffect(() {
      fetchFollowers.call();
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Followers'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchFollowers.call(true);
        },
        child: UsersListFeed<FollowerResource>(
          hook: fetchFollowers,
          mapUserInfo: (follower) => UserInfo(
            id: follower.user_id,
            is_approved: follower.is_following,
            is_following: follower.is_following_approved,
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

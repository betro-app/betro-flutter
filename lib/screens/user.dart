import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/user.dart';
import '../components/drawer.dart';
import '../hooks/feed.dart';
import '../components/feed.dart';
import '../components/userinfo.dart';
import '../api/types/UserInfo.dart';

class UserScreenProps {
  String username;
  UserInfo? initialData;

  UserScreenProps({required this.username, this.initialData});
}

class UserScreen extends HookWidget {
  UserScreen({Key? key, required this.props}) : super(key: key);

  final UserScreenProps props;
  final ScrollController _controller = ScrollController();

  Widget _buildUserInfo(UserInfo? user) {
    if (user == null) {
      return Container();
    }
    return UserListTile(
      allowNavigation: false,
      user: user,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fetchUser = useFetchUser(props.username, props.initialData);
    final fetchUserFeed = useFetchUserFeed(props.username);
    useEffect(() {
      fetchUser.call();
      fetchUserFeed.call();
      return null;
    }, []);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: BackButton(),
        title: Text(fetchUser.data?.username ?? props.username),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.wait([
            fetchUser.call(),
            fetchUserFeed.call(true),
          ]).then((value) => null);
        },
        child: ListView(
          controller: _controller,
          children: [
            _buildUserInfo(fetchUser.data),
            PostsFeed(
              allowUserNavigation: false,
              hook: fetchUserFeed,
              shrinkWrap: true,
              controller: _controller,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:betro/components/feed.dart';
import 'package:betro/hooks/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/user.dart';
import '../components/drawer.dart';
import '../api/types/UserInfo.dart';

class UserScreenProps {
  String username;
  UserInfo? initialData;

  UserScreenProps({required this.username, this.initialData});
}

class UserScreen extends HookWidget {
  UserScreen({Key? key, required this.props}) : super(key: key);

  final UserScreenProps props;

  String _accountName(UserInfo user) {
    var _name = '';
    final first_name = user.first_name;
    final last_name = user.last_name;
    if (first_name != null) {
      _name = first_name + (last_name == null ? '' : ' ' + last_name);
    }
    return _name;
  }

  Widget _buildUserInfo(UserInfo? user) {
    if (user == null) {
      return Container();
    }
    final profile_picture = user.profile_picture;
    return ListTile(
      leading: profile_picture == null
          ? null
          : Image.memory(
              profile_picture,
            ),
      title: Text(_accountName(user)),
      subtitle: Text(user.username),
      trailing: user.is_approved
          ? Text('Already following')
          : user.is_following
              ? Text('Follow request sent')
              : ElevatedButton(
                  onPressed: () {},
                  child: Text('Follow'),
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fetchUser = useFetchUser(props.username, props.initialData);
    final fetchUserFeed = useFetchUserFeed(props.username);
    useEffect(() {
      fetchUser.call(null);
      fetchUserFeed.call();
    }, []);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(fetchUser.data?.username ?? props.username),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.wait([
            fetchUser.call(null),
            fetchUserFeed.call(),
          ]).then((value) => null);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildUserInfo(fetchUser.data),
              PostsFeed(
                hook: fetchUserFeed,
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      ),
      // body: ,
    );
  }
}

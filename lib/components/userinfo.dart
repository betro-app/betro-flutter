import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/types/UserInfo.dart';
import '../screens/user.dart';

class UserListTile extends HookWidget {
  UserListTile({
    Key? key,
    required this.user,
    this.allowNavigation = false,
  }) : super(key: key);

  final UserInfo user;
  final bool allowNavigation;

  String get _accountName {
    var _name = '';
    final first_name = user.first_name;
    final last_name = user.last_name;
    if (first_name != null) {
      _name = first_name + (last_name == null ? '' : ' ' + last_name);
    }
    return _name;
  }

  @override
  Widget build(BuildContext context) {
    final profile_picture = user.profile_picture;
    return ListTile(
      leading: profile_picture == null
          ? null
          : Image.memory(
              profile_picture,
            ),
      title: Text(_accountName),
      subtitle: Text(user.username),
      trailing: user.is_approved
          ? Text('Already following')
          : user.is_following
              ? Text('Follow request sent')
              : ElevatedButton(
                  onPressed: () {},
                  child: Text('Follow'),
                ),
      onTap: allowNavigation == false
          ? null
          : () {
              Navigator.of(context).pushNamed(
                '/user',
                arguments: UserScreenProps(
                  username: user.username,
                  initialData: user,
                ),
              );
            },
    );
  }
}

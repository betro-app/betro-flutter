import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/common.dart';
import '../api/types/UserInfo.dart';
import './userinfo.dart';
import './listfeed.dart';

bool loadOnScroll = true;

class UsersListFeed<T> extends HookWidget {
  const UsersListFeed({Key? key, required this.hook, required this.mapUserInfo})
      : super(key: key);

  final LoadingPaginatedDataCallback<T> hook;
  final UserInfo Function(T) mapUserInfo;

  @override
  Widget build(BuildContext context) => ListFeed<T>(
        hook: hook,
        key: key,
        itemBuilder: (d) => UserListTile(user: mapUserInfo(d)),
      );
}

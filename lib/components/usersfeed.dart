import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/common.dart';
import '../api/types/UserInfo.dart';
import '../screens/user.dart';

bool loadOnScroll = true;

class UsersListFeed<T> extends HookWidget {
  const UsersListFeed({Key? key, required this.hook, required this.mapUserInfo})
      : super(key: key);

  final LoadingPaginatedDataCallback<T> hook;
  final UserInfo Function(T) mapUserInfo;

  Widget _buildLoading() => const Center(
        child: CircularProgressIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    final loaded = hook.loaded;
    final paginatedData = hook.response;
    final itemCount = (paginatedData == null || loaded == false)
        ? 1
        : (paginatedData.next
            ? paginatedData.data.length + 1
            : paginatedData.data.length);
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final loading = hook.loading;
        if (paginatedData == null ||
            loaded == false ||
            (index >= paginatedData.data.length && loading)) {
          return _buildLoading();
        }
        if (paginatedData.total == 0) {
          return const Center(
            child: Text('No posts'),
          );
        }
        if (index >= paginatedData.data.length && paginatedData.next) {
          if (loadOnScroll && !loading) {
            hook.call();
            return _buildLoading();
          } else {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: GestureDetector(
                onTap: () {
                  hook.call();
                },
                child: Text(
                  'Load More',
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ),
              ),
            );
          }
        }
        return _UserListTile<T>(
          user: mapUserInfo(
            paginatedData.data[index],
          ),
        );
      },
    );
  }
}

class _UserListTile<T> extends HookWidget {
  _UserListTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserInfo user;
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
      onTap: () {
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

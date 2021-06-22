import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/common.dart';
import '../api/types/UserInfo.dart';
import './userinfo.dart';

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
        return UserListTile(
          allowNavigation: true,
          user: mapUserInfo(
            paginatedData.data[index],
          ),
        );
      },
    );
  }
}

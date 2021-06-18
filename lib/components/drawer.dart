import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../api/api.dart';
import '../hooks/auth.dart';
import '../hooks/count.dart';
import '../hooks/profile.dart';
import '../providers/auth.dart';
import '../providers/count.dart';
import '../providers/profile.dart';

class AppDrawerBadgeListTile extends StatelessWidget {
  const AppDrawerBadgeListTile(
      {Key? key, this.child, this.trailing, this.onTap, this.showBadge = true})
      : super(key: key);

  final Widget? child;

  final Widget? trailing;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback? onTap;

  final bool showBadge;

  @override
  Widget build(BuildContext context) => ListTile(
        trailing: trailing,
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Badge(
              showBadge: showBadge,
              alignment: Alignment.topLeft,
              position: BadgePosition.topEnd(),
              shape: BadgeShape.circle,
              borderRadius: BorderRadius.circular(100),
              badgeColor: Theme.of(context).accentColor,
              badgeContent: Container(
                height: 5,
                width: 5,
              ),
              child: child,
            ),
          ],
        ),
      );
}

class AppDrawer extends HookWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await ApiController.instance.auth.logout();
    context.read(authProvider.notifier).loggedOut();
    await Navigator.pushReplacementNamed(context, '/login');
  }

  String _accountName(ProfileState profile) {
    var _name = '';
    final first_name = profile.first_name;
    final last_name = profile.last_name;
    final username = profile.username;
    if (first_name != null) {
      _name = first_name + (last_name == null ? '' : ' ' + last_name);
      _name += ' (@$username)';
    } else if (username != null) {
      _name = '@$username';
    }
    return _name;
  }

  @override
  Widget build(BuildContext context) {
    final profile = useProvider(profileProvider);
    final count = useProvider(countProvider);
    final resetLocal = useResetLocal(context);
    final fetchProfilePicture = useFetchProfilePicture(context);
    final fetchProfile = useFetchProfile(context);
    final fetchCount = useFetchCount(context);
    useEffect(() {
      if (!profile.isProfilePictureLoaded && !fetchProfilePicture.loading) {
        fetchProfilePicture.call();
      }
      if (!profile.isLoaded && !fetchProfile.loading) {
        fetchProfile.call();
      }
      if (!count.isLoaded && !fetchCount.loading) {
        fetchCount.call();
      }
    }, [
      profile.isLoaded,
      profile.isProfilePictureLoaded,
      count.isLoaded,
      fetchProfile.loading,
      fetchProfilePicture.loading,
      fetchCount.loading,
    ]);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_accountName(profile)),
              accountEmail: Text(profile.email ?? ''),
              currentAccountPicture: profile.profile_picture == null
                  ? null
                  : Image.memory(Uint8List.fromList(profile.profile_picture!)),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () =>
                  Navigator.of(context).popUntil(ModalRoute.withName('/home')),
            ),
            ListTile(
              title: Text('Notifications'),
              trailing:
                  count.isLoaded ? Text(count.notifications.toString()) : null,
            ),
            ListTile(
              title: Text('Approvals'),
              trailing:
                  count.isLoaded ? Text(count.approvals.toString()) : null,
            ),
            AppDrawerBadgeListTile(
              showBadge:
                  count.isLoaded && count.groups != null && count.groups == 0,
              trailing:
                  count.isLoaded ? Text(count.approvals.toString()) : null,
              child: const Text('Groups'),
            ),
            ListTile(
              title: Text('Followers'),
              trailing:
                  count.isLoaded ? Text(count.followers.toString()) : null,
            ),
            ListTile(
              title: Text('Followees'),
              trailing:
                  count.isLoaded ? Text(count.followees.toString()) : null,
            ),
            Divider(),
            ListTile(
              title: Text('Post'),
            ),
            ListTile(
              title: Text('My Posts'),
              trailing: count.isLoaded ? Text(count.posts.toString()) : null,
            ),
            Divider(),
            ListTile(
              title: Text('Search'),
            ),
            Divider(),
            AppDrawerBadgeListTile(
              showBadge: profile.isLoaded &&
                  (profile.first_name == null || profile.first_name!.isEmpty),
              onTap: () {
                Navigator.of(context).pushNamed('/profile');
              },
              child: Text('Profile'),
            ),
            AppDrawerBadgeListTile(
              showBadge: count.isLoaded &&
                  count.settings != null &&
                  count.settings == 0,
              child: const Text('Settings'),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                _logout(context);
                resetLocal.call();
              },
            )
          ],
        ),
      ),
    );
  }
}

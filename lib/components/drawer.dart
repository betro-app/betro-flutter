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
import '../providers/groups.dart';
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
              badgeColor: Theme.of(context).primaryColor,
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

class AppDrawer extends HookConsumerWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ApiController.instance.auth.logout();
    ref.read(authProvider.notifier).loggedOut();
    ref.read(countProvider.notifier).reset();
    ref.read(profileProvider.notifier).reset();
    ref.read(groupsProvider.notifier).reset();
    await Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (route) => false);
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
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final count = ref.watch(countProvider);
    final resetLocal = useResetLocal();
    final fetchProfilePicture = useFetchProfilePicture(ref);
    final fetchProfile = useFetchProfile(ref);
    final fetchCount = useFetchCount(ref);
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
                  : Image.memory(profile.profile_picture!),
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
              onTap: () => Navigator.of(context).pushNamed('/notifications'),
            ),
            ListTile(
              title: Text('Approvals'),
              trailing:
                  count.isLoaded ? Text(count.approvals.toString()) : null,
              onTap: () => Navigator.of(context).pushNamed('/approvals'),
            ),
            AppDrawerBadgeListTile(
              showBadge:
                  count.isLoaded && count.groups != null && count.groups == 0,
              trailing: count.isLoaded ? Text(count.groups.toString()) : null,
              onTap: () => Navigator.of(context).pushNamed('/groups'),
              child: const Text('Groups'),
            ),
            ListTile(
              title: Text('Messages'),
              onTap: () => Navigator.of(context).pushNamed('/conversations'),
            ),
            ListTile(
              title: Text('Followers'),
              trailing:
                  count.isLoaded ? Text(count.followers.toString()) : null,
              onTap: () => Navigator.of(context).pushNamed('/followers'),
            ),
            ListTile(
              title: Text('Followees'),
              trailing:
                  count.isLoaded ? Text(count.followees.toString()) : null,
              onTap: () => Navigator.of(context).pushNamed('/followees'),
            ),
            Divider(),
            ListTile(
              title: Text('Post'),
              onTap: () => Navigator.of(context).pushNamed('/post'),
            ),
            ListTile(
              title: Text('My Posts'),
              trailing: count.isLoaded ? Text(count.posts.toString()) : null,
              onTap: () => Navigator.of(context).pushNamed('/posts'),
            ),
            Divider(),
            ListTile(
              title: Text('Search'),
              onTap: () => Navigator.of(context).pushNamed('/search'),
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
              onTap: () => Navigator.of(context).pushNamed('/settings'),
              child: const Text('Settings'),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                _logout(context, ref);
                resetLocal.call();
              },
            )
          ],
        ),
      ),
    );
  }
}

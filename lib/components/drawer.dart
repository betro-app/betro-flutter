import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../api/api.dart';
import '../hooks/auth.dart';
import '../hooks/profile.dart';
import '../providers/auth.dart';
import '../providers/profile.dart';

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
    final resetLocal = useResetLocal(context);
    final fetchProfilePicture = useFetchProfilePicture(context);
    final fetchProfile = useFetchProfile(context);
    useEffect(() {
      if (!profile.isProfilePictureLoaded) {
        fetchProfilePicture.call();
      }
      if (!profile.isLoaded) {
        fetchProfile.call();
      }
    }, [profile.isLoaded, profile.isProfilePictureLoaded]);
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

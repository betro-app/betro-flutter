import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../hooks/profile.dart';
import '../providers/profile.dart';

class AppDrawer extends HookWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = useProvider(profileProvider);
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
              accountName: Text(profile.username ?? ''),
              accountEmail: Text(profile.email ?? ''),
              currentAccountPicture: profile.profile_picture == null
                  ? null
                  : Image.memory(Uint8List.fromList(profile.profile_picture!)),
            ),
          ],
        ),
      ),
    );
  }
}

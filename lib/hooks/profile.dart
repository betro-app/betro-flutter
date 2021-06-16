import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../providers/profile.dart';
import 'common.dart';

LoadingVoidCallback useFetchProfilePicture(BuildContext context) {
  var loading = useState<bool>(false);
  final fetchProfilePicture = useCallback(() {
    loading.value = true;
    ApiController.instance.account.fetchProfilePicture().then((value) {
      context.read(profileProvider.notifier).profilePictureLoaded(value);
      loading.value = false;
    }).catchError((e) {
      loading.value = false;
    });
  }, []);
  return LoadingVoidCallback(loading.value, fetchProfilePicture);
}

LoadingVoidCallback useFetchProfile(BuildContext context) {
  var loading = useState<bool>(false);
  final fetchProfile = useCallback(() {
    loading.value = true;
    ApiController.instance.account.fetchWhoAmi().then((value) {
      if (value != null) {
        context.read(profileProvider.notifier).profileLoaded(
              user_id: value.user_id,
              username: value.username,
              email: value.email,
              first_name: value.first_name,
              last_name: value.last_name,
            );
      }
      loading.value = false;
    }).catchError((e) {
      loading.value = false;
    });
  }, []);
  return LoadingVoidCallback(loading.value, fetchProfile);
}

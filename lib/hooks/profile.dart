import 'package:logging/logging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../api/types/UserProfileResponse.dart';
import '../providers/profile.dart';
import 'common.dart';

final _logger = Logger('hooks/profile');

LoadingVoidCallback useFetchProfilePicture(WidgetRef ref) {
  var loading = useState<bool>(false);
  final fetchProfilePicture = useCallback(() {
    loading.value = true;
    ApiController.instance.account.fetchProfilePicture().then((value) {
      ref.read(profileProvider.notifier).profilePictureLoaded(value);
      loading.value = false;
    }).catchError((e, s) {
      _logger.warning(e.toString(), e, s);
      loading.value = false;
    });
  }, []);
  return LoadingVoidCallback(loading.value, fetchProfilePicture);
}

LoadingVoidCallback useFetchProfile(WidgetRef ref) {
  var loading = useState<bool>(false);
  final fetchProfile = useCallback(() {
    loading.value = true;
    ApiController.instance.account.fetchWhoAmi().then((value) {
      if (value != null) {
        ref.read(profileProvider.notifier).profileLoaded(
              user_id: value.user_id,
              username: value.username,
              email: value.email,
              first_name: value.first_name,
              last_name: value.last_name,
            );
      }
      loading.value = false;
    }).catchError((e, s) {
      _logger.warning(e.toString(), e, s);
      loading.value = false;
    });
  }, []);
  return LoadingVoidCallback(loading.value, fetchProfile);
}

class UpdateProfile {
  String? first_name;
  String? last_name;
  List<int>? profile_picture;
  UpdateProfile({this.first_name, this.last_name, this.profile_picture});
}

LoadingCallback<UpdateProfile> useUpdateProfile(WidgetRef ref) {
  var loading = useState<bool>(false);
  final updateProfile = useCallback((UpdateProfile profile) async {
    loading.value = true;
    final oldProfile = ref.read(profileProvider);
    UserProfile? value;
    if (oldProfile.first_name == null || oldProfile.first_name!.isEmpty) {
      value = await ApiController.instance.account.createProfile(
        first_name: profile.first_name,
        last_name: profile.last_name,
        profile_picture: profile.profile_picture,
      );
    } else {
      value = await ApiController.instance.account.updateProfile(
        first_name: profile.first_name,
        last_name: profile.last_name,
        profile_picture: profile.profile_picture,
      );
    }
    if (value != null) {
      ref.read(profileProvider.notifier).profileLoaded(
            first_name: value.first_name,
            last_name: value.last_name,
          );
      ref
          .read(profileProvider.notifier)
          .profilePictureLoaded(value.profile_picture);
    }
    loading.value = false;
  }, []);
  return LoadingCallback<UpdateProfile>(loading.value, updateProfile);
}

import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../api/types/UserInfo.dart';
import 'common.dart';

LoadingDataCallback<UserInfo?, void> useFetchUser(String username,
    [UserInfo? initialData]) {
  final loading = useState<bool>(false);
  final data = useState<UserInfo?>(initialData);
  final fetchProfile = useCallback((void _) async {
    loading.value = true;
    final userInfo = await ApiController.instance.user.fetchUserInfo(username);
    data.value = userInfo;
    loading.value = false;
  }, []);
  return LoadingDataCallback<UserInfo?, void>(
    loading.value,
    data.value,
    fetchProfile,
  );
}

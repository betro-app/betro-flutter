import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/groups.dart';
import '../api/api.dart';
import 'common.dart';

LoadingListDataCallback<T> Function() fetchListHookCreator<T>(
  Future<List<T>?> Function() fetch,
) {
  LoadingListDataCallback<T> useFetchList() {
    final loaded = useState<bool>(false);
    final loading = useState<bool>(false);
    final response = useState<List<T>?>(null);
    final getResponse = useCallback(() async {
      loading.value = true;
      final resp = await fetch();
      loaded.value = true;
      loading.value = false;
      if (resp != null) {
        response.value = resp;
      }
    }, []);
    return LoadingListDataCallback<T>(
      loaded: loaded.value,
      loading: loading.value,
      response: response.value,
      call: getResponse,
    );
  }

  return useFetchList;
}

LoadingVoidCallback useFetchGroups(WidgetRef ref) {
  final loading = useState<bool>(false);
  final getResponse = useCallback(() async {
    loading.value = true;
    final resp = await ApiController.instance.group.fetchGroups();
    ref.read(groupsProvider.notifier).groupsLoaded(resp);
    loading.value = false;
  }, []);
  return LoadingVoidCallback(
    loading.value,
    getResponse,
  );
}

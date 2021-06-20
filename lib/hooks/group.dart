import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../api/types/GroupResponse.dart';
import 'common.dart';

LoadingListDataCallback<T> Function() _fetchListHookCreator<T>(
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

final useFetchGroups = _fetchListHookCreator<GroupResponse>(
  () => ApiController.instance.group.fetchGroups(),
);

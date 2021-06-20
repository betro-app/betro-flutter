import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../api/types/PaginatedResponse.dart';
import '../api/types/ApprovalResource.dart';
import '../api/types/FolloweeResource.dart';
import '../api/types/FollowerResource.dart';
import 'common.dart';

LoadingPaginatedDataCallback<T> Function() _fetchUsersHookCreator<T>(
  Future<PaginatedResponse<T>?> Function([String? after]) fetch,
) {
  LoadingPaginatedDataCallback<T> useFetchUsers() {
    final loaded = useState<bool>(false);
    final loading = useState<bool>(false);
    final response = useState<PaginatedResponse<T>?>(null);
    final getResponse = useCallback(([bool forceRefresh = false]) async {
      final after =
          response.value == null || forceRefresh ? null : response.value?.after;
      loading.value = true;
      final resp = await fetch(after);
      loaded.value = true;
      loading.value = false;
      if (resp != null) {
        final value = response.value;
        if (value == null || forceRefresh) {
          response.value = resp;
        } else {
          response.value = value.copyWith(
            data: value.data..addAll(resp.data),
            next: value.next,
            limit: value.limit,
            total: value.total,
            after: value.after,
          );
        }
      }
    }, []);
    return LoadingPaginatedDataCallback<T>(
      loaded: loaded.value,
      loading: loading.value,
      response: response.value,
      call: getResponse,
    );
  }

  return useFetchUsers;
}

final useFetchPendingApprovals = _fetchUsersHookCreator<ApprovalResource>(
  ([after]) => ApiController.instance.follow.fetchPendingApprovals(after),
);

final useFetchFollowers = _fetchUsersHookCreator<FollowerResource>(
  ([after]) => ApiController.instance.follow.fetchFollowers(after),
);

final useFetchFollowees = _fetchUsersHookCreator<FolloweeResource>(
  ([after]) => ApiController.instance.follow.fetchFollowees(after),
);

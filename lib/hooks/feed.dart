import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../api/types/FeedResource.dart';
import '../api/types/PageInfo.dart';
import 'common.dart';

HomeFeedCallback Function(T data) _feedHookCreator<T>(
  Future<FeedResource?> Function(
    T data, [
    String? after,
  ])
      fetch,
) {
  HomeFeedCallback useFetchFeed(T data) {
    final loaded = useState<bool>(false);
    final loading = useState<bool>(false);
    final posts = useState<List<PostResource>?>(null);
    final pageInfo = useState<PageInfo?>(null);
    final getResponse = useCallback(([bool forceRefresh = false]) async {
      final after =
          pageInfo.value == null || forceRefresh ? null : pageInfo.value?.after;
      loading.value = true;
      final resp = await fetch(data, after);
      loaded.value = true;
      loading.value = false;
      if (resp != null) {
        pageInfo.value = resp.pageInfo;
        if (posts.value == null || forceRefresh) {
          posts.value = resp.data;
        } else {
          posts.value?.addAll(resp.data);
        }
      }
    }, []);
    return HomeFeedCallback(
      loaded: loaded.value,
      loading: loading.value,
      posts: posts.value,
      pageInfo: pageInfo.value,
      call: getResponse,
    );
  }

  return useFetchFeed;
}

final useFetchHomeFeed = _feedHookCreator<void>(
  (void _, [after]) => ApiController.instance.feed.fetchHomeFeed(after),
);

final useFetchUserFeed = _feedHookCreator<String>(
  (String username, [after]) =>
      ApiController.instance.feed.fetchUserPosts(username, after),
);

final useFetchOwnFeed = _feedHookCreator<void>(
  (void _, [after]) => ApiController.instance.feed.fetchOwnPosts(after),
);

import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../api/types/FeedResource.dart';
import '../api/types/PageInfo.dart';
import 'common.dart';

HomeFeedCallback useFetchHomeFeed() {
  final loaded = useState<bool>(false);
  final loading = useState<bool>(false);
  final posts = useState<List<PostResource>?>(null);
  final pageInfo = useState<PageInfo?>(null);
  final getResponse = useCallback(([bool forceRefresh = false]) async {
    final after =
        pageInfo.value == null || forceRefresh ? null : pageInfo.value?.after;
    loading.value = true;
    final resp = await ApiController.instance.feed.fetchHomeFeed(after);
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
    callback: getResponse,
  );
}

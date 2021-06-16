import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../api/types/UserProfileResponse.dart';
import '../providers/profile.dart';
import '../api/types/FeedResource.dart';
import '../api/types/PageInfo.dart';
import 'common.dart';

class HomeFeedCallback {
  final bool loaded;
  final bool loading;
  final List<PostResource>? posts;
  final PageInfo? pageInfo;
  final Future<void> Function([bool]) callback;

  HomeFeedCallback({
    required this.loading,
    required this.loaded,
    required this.posts,
    required this.pageInfo,
    required this.callback,
  });
}

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

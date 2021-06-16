import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../providers/count.dart';
import 'common.dart';

LoadingVoidCallback useFetchCount(BuildContext context) {
  var loading = useState<bool>(false);
  final fetchCount = useCallback(() {
    loading.value = true;
    ApiController.instance.account.fetchCounts().then((value) {
      if (value != null) {
        context.read(countProvider.notifier).loaded(
              notifications: value.notifications,
              settings: value.settings,
              groups: value.groups,
              followers: value.followers,
              followees: value.followees,
              approvals: value.approvals,
              posts: value.posts,
            );
      }
      loading.value = false;
    }).catchError((e) {
      loading.value = false;
    });
  }, []);
  return LoadingVoidCallback(loading.value, fetchCount);
}

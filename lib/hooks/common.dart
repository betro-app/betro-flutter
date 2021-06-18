import '../api/types/FeedResource.dart';
import '../api/types/PageInfo.dart';

class LoadingVoidCallback {
  final bool loading;
  final void Function() call;

  LoadingVoidCallback(this.loading, this.call);
}

class LoadingCallback<T> {
  final bool loading;
  final Future<Null> Function(T) call;

  LoadingCallback(this.loading, this.call);
}

class LoadingDataCallback<T, V> {
  final bool loading;
  final T data;
  final Future<Null> Function(V) call;

  LoadingDataCallback(this.loading, this.data, this.call);
}

class HomeFeedCallback {
  final bool loaded;
  final bool loading;
  final List<PostResource>? posts;
  final PageInfo? pageInfo;
  final Future<void> Function([bool]) call;

  HomeFeedCallback({
    required this.loading,
    required this.loaded,
    required this.posts,
    required this.pageInfo,
    required this.call,
  });
}

class UserFeedCallback {
  final bool loaded;
  final bool loading;
  final List<PostResource>? posts;
  final PageInfo? pageInfo;
  final Future<void> Function(String, [bool]) call;

  UserFeedCallback({
    required this.loading,
    required this.loaded,
    required this.posts,
    required this.pageInfo,
    required this.call,
  });
}

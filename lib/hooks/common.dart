import '../api/types/PostResource.dart';
import '../api/types/PaginatedResponse.dart';
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
  final Future<Null> Function([V]) call;

  LoadingDataCallback(this.loading, this.data, this.call);
}

class LoadingListDataCallback<T> {
  final bool loaded;
  final bool loading;
  final List<T>? response;
  final Future<Null> Function() call;

  LoadingListDataCallback({
    required this.loading,
    required this.loaded,
    required this.response,
    required this.call,
  });
}

class LoadingPaginatedDataCallback<T> {
  final bool loaded;
  final bool loading;
  final PaginatedResponse<T>? response;
  final Future<Null> Function([bool]) call;

  LoadingPaginatedDataCallback({
    required this.loading,
    required this.loaded,
    required this.response,
    required this.call,
  });
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

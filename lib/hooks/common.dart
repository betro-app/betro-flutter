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

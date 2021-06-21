import 'package:hooks_riverpod/hooks_riverpod.dart';

final countProvider = StateNotifierProvider<Count, CountState>((ref) {
  return Count();
});

class Count extends StateNotifier<CountState> {
  Count() : super(CountState());

  void loaded({
    int? notifications,
    int? settings,
    int? groups,
    int? followers,
    int? followees,
    int? approvals,
    int? posts,
  }) {
    state = state.copyWith(
      isLoaded: true,
      notifications: notifications,
      settings: settings,
      groups: groups,
      followers: followers,
      followees: followees,
      approvals: approvals,
      posts: posts,
    );
  }

  void addValue(String type, int value) {
    switch (type) {
      case 'notifications':
        state =
            state.copyWith(notifications: (state.notifications ?? 0) + value);
        break;
      case 'settings':
        state = state.copyWith(settings: (state.settings ?? 0) + value);
        break;
      case 'groups':
        state = state.copyWith(groups: (state.groups ?? 0) + value);
        break;
      case 'followers':
        state = state.copyWith(followers: (state.followers ?? 0) + value);
        break;
      case 'followees':
        state = state.copyWith(followees: (state.followees ?? 0) + value);
        break;
      case 'approvals':
        state = state.copyWith(approvals: (state.approvals ?? 0) + value);
        break;
      case 'posts':
        state = state.copyWith(posts: (state.posts ?? 0) + value);
        break;
    }
  }

  void reset() {
    state = CountState();
  }
}

class CountState {
  final bool isLoaded;
  final int? notifications;
  final int? settings;
  final int? groups;
  final int? followers;
  final int? followees;
  final int? approvals;
  final int? posts;

  CountState({
    this.isLoaded = false,
    this.notifications,
    this.settings,
    this.groups,
    this.followers,
    this.followees,
    this.approvals,
    this.posts,
  });

  CountState copyWith({
    bool? isLoaded,
    int? notifications,
    int? settings,
    int? groups,
    int? followers,
    int? followees,
    int? approvals,
    int? posts,
  }) =>
      CountState(
        isLoaded: isLoaded ?? this.isLoaded,
        notifications: notifications ?? this.notifications,
        settings: settings ?? this.settings,
        groups: groups ?? this.groups,
        followers: followers ?? this.followers,
        followees: followees ?? this.followees,
        approvals: approvals ?? this.approvals,
        posts: posts ?? this.posts,
      );
}

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../api/types/GroupResponse.dart';

final groupsProvider = StateNotifierProvider<Group, GroupState>((ref) {
  return Group();
});

class Group extends StateNotifier<GroupState> {
  Group() : super(GroupState());

  void groupsLoaded(List<GroupResponse> groups) {
    state = state.copyWith(
      isLoaded: true,
      groups: groups,
    );
  }

  void addGroup(GroupResponse group) {
    state = state.copyWith(
      groups: state.groups?..add(group),
    );
  }

  void removeGroup(String groupId) {
    state = state.copyWith(
      groups: state.groups?.where((element) => element.id != groupId).toList(),
    );
  }

  void reset() {
    state = GroupState();
  }
}

class GroupState {
  final bool isLoaded;
  final List<GroupResponse>? groups;

  GroupState({
    this.isLoaded = false,
    this.groups = const <GroupResponse>[],
  });

  GroupState copyWith({
    bool? isLoaded,
    List<GroupResponse>? groups,
  }) =>
      GroupState(
        isLoaded: isLoaded ?? this.isLoaded,
        groups: groups ?? this.groups,
      );
}

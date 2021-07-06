import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../api/api.dart';
import '../api/types/GroupResponse.dart';
import '../components/drawer.dart';
import '../hooks/group.dart';
import '../providers/groups.dart';

class GroupScreen extends HookConsumerWidget {
  const GroupScreen({Key? key}) : super(key: key);

  Widget _buildLoading() => const Center(
        child: CircularProgressIndicator(),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsData = ref.watch(groupsProvider);
    final fetchGroups = useFetchGroups(ref);
    useEffect(() {
      fetchGroups.call();
    }, []);
    final loaded = groupsData.isLoaded;
    final groups = groupsData.groups;
    final itemCount = (groups == null || loaded == false) ? 1 : groups.length;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Groups'),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/newgroup');
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchGroups.call();
        },
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final loading = fetchGroups.loading;
            if (groups == null ||
                loaded == false ||
                (index >= groups.length && loading)) {
              return _buildLoading();
            }
            if (groups.isEmpty) {
              return const Center(
                child: Text('No groups'),
              );
            }
            return _GroupListTile(group: groups[index]);
          },
        ),
      ),
    );
  }
}

class _GroupListTile extends HookConsumerWidget {
  _GroupListTile({
    Key? key,
    required this.group,
  }) : super(key: key);

  final GroupResponse group;

  void _delete(WidgetRef ref) async {
    await ApiController.instance.group.deleteGroup(group.id);
    ref.read(groupsProvider.notifier).removeGroup(group.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState<bool>(false);
    return ListTile(
      title: Text(group.name),
      subtitle: group.is_default ? Text('Default') : null,
      enabled: !loading.value,
      trailing: IconButton(
        onPressed: () async {
          loading.value = true;
          _delete(ref);
          loading.value = false;
        },
        icon: Icon(Icons.delete),
      ),
    );
  }
}

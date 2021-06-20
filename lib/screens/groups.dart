import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../api/types/GroupResponse.dart';
import '../components/drawer.dart';
import '../hooks/group.dart';

class GroupScreen extends HookWidget {
  const GroupScreen({Key? key}) : super(key: key);

  Widget _buildLoading() => const Center(
        child: CircularProgressIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    final fetchGroups = useFetchGroups();
    useEffect(() {
      ApiController.instance.keys.fetchKeys();
      fetchGroups.call();
    }, []);
    final loaded = fetchGroups.loaded;
    final groups = fetchGroups.response;
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
          await fetchGroups.call();
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchGroups.call();
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
            return _GroupListTile(
              group: groups[index],
              onDeleted: () => fetchGroups.call(),
            );
          },
        ),
      ),
    );
  }
}

class _GroupListTile extends HookWidget {
  _GroupListTile({
    Key? key,
    required this.group,
    required this.onDeleted,
  }) : super(key: key);

  final GroupResponse group;
  final Future<void> Function() onDeleted;

  @override
  Widget build(BuildContext context) {
    final loading = useState<bool>(false);
    return ListTile(
      title: Text(group.name),
      subtitle: group.is_default ? Text('Default') : null,
      enabled: !loading.value,
      trailing: IconButton(
        onPressed: () async {
          loading.value = true;
          await ApiController.instance.group.deleteGroup(group.id);
          await onDeleted();
          loading.value = false;
        },
        icon: Icon(Icons.delete),
      ),
    );
  }
}

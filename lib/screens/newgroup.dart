import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../providers/groups.dart';
import '../api/api.dart';

class NewGroupScreen extends HookConsumerWidget {
  const NewGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _nameController = useTextEditingController(text: '');
    final _default = useState<bool>(false);
    final _loading = useState<bool>(false);
    return Scaffold(
      appBar: AppBar(
        title: Text('New Group'),
        actions: [
          IconButton(
            onPressed: _loading.value
                ? null
                : () async {
                    _loading.value = true;
                    final group =
                        await ApiController.instance.group.createGroup(
                      _nameController.text,
                      _default.value,
                    );
                    _loading.value = false;
                    if (group != null) {
                      ref.read(groupsProvider.notifier).addGroup(group);
                    }
                    Navigator.of(context).pop();
                  },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            SwitchListTile(
              value: _default.value,
              title: Text('Default'),
              onChanged: (value) {
                _default.value = value;
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../components/textfielddialog.dart';

class NewGroupScreen extends HookWidget {
  const NewGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _name = useState<String>('');
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
                    await ApiController.instance.group.createGroup(
                      _name.value,
                      _default.value,
                    );
                    _loading.value = false;
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
            TextFieldListTile(
              value: _name.value,
              labelText: 'Name',
              onChange: (value) {
                _name.value = value;
              },
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

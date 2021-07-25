import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../api/types/GroupResponse.dart';
import '../api/api.dart';
import '../providers/groups.dart';
import '../hooks/group.dart';
import '../components/ImagePicker.dart';

class NewPostScreen extends HookConsumerWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchGroups = useFetchGroups(ref);
    final groupsData = ref.watch(groupsProvider);
    final _textController = useTextEditingController.fromValue(
      TextEditingValue.empty,
    );
    final _media = useState<Uint8List?>(null);
    final _loading = useState<bool>(false);
    final _selectedGroup = useState<GroupResponse?>(null);
    useEffect(() {
      if (!groupsData.isLoaded) {
        fetchGroups.call();
      } else {
        final groups = groupsData.groups;
        if (groups != null && groups.isNotEmpty) {
          _selectedGroup.value = groups.first;
        }
      }
    }, [groupsData.isLoaded]);
    final disabled = !groupsData.isLoaded || _loading.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: [
          IconButton(
            onPressed: disabled
                ? null
                : () async {
                    final group = _selectedGroup.value;
                    if (group == null) return;
                    _loading.value = true;
                    await ApiController.instance.post.createPost(
                      group.id,
                      group.sym_key,
                      text: _textController.text,
                      media: _media.value,
                    );
                    _loading.value = false;
                    await Navigator.of(context).pushReplacementNamed('/posts');
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
                maxLines: 8,
                enabled: !disabled,
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Text',
                ),
                keyboardType: TextInputType.multiline,
              ),
            ),
            ListTile(
              title: Text(_selectedGroup.value?.name ?? 'No Group selected'),
              onTap: () {
                SelectDialog.showModal<GroupResponse>(
                  context,
                  label: 'Select group',
                  selectedValue: _selectedGroup.value,
                  items: groupsData.groups,
                  onChange: (GroupResponse selected) {
                    _selectedGroup.value = selected;
                  },
                );
              },
            ),
            GestureDetector(
              onTap: disabled == true
                  ? null
                  : () {
                      final picker = ImagePickerUploader(
                        allowPreview: true,
                        value: _media.value == null
                            ? null
                            : Image.memory(_media.value!),
                        context: context,
                        text: 'Profile Picture',
                        onChange: (file) {
                          if (file != null) {
                            final bytes = file.readAsBytesSync();
                            _media.value = Uint8List.fromList(bytes.toList());
                          } else {
                            _media.value = null;
                          }
                        },
                      );
                      picker.editPicture();
                    },
              child: _media.value == null
                  ? Text('No Picture found')
                  : Image.memory(_media.value!),
            )
          ],
        ),
      ),
    );
  }
}

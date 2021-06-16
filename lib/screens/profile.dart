import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../components/drawer.dart';
import '../components/ImagePicker.dart';
import '../components/textfielddialog.dart';
import '../providers/profile.dart';
import '../hooks/profile.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = useProvider(profileProvider);
    final _firstName = useState<String>(profile.first_name ?? '');
    final _lastName = useState<String>(profile.last_name ?? '');
    final _profilePicture = useState<List<int>?>(profile.profile_picture);
    final _updateProfile = useUpdateProfile(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: _updateProfile.loading
                ? null
                : () async {
                    await _updateProfile.call(
                      UpdateProfile(
                        first_name: _firstName.value,
                        last_name: _lastName.value,
                        profile_picture: _profilePicture.value,
                      ),
                    );
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
              value: _firstName.value,
              labelText: 'First Name',
              onChange: (value) {
                _firstName.value = value;
              },
            ),
            TextFieldListTile(
              value: _lastName.value,
              labelText: 'Last Name',
              onChange: (value) {
                _lastName.value = value;
              },
            ),
            GestureDetector(
              onTap: () {
                final picker = ImagePickerUploader(
                  allowPreview: true,
                  value: _profilePicture.value == null
                      ? null
                      : Image.memory(
                          Uint8List.fromList(_profilePicture.value!)),
                  context: context,
                  text: 'Profile Picture',
                  onChange: (file) {
                    if (file != null) {
                      final bytes = file.readAsBytesSync();
                      _profilePicture.value = bytes.toList();
                    } else {
                      _profilePicture.value = null;
                    }
                  },
                );
                picker.editPicture();
              },
              child: _profilePicture.value == null
                  ? Text('No Profile Picture found')
                  : Image.memory(Uint8List.fromList(_profilePicture.value!)),
            )
          ],
        ),
      ),
    );
  }
}

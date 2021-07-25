import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

class ImagePickerUploader {
  ImagePickerUploader({
    required this.context,
    this.value,
    required this.onChange,
    required this.text,
    this.allowPreview = false,
  });

  final BuildContext context;
  final Image? value; // Url of the image
  final void Function(File? image) onChange;
  final String text;
  final bool allowPreview;

  void editPicture() {
    showDialog<void>(
      context: context,
      builder: (context) => _ImagePickerUploaderWidget(
        context: context,
        value: value,
        onChange: onChange,
        text: text,
        allowPreview: allowPreview,
      ),
    );
  }
}

class _ImagePickerUploaderWidget extends StatefulWidget {
  const _ImagePickerUploaderWidget({
    required this.context,
    this.value,
    required this.onChange,
    required this.text,
    this.allowPreview = false,
  });

  final BuildContext context;
  final Image? value; // Url of the image
  final void Function(File? image) onChange;
  final String text;
  final bool allowPreview;

  @override
  _ImagePickerUploaderWidgetState createState() =>
      _ImagePickerUploaderWidgetState();
}

class _ImagePickerUploaderWidgetState
    extends State<_ImagePickerUploaderWidget> {
  File? _image;
  final _picker = ImagePicker();

  void _onChange(File? image) {
    widget.onChange(image);
    Navigator.of(widget.context).pop();
  }

  bool get _imagePickerAvailable => Platform.isAndroid || Platform.isIOS;

  Future _takeProfilePicture() async {
    if (_imagePickerAvailable) {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
      _onChange(_image);
    } else {}
  }

  Future _selectProfilePicture() async {
    if (_imagePickerAvailable) {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    } else {
      final completer = Completer<void>();
      final fileChooserResult = await FilePickerCross.importFromStorage(
        type: FileTypeCross.image,
      );
      final filepath = fileChooserResult.path;
      if (filepath != null && filepath.isNotEmpty) {
        setState(() {
          _image = File(filepath);
        });
        completer.complete();
      }
      await completer.future;
      _onChange(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    final widgets = <Widget>[
      if (widget.allowPreview)
        if (value == null)
          const Icon(
            Icons.person,
            size: 200,
          )
        else
          value,
    ];
    if (_imagePickerAvailable) {
      widgets.add(
        ListTile(
          title: const Text('Take a picture'),
          onTap: _takeProfilePicture,
        ),
      );
    }
    widgets.add(
      ListTile(
        title: const Text('Select a picture'),
        onTap: _selectProfilePicture,
      ),
    );
    if (widget.allowPreview) {
      widgets.add(
        ListTile(
          title: const Text('Remove picture'),
          onTap: () => _onChange(null),
        ),
      );
    }
    widgets.add(ListTile(
      title: const Text('Cancel'),
      onTap: () => Navigator.of(context).pop(),
    ));
    return SimpleDialog(
      title: Text(widget.text),
      children: widgets,
    );
  }
}

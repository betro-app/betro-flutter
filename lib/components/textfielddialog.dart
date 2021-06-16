import 'package:flutter/material.dart';

class TextFieldDialog extends StatelessWidget {
  TextFieldDialog({Key? key, this.onSave, this.labelText, this.initialValue})
      : _textController = TextEditingController(text: initialValue),
        super(key: key);
  final TextEditingController _textController;

  final Null Function(String)? onSave;

  final String? labelText;
  final String? initialValue;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: TextField(
          controller: _textController,
          decoration: InputDecoration(
            labelText: labelText,
          ),
          keyboardType: TextInputType.text,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (onSave != null) {
                onSave!(_textController.text);
              }
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
}

class TextFieldListTile extends StatelessWidget {
  const TextFieldListTile(
      {Key? key, this.value, this.onChange, this.labelText = ''})
      : super(key: key);
  final String? value;

  final Null Function(String)? onChange;

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(labelText),
      subtitle: Text(value ?? ''),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => TextFieldDialog(
            onSave: onChange,
            labelText: labelText,
            initialValue: value,
          ),
        );
      },
    );
  }
}

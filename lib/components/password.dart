import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordFormField extends HookWidget {
  const PasswordFormField(
      {Key? key,
      this.controller,
      this.enabled,
      this.labelText,
      this.autofillHints})
      : super(key: key);

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// If false the text field is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [InputDecoration.enabled] property.
  final bool? enabled;

  /// Text that describes the input field.
  ///
  /// When the input field is empty and unfocused, the label is displayed on
  /// top of the input field (i.e., at the same location on the screen where
  /// text may be entered in the input field). When the input field receives
  /// focus (or if the field is non-empty), the label moves above (i.e.,
  /// vertically adjacent to) the input field.
  final String? labelText;

  /// {@macro flutter.widgets.editableText.autofillHints}
  /// {@macro flutter.services.AutofillConfiguration.autofillHints}
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final visible = useState<bool>(false);
    return TextFormField(
      controller: controller,
      obscureText: !visible.value,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: visible.value
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
          onPressed: () {
            visible.value = !visible.value;
          },
        ),
        labelText: labelText,
      ),
      enabled: enabled,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants.dart';
import '../providers/auth.dart';
import '../api/api.dart';

class LoginScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authProvider);
    final _emailFieldController = useTextEditingController
        .fromValue(TextEditingValue(text: auth.email ?? ''));
    final _hostFieldController = useTextEditingController
        .fromValue(TextEditingValue(text: auth.host ?? DEFAULT_HOST));
    final _passwordFieldController =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final _error = useState<String?>(null);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _hostFieldController,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Host',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailFieldController,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordFieldController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            if (_error.value != null) Text(_error.value!),
            ElevatedButton(
              onPressed: () async {
                try {
                  ApiController.setInstance(_hostFieldController.text);
                  await ApiController.instance.auth.login(
                      _emailFieldController.text,
                      _passwordFieldController.text);
                  await context.read(authProvider.notifier).loggedIn(
                      _hostFieldController.text, _emailFieldController.text);
                  await context.read(authProvider.notifier).saveToLocal();
                } on DioError catch (e) {
                  _error.value =
                      e.response?.data?['message'] ?? 'Unknown Error Occurred';
                } catch (e) {
                  _error.value = 'Unknown Error Occurred';
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

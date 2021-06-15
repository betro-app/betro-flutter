import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants.dart';
import '../providers/auth.dart';
import '../api/api.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<void> _submit(
      BuildContext context, String host, String email, String password) async {
    ApiController.setInstance(host);
    await ApiController.instance.auth.login(email, password);
    await ApiController.instance.keys.fetchKeys();
    await context.read(authProvider.notifier).loggedIn(host, email);
    await context.read(authProvider.notifier).saveToLocal();
  }

  @override
  Widget build(BuildContext context) {
    final _loading = useState<bool>(false);
    final _auth = useProvider(authProvider);
    final _emailFieldController = useTextEditingController
        .fromValue(TextEditingValue(text: _auth.email ?? ''));
    final _hostFieldController = useTextEditingController
        .fromValue(TextEditingValue(text: _auth.host ?? DEFAULT_HOST));
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
              enabled: !_loading.value,
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
              enabled: !_loading.value,
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
              enabled: !_loading.value,
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
              onPressed: _loading.value
                  ? null
                  : () async {
                      try {
                        _loading.value = true;
                        await _submit(
                          context,
                          _hostFieldController.text,
                          _emailFieldController.text,
                          _passwordFieldController.text,
                        );
                      } on DioError catch (e) {
                        _error.value = e.response?.data?['message'] ??
                            'Unknown Error Occurred';
                      } catch (e) {
                        _error.value = 'Unknown Error Occurred';
                      } finally {
                        _loading.value = false;
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

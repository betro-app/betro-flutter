import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/auth.dart';
import '../hooks/auth.dart';
import '../api/api.dart';
import '../components/password.dart';

final _logger = Logger('screens/login');

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<void> _submit(
      WidgetRef ref, String host, String email, String password) async {
    ApiController.setInstance(host);
    await ApiController.instance.auth.login(email, password);
    await ApiController.instance.keys.fetchKeys();
    ref.read(authProvider.notifier).loggedIn(host, email);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSecureStorageAvailable = useIsSecureStorageAvailable();
    final saveToLocal = useSaveToLocal(ref);
    final _loading = useState<bool>(false);
    final _auth = ref.watch(authProvider);
    final _emailFieldController = useTextEditingController
        .fromValue(TextEditingValue(text: _auth.email ?? ''));
    final _hostFieldController =
        useTextEditingController.fromValue(TextEditingValue(text: _auth.host));
    final _passwordFieldController =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final _saveCredentialsController = useState<bool>(false);
    final _error = useState<String?>(null);
    final _isMounted = useIsMounted();
    useEffect(() {
      isSecureStorageAvailable.call();
    }, []);
    return SafeArea(
      child: Scaffold(
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
                autofillHints: _loading.value ? null : [AutofillHints.url],
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
                autofillHints: _loading.value ? null : [AutofillHints.email],
                enabled: !_loading.value,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              PasswordFormField(
                controller: _passwordFieldController,
                enabled: !_loading.value,
                labelText: 'Password',
                autofillHints: _loading.value ? null : [AutofillHints.password],
              ),
              CheckboxListTile(
                value: _saveCredentialsController.value,
                onChanged: (isSecureStorageAvailable.loading ||
                        !isSecureStorageAvailable.data)
                    ? null
                    : (value) =>
                        _saveCredentialsController.value = value ?? false,
                title: const Text('Save user credentials?'),
              ),
              if (_error.value != null) Text(_error.value!),
              ElevatedButton(
                onPressed: _loading.value
                    ? null
                    : () async {
                        try {
                          _loading.value = true;
                          await _submit(
                            ref,
                            _hostFieldController.text,
                            _emailFieldController.text,
                            _passwordFieldController.text,
                          );
                          await saveToLocal
                              .call(_saveCredentialsController.value);
                          await Navigator.pushReplacementNamed(
                              context, '/home');
                        } on DioError catch (e, s) {
                          _logger.warning(e.response.toString(), e, s);
                          if (_isMounted()) {
                            _error.value = e.response?.data?['message'] ??
                                'Unknown Error Occurred';
                          }
                        } catch (e, s) {
                          _logger.warning(e.toString(), e, s);
                          if (_isMounted()) {
                            _error.value = 'Unknown Error Occurred';
                          }
                        } finally {
                          if (_isMounted()) {
                            _loading.value = false;
                          }
                        }
                      },
                child: Text('Submit'),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/register'),
                  child: Text('Register',
                      style: Theme.of(context).primaryTextTheme.subtitle1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

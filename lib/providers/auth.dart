import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

const HOST_SHARED_KEY = 'HOST';
const EMAIL_SHARED_KEY = 'EMAIL';

final authProvider = StateNotifierProvider<Auth, AuthState>((ref) {
  return Auth();
});

class Auth extends StateNotifier<AuthState> {
  Auth() : super(AuthState(host: DEFAULT_HOST));

  Future<void> loadFromLocal() async {
    final instance = await SharedPreferences.getInstance();
    final host = instance.getString(HOST_SHARED_KEY);
    final email = instance.getString(EMAIL_SHARED_KEY);
    if (host != null && email != null) {
      state = state.copyWith(
        isLoaded: true,
        isLoggedIn: false,
        host: host,
        email: email,
      );
    } else {
      state = state.copyWith(
        isLoaded: true,
        isLoggedIn: false,
      );
    }
  }

  Future<void> saveToLocal() async {
    final instance = await SharedPreferences.getInstance();
    final host = state.host;
    final email = state.email;
    if (host != null && email != null) {
      await instance.setString(HOST_SHARED_KEY, host);
      await instance.setString(EMAIL_SHARED_KEY, email);
    }
  }

  Future<void> resetLocal() async {
    final instance = await SharedPreferences.getInstance();
    await instance.remove(HOST_SHARED_KEY);
    await instance.remove(EMAIL_SHARED_KEY);
  }

  Future<void> loggedIn(String host, String email) async {
    state = state.copyWith(
      host: host,
      email: email,
      isLoggedIn: true,
    );
  }

  Future<void> loggedOut() async {
    state = AuthState(host: DEFAULT_HOST);
  }
}

class AuthState {
  final bool isLoaded;
  final bool isLoggedIn;
  final String? host;
  final String? email;

  AuthState(
      {this.isLoaded = false, this.isLoggedIn = false, this.host, this.email});

  AuthState copyWith({
    bool? isLoaded,
    bool? isLoggedIn,
    String? host,
    String? email,
  }) =>
      AuthState(
        isLoaded: isLoaded ?? this.isLoaded,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        host: host ?? this.host,
        email: email ?? this.email,
      );
}

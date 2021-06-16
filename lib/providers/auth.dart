import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants.dart';

final authProvider = StateNotifierProvider<Auth, AuthState>((ref) {
  return Auth();
});

class Auth extends StateNotifier<AuthState> {
  Auth() : super(AuthState());

  void loaded(String host, String email) {
    state = state.copyWith(
      isLoaded: true,
      isLoggedIn: false,
      host: host,
      email: email,
    );
  }

  void loggedIn(String host, String email) {
    state = state.copyWith(
      host: host,
      email: email,
      isLoggedIn: true,
      isLoaded: true,
    );
  }

  void loggedOut() {
    state = AuthState(isLoaded: true, isLoggedIn: false);
  }
}

class AuthState {
  final bool isLoaded;
  final bool isLoggedIn;
  final String host;
  final String? email;

  AuthState(
      {this.isLoaded = false,
      this.isLoggedIn = false,
      this.host = DEFAULT_HOST,
      this.email});

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

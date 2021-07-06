import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/auth.dart';
import '../providers/auth.dart';

class LoadingScreen extends HookConsumerWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider);
    final loadFromLocal = useLoadFromLocal(ref);
    useEffect(() {
      if (!loadFromLocal.loading && auth.isLoaded && auth.isLoggedIn) {
        Future.delayed(Duration.zero,
            () => Navigator.pushReplacementNamed(context, '/home'));
      } else if (!loadFromLocal.loading && auth.isLoaded) {
        Future.delayed(Duration.zero,
            () => Navigator.pushReplacementNamed(context, '/login'));
      } else {
        loadFromLocal.call();
      }
    }, [auth.isLoaded, auth.isLoggedIn]);
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).primaryColor
          : Colors.black,
      body: Center(
        child: Image.asset(
          'assets/icon/ic_launcher.png',
          width: 96,
        ),
      ),
    );
  }
}

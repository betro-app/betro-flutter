import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../router.dart';
import '../providers/auth.dart';

class LoadingScreen extends HookWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authProvider);
    useEffect(() {
      if (auth.isLoaded && auth.isLoggedIn) {
        Future.delayed(
            Duration.zero, () => AppRouter.router.navigateTo(context, '/home'));
      } else if (auth.isLoaded) {
        Future.delayed(Duration.zero,
            () => AppRouter.router.navigateTo(context, '/login'));
      } else {
        context.read(authProvider.notifier).loadFromLocal();
      }
    }, [auth.isLoaded, auth.isLoggedIn]);
    return Scaffold(
      body: Center(
        child: Text('Loading'),
      ),
    );
  }
}

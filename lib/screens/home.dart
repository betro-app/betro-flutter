import 'package:flutter/material.dart';

import '../components/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const AppDrawer(),
        body: Center(
          child: Text('Welcome'),
        ),
      );
}

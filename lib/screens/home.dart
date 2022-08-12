import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../components/feed.dart';
import '../components/drawer.dart';
import '../hooks/feed.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchHomeFeed = useFetchHomeFeed(null);
    useEffect(() {
      ApiController.instance.keys.fetchKeys();
      fetchHomeFeed.call();
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchHomeFeed.call(true);
        },
        child: PostsFeed(
          allowUserNavigation: true,
          hook: fetchHomeFeed,
          loadOnScroll: true,
        ),
      ),
    );
  }
}

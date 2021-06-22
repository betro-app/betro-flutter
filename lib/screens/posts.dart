import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../components/feed.dart';
import '../components/drawer.dart';
import '../hooks/feed.dart';

class PostsScreen extends HookWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchOwnFeed = useFetchOwnFeed(null);
    useEffect(() {
      fetchOwnFeed.call();
    }, []);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Own Posts'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchOwnFeed.call(true);
        },
        child: PostsFeed(
          allowUserNavigation: false,
          hook: fetchOwnFeed,
          loadOnScroll: true,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../components/post.dart';
import '../components/drawer.dart';
import '../hooks/feed.dart';

const bool _allowAutoLoad = true;

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget _buildLoading() => const Center(
        child: CircularProgressIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    final fetchHomeFeed = useFetchHomeFeed(null);
    useEffect(() {
      ApiController.instance.keys.fetchKeys();
      fetchHomeFeed.call();
    }, []);
    final loaded = fetchHomeFeed.loaded;
    final pageInfo = fetchHomeFeed.pageInfo;
    final posts = fetchHomeFeed.posts;
    final itemCount = (pageInfo == null || posts == null || loaded == false)
        ? 1
        : (pageInfo.next ? posts.length + 1 : posts.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return fetchHomeFeed.call(true);
        },
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final loading = fetchHomeFeed.loading;
            if (pageInfo == null ||
                posts == null ||
                loaded == false ||
                (index >= posts.length && loading)) {
              return _buildLoading();
            }
            if (pageInfo.total == 0) {
              return const Center(
                child: Text('No posts'),
              );
            }
            if (index >= posts.length && pageInfo.next) {
              if (_allowAutoLoad && !loading) {
                fetchHomeFeed.call();
                return _buildLoading();
              } else {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      fetchHomeFeed.call();
                    },
                    child: Text(
                      'Load More',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                  ),
                );
              }
            }
            final post = posts[index];
            return PostTile(
              post: post,
            );
          },
        ),
      ),
    );
  }
}

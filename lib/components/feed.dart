import 'package:flutter/material.dart';

import '../hooks/common.dart';
import '../api/types/FeedResource.dart';
import '../api/types/PageInfo.dart';
import './post.dart';

class PostsFeed extends StatelessWidget {
  const PostsFeed({
    Key? key,
    required this.hook,
    this.shrinkWrap = false,
    this.loadOnScroll = false,
  }) : super(key: key);

  final HomeFeedCallback hook;
  final bool shrinkWrap;
  final bool loadOnScroll;

  Widget _buildLoading() => const Center(
        child: CircularProgressIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    final loaded = hook.loaded;
    final pageInfo = hook.pageInfo;
    final posts = hook.posts;
    final itemCount = (pageInfo == null || posts == null || loaded == false)
        ? 1
        : (pageInfo.next ? posts.length + 1 : posts.length);
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final loading = hook.loading;
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
          if (loadOnScroll && !loading) {
            hook.call();
            return _buildLoading();
          } else {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: GestureDetector(
                onTap: () {
                  hook.call();
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
    );
  }
}

import 'package:flutter/material.dart';

import '../hooks/common.dart';
import './post.dart';

class PostsFeed extends StatelessWidget {
  PostsFeed({
    Key? key,
    required this.hook,
    this.shrinkWrap = false,
    this.loadOnScroll = false,
    ScrollController? controller,
  })  : _controller = controller ?? ScrollController(),
        super(key: key);

  final HomeFeedCallback hook;
  final bool shrinkWrap;
  final bool loadOnScroll;
  final ScrollController _controller;

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
      controller: _controller,
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

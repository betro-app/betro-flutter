import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../components/drawer.dart';
import '../hooks/feed.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchHomeFeed = useFetchHomeFeed();
    useEffect(() {
      fetchHomeFeed.callback();
    }, []);
    print(fetchHomeFeed.posts);
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      drawer: const AppDrawer(),
      body: !fetchHomeFeed.loaded
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: fetchHomeFeed.pageInfo?.total ?? 0,
              itemBuilder: (context, index) {
                final posts = fetchHomeFeed.posts;
                if (posts == null || posts.length <= index) {
                  return Container(
                    child: Text('Invalid post'),
                  );
                }
                final post = posts[index];
                final text_content = post.text_content;
                final media_content = post.media_content;
                if (media_content != null) {
                  return ListTile(
                    title: Image.memory(Uint8List.fromList(media_content)),
                    subtitle: text_content == null ? null : Text(text_content),
                  );
                }
                return ListTile(
                  title: Text(text_content ?? ''),
                );
              },
            ),
    );
  }
}

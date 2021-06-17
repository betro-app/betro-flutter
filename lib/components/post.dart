import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/types/FeedResource.dart';
import '../api/types/LikeResponse.dart';
import '../api/api.dart';

ImageFrameBuilder _frameBuilder = (BuildContext context, Widget child,
    int? frame, bool wasSynchronouslyLoaded) {
  if (wasSynchronouslyLoaded) {
    return child;
  }
  return AnimatedOpacity(
    opacity: frame == null ? 0 : 1,
    duration: const Duration(seconds: 1),
    curve: Curves.easeOut,
    child: child,
  );
};

class PostTile extends StatelessWidget {
  const PostTile({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostResource post;
  String _accountName(PostResourceUser user) {
    var _name = '';
    final first_name = user.first_name;
    final last_name = user.last_name;
    if (first_name != null) {
      _name = first_name + (last_name == null ? '' : ' ' + last_name);
    }
    return _name;
  }

  Widget _buildUserInfo() {
    final user = post.user;
    if (user == null) {
      return Container();
    }
    final profile_picture = user.profile_picture;
    return ListTile(
      leading: profile_picture == null
          ? null
          : Image.memory(
              profile_picture,
              frameBuilder: _frameBuilder,
            ),
      title: Text(_accountName(user)),
      subtitle: Text(user.username),
    );
  }

  List<Widget> _buildPost(BuildContext context) {
    final text_content = post.text_content;
    final media_content = post.media_content;
    return [
      if (text_content != null)
        ListTile(
          title: Text(text_content),
        ),
      if (media_content != null)
        Container(
          padding: EdgeInsets.only(top: 10),
          alignment: MediaQuery.of(context).size.width > 600
              ? Alignment.topLeft
              : Alignment.center,
          child: Image.memory(
            media_content,
            width: min(MediaQuery.of(context).size.width - 40, 600),
            frameBuilder: _frameBuilder,
          ),
        ),
      PostLikeButton(
        id: post.id,
        likes: post.likes,
        is_liked: post.is_liked,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          ..._buildPost(context),
        ],
      ),
    );
  }
}

class PostLikeButton extends HookWidget {
  const PostLikeButton(
      {Key? key, required this.id, required this.is_liked, required this.likes})
      : super(key: key);

  final String id;
  final bool is_liked;
  final int likes;
  @override
  Widget build(BuildContext context) {
    final is_liked = useState<bool>(this.is_liked);
    final likes = useState<int>(this.likes);
    return Container(
      padding: EdgeInsets.only(
        bottom: 10,
        top: 10,
        left: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () async {
              LikeResponse? likeResponse;
              print(id);
              if (is_liked.value) {
                likeResponse = await ApiController.instance.post.unlike(id);
              } else {
                likeResponse = await ApiController.instance.post.like(id);
              }
              is_liked.value = likeResponse.liked;
              likes.value = likeResponse.likes ?? 0;
            },
            icon: is_liked.value
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_outline),
            color: is_liked.value ? Theme.of(context).primaryColor : null,
          ),
          Text(likes.value.toString())
        ],
      ),
    );
  }
}

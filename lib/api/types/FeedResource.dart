import 'dart:typed_data';

import 'PageInfo.dart';
import 'PostResource.dart';

class FeedResource {
  final List<PostResource> data;
  final PageInfo pageInfo;

  FeedResource({
    required this.data,
    required this.pageInfo,
  });
}

class UserProfile {
  String? first_name;
  String? last_name;
  Uint8List? profile_picture;
  String? own_private_key;

  UserProfile({
    this.first_name,
    this.last_name,
    this.profile_picture,
    this.own_private_key,
  });
}

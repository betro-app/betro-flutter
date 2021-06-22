import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/api.dart';
import '../api/types/SearchUserResource.dart';
import '../components/userinfo.dart';
import '../api/types/UserInfo.dart';

bool loadOnScroll = true;

class SearchUsersScreen extends HookWidget {
  const SearchUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _searchTextController =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final _loading = useState<bool>(false);
    final _data = useState<List<SearchUserResource>?>(null);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchTextController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
            suffixIcon: IconButton(
              onPressed: () async {
                final value = _searchTextController.text;
                if (!_loading.value && value.isNotEmpty) {
                  _loading.value = true;
                  final searchResults =
                      await ApiController.instance.user.fetchSearchUser(value);
                  _data.value = searchResults;
                  _loading.value = false;
                }
              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _data.value == null ? 1 : _data.value?.length,
        itemBuilder: (BuildContext context, index) {
          final data = _data.value;
          if (data == null && _loading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data == null) {
            return Center(
              child: Text('No results'),
            );
          }
          final result = data[index];
          return UserListTile(
            allowNavigation: true,
            user: UserInfo(
              id: result.id,
              is_approved: result.is_following,
              is_following: result.is_following_approved,
              username: result.username,
              first_name: result.first_name,
              last_name: result.last_name,
              profile_picture: result.profile_picture,
            ),
          );
        },
      ),
    );
  }
}

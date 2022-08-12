import 'package:betro/api/api.dart';
import 'package:betro/screens/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/types/NotificationResponse.dart';

class NotificationsScreen extends HookWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _loading = useState<bool>(false);
    final _data = useState<List<NotificationResponse>?>(null);
    useEffect(() {
      _loading.value = true;
      ApiController.instance.notification.fetchNotifications().then((value) {
        _data.value = value;
        _loading.value = false;
      });
      return null;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loading.value = true;
          final value =
              await ApiController.instance.notification.fetchNotifications();
          _data.value = value;
          _loading.value = false;
        },
        child: ListView.builder(
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
            return ListTile(
              title: Text(
                result.content,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: result.read
                          ? Theme.of(context).disabledColor
                          : Colors.black,
                    ),
              ),
              onTap: () {
                _loading.value = true;
                ApiController.instance.notification
                    .readNotification(result.id)
                    .then((isRead) {
                  final value = _data.value;
                  if (value != null) {
                    _loading.value = false;
                    _data.value = value
                        .map((e) =>
                            e.id == result.id ? e.copyWith(read: isRead) : e)
                        .toList();
                  } else {
                    ApiController.instance.notification
                        .fetchNotifications()
                        .then((value) {
                      _loading.value = false;
                      _data.value = value;
                    });
                  }
                });
                if (result.action ==
                    NotificationActions.notification_on_approved) {
                  final username = result.payload?['username'];
                  if (username == null) {
                    Navigator.of(context).pushNamed('/followees');
                  } else {
                    Navigator.of(context).pushNamed(
                      '/user',
                      arguments: UserScreenProps(
                        username: username,
                      ),
                    );
                  }
                } else if (result.action ==
                    NotificationActions.notification_on_followed) {
                  Navigator.of(context).pushNamed('/approvals');
                }
              },
            );
          },
        ),
      ),
    );
  }
}

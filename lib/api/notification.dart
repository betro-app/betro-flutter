import 'dart:convert';

import './types/NotificationResponse.dart';
import './auth.dart';

class NotificationController {
  final AuthController auth;
  NotificationController(this.auth);

  Future<List<NotificationResponse>> fetchNotifications() async {
    final response = await auth.client.get('/api/notifications');
    return (response.data as List<dynamic>)
        .map((jsonT) => NotificationResponse.fromJson(jsonT))
        .toList();
  }

  Future<bool> readNotification(String id) async {
    final req = <String, dynamic>{'notification_id': id};
    final response = await auth.client
        .post('//api/notifications/read', data: jsonEncode(req));
    return response.data['read'];
  }
}

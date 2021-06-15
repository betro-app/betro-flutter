import 'package:betro_dart_lib/betro_dart_lib.dart';

import './auth.dart';

class AccountController {
  final AuthController auth;
  AccountController(this.auth);

  Future<List<int>?> fetchProfilePicture() async {
    final symKey = auth.symKey;
    if (symKey == null) return null;
    final response = await auth.client.get('/api/account/profile_picture');
    final profilePicture = await symDecrypt(symKey, response.data);
    return profilePicture;
  }
}

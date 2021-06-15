import 'dart:typed_data';

import 'package:betro_dart_lib/betro_dart_lib.dart';

import './auth.dart';
import './types/KeysResponse.dart';

class KeysController {
  final AuthController auth;
  KeysController(this.auth);

  Future<bool> fetchKeys() async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return false;
    final response =
        await auth.client.get('/api/keys?include_echd_counts=true');
    final keys = KeysResponse.fromJson(response.data);
    final symKey = await symDecrypt(encryptionKey, keys.sym_key);
    auth.symKey = Uint8List.fromList(symKey);
    return true;
  }
}

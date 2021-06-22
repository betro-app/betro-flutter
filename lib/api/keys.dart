import 'dart:convert';
import 'dart:typed_data';

import 'package:pedantic/pedantic.dart';
import 'package:betro_dart_lib/betro_dart_lib.dart';
import 'package:logging/logging.dart';

import './auth.dart';
import './types/KeysResponse.dart';
import './types/EcdhKeyResponse.dart';
import './types/EcdhKeyResource.dart';
import './types/EcPairRequest.dart';

final _logger = Logger('api/keys');

class KeysController {
  final AuthController auth;
  KeysController(this.auth);

  Future<bool> fetchKeys() async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return false;
    final response =
        await auth.client.get('/api/keys?include_echd_counts=true');
    final keys = KeysResponse.fromJson(response.data);
    final ecdh_max_keys = keys.ecdh_max_keys;
    final ecdh_unclaimed_keys = keys.ecdh_unclaimed_keys;
    if (ecdh_unclaimed_keys > 0) {
      unawaited(fetchExistingEcdhKeys());
    }
    if (ecdh_unclaimed_keys < ecdh_max_keys) {
      unawaited(
          generateEcdhKeys((ecdh_max_keys / 2 - ecdh_unclaimed_keys).floor()));
    }
    final symKey = await symDecrypt(encryptionKey, keys.sym_key);
    auth.symKey = Uint8List.fromList(symKey);
    return true;
  }

  Future<bool> generateEcdhKeys([int n = 20]) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return false;
    if (n <= 0) {
      return false;
    }
    final keyPairs = await Future.wait(
      List.generate(n, (index) => index).map((e) => generateExchangePair()),
    );
    final keyPairMappings = <String, String>{};
    for (var keyPair in keyPairs) {
      keyPairMappings[keyPair.publicKey] = keyPair.privateKey;
    }
    final encryptedKeyPairsRequest = await Future.wait(
      keyPairs.map(
        (e) async {
          final privateKey = await symEncrypt(
            encryptionKey,
            base64Decode(e.privateKey),
          );
          return EcPairRequest(e.publicKey, privateKey);
        },
      ),
    );
    final response = await auth.client.post('/api/keys/ecdh/upload',
        data: encryptedKeyPairsRequest.map((e) => e.toJson()).toList());
    final data = response.data;
    if (data == null) return false;
    final encryptedKeyPairs = (data as List<dynamic>)
        .map((a) => EcdhKeyResponse.fromJson(a))
        .toList();
    await _processEcdhKeys(encryptedKeyPairs);
    return true;
  }

  Future<bool> fetchExistingEcdhKeys() async {
    final response =
        await auth.client.get('/api/keys/ecdh?include_types=unclaimed');
    final data = response.data;
    if (data == null) return false;
    final encryptedKeyPairs = (data as List<dynamic>)
        .map((a) => EcdhKeyResponse.fromJson(a))
        .toList();
    await _processEcdhKeys(encryptedKeyPairs);
    return false;
  }

  Future<void> _processEcdhKeys(List<EcdhKeyResponse> encryptedKeyPairs) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return;
    for (var key in encryptedKeyPairs) {
      final privateKey = await symDecrypt(encryptionKey, key.private_key);
      auth.ecdhKeys[key.id] = EcdhKeyResource(
        id: key.id,
        claimed: key.claimed,
        public_key: key.public_key,
        private_key: privateKey,
      );
    }
    _logger.fine(auth.ecdhKeys.length);
  }
}

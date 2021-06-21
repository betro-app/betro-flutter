import 'dart:convert';

import 'package:betro_dart_lib/betro_dart_lib.dart';
import 'package:logging/logging.dart';

import './auth.dart';
import './helper.dart';
import './types/ApprovalResource.dart';
import './types/ApprovalResponse.dart';
import './types/FollowerResource.dart';
import './types/FollowerResponse.dart';
import './types/FolloweeResource.dart';
import './types/FolloweeResponse.dart';
import './types/PaginatedResponse.dart';
import './types/ApproveUserRequest.dart';
import './types/FollowUserRequest.dart';
import './types/FollowUserResponse.dart';

final _logger = Logger('api/follow');

class FollowController {
  final AuthController auth;
  FollowController(this.auth);

  Future<PaginatedResponse<ApprovalResource>?> fetchPendingApprovals(
      [String? after]) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    const limit = 20;
    after ??= base64Encode(utf8.encode(DateTime.now().toIso8601String()));
    final response = await auth.http1Client
        .get('/api/follow/approvals?limit=$limit&after=$after');
    final resp = PaginatedResponse<ApprovalResponse>.fromJson(
        response.data, (json) => ApprovalResponse.fromJson(json));
    final list = <ApprovalResource>[];
    for (var item in resp.data) {
      final user = await parseUserGrant(encryptionKey, item);
      list.add(
        ApprovalResource(
          id: item.id,
          follower_id: item.follower_id,
          username: item.username,
          created_at: item.created_at,
          first_name: user.first_name,
          last_name: user.last_name,
          profile_picture: user.profile_picture,
          public_key: item.public_key,
          own_key_id: item.own_key_id,
          own_private_key: user.own_private_key,
        ),
      );
    }
    return PaginatedResponse<ApprovalResource>(
      data: list,
      next: resp.next,
      limit: resp.limit,
      total: resp.total,
      after: resp.after,
    );
  }

  Future<PaginatedResponse<FollowerResource>?> fetchFollowers(
      [String? after]) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    const limit = 20;
    after ??= base64Encode(utf8.encode(DateTime.now().toIso8601String()));
    final response = await auth.http1Client
        .get('/api/follow/followers?limit=$limit&after=$after');
    final resp = PaginatedResponse<FollowerResponse>.fromJson(
        response.data, (json) => FollowerResponse.fromJson(json));
    final list = <FollowerResource>[];
    for (var item in resp.data) {
      final user = await parseUserGrant(encryptionKey, item);
      list.add(
        FollowerResource(
          user_id: item.user_id,
          follow_id: item.follow_id,
          username: item.username,
          group_id: item.group_id,
          group_name: item.group_name,
          group_is_default: item.group_is_default,
          is_following: item.is_following,
          is_following_approved: item.is_following_approved,
          public_key: item.public_key,
          first_name: user.first_name,
          last_name: user.last_name,
          profile_picture: user.profile_picture,
        ),
      );
    }
    return PaginatedResponse<FollowerResource>(
      data: list,
      next: resp.next,
      limit: resp.limit,
      total: resp.total,
      after: resp.after,
    );
  }

  Future<PaginatedResponse<FolloweeResource>?> fetchFollowees(
      [String? after]) async {
    final encryptionKey = auth.encryptionKey;
    if (encryptionKey == null) return null;
    const limit = 20;
    after ??= base64Encode(utf8.encode(DateTime.now().toIso8601String()));
    final response = await auth.http1Client
        .get('/api/follow/followees?limit=$limit&after=$after');
    final resp = PaginatedResponse<FolloweeResponse>.fromJson(
        response.data, (json) => FolloweeResponse.fromJson(json));
    final list = <FolloweeResource>[];
    for (var item in resp.data) {
      final user = await parseUserGrant(encryptionKey, item);
      list.add(
        FolloweeResource(
          user_id: item.user_id,
          follow_id: item.follow_id,
          username: item.username,
          is_approved: item.is_approved,
          public_key: item.public_key,
          first_name: user.first_name,
          last_name: user.last_name,
          profile_picture: user.profile_picture,
        ),
      );
    }
    return PaginatedResponse<FolloweeResource>(
      data: list,
      next: resp.next,
      limit: resp.limit,
      total: resp.total,
      after: resp.after,
    );
  }

  Future<FollowUserResponse?> followUser(
    String followee_id,
    String followee_key_id, [
    String? followee_public_key,
  ]) async {
    final symKey = auth.symKey;
    if (symKey == null) return null;
    final ownKeyPair = auth.ecdhKeys.entries.first;
    String? encrypted_profile_sym_key;
    if (followee_public_key != null) {
      final derivedKey = await deriveExchangeSymKey(
        followee_public_key,
        base64Encode(ownKeyPair.value.private_key),
      );
      encrypted_profile_sym_key = await symEncrypt(
        derivedKey,
        symKey.toList(),
      );
    }
    final req = FollowUserRequest(
      followee_id: followee_id,
      followee_key_id: followee_key_id,
      own_key_id: ownKeyPair.value.id,
      encrypted_profile_sym_key: encrypted_profile_sym_key,
    );
    final response =
        await auth.http1Client.post('/api/follow/', data: jsonEncode(req));
    _logger.finer(response.data);
    return FollowUserResponse.fromJson(response.data);
  }

  Future<bool> approveUser(
    String followId,
    String follower_public_key,
    String group_id,
    String encrypted_by_user_group_sym_key,
    String own_key_id,
    String private_key, [
    bool allowProfileRead = false,
  ]) async {
    final encryptionKey = auth.encryptionKey;
    final symKey = auth.symKey;
    if (encryptionKey == null) return false;
    final decryptedGroupSymKey =
        await symDecrypt(encryptionKey, encrypted_by_user_group_sym_key);
    final derivedKey =
        await deriveExchangeSymKey(follower_public_key, private_key);
    final encrypted_group_sym_key =
        await symEncrypt(derivedKey, decryptedGroupSymKey);
    String? encrypted_profile_sym_key;
    if (allowProfileRead && symKey != null) {
      encrypted_profile_sym_key = await symEncrypt(derivedKey, symKey);
    }
    final req = ApproveUserRequest(
      follow_id: followId,
      group_id: group_id,
      encrypted_group_sym_key: encrypted_group_sym_key,
      encrypted_profile_sym_key: encrypted_profile_sym_key,
      own_key_id: own_key_id,
    );
    final response = await auth.http1Client
        .post('/api/follow/approve', data: jsonEncode(req));
    return response.data['approved'];
  }
}

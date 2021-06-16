import 'package:json_annotation/json_annotation.dart';

part 'ProfileGrantRow.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class ProfileGrantRow {
  String? first_name;
  String? last_name;
  String? profile_picture;
  String? public_key;
  String? own_key_id;
  String? own_private_key;
  String? encrypted_profile_sym_key;

  ProfileGrantRow({
    this.first_name,
    this.last_name,
    this.profile_picture,
    this.public_key,
    this.own_key_id,
    this.own_private_key,
    this.encrypted_profile_sym_key,
  });
  factory ProfileGrantRow.fromJson(Map<String, dynamic> json) =>
      _$ProfileGrantRowFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileGrantRowToJson(this);
}

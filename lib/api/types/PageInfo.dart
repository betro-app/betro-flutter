import 'package:json_annotation/json_annotation.dart';

part 'PageInfo.g.dart';

@JsonSerializable() // This annotation let instances of MyData travel to/from JSON
class PageInfo {
  final bool updating;
  final bool next;
  final int limit;
  final int total;
  final String? after;

  PageInfo({
    required this.updating,
    required this.next,
    required this.limit,
    required this.total,
    this.after,
  });
  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PageInfoToJson(this);
}

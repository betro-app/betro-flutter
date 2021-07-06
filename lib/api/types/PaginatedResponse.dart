class PaginatedResponse<T> {
  final List<T> data;
  final bool next;
  final int limit;
  final int total;
  final String? after;

  PaginatedResponse({
    required this.data,
    required this.next,
    required this.limit,
    required this.total,
    this.after,
  });
  factory PaginatedResponse.fromJson(Map<String, dynamic> json,
          T Function(Map<String, dynamic> jsonT) fromJsonT) =>
      PaginatedResponse<T>(
        data: (json['data'] as List<dynamic>)
            .map((jsonT) => fromJsonT(jsonT))
            .toList(),
        next: json['next'] as bool,
        limit: json['limit'] as int,
        total: json['total'] as int,
        after: json['after'] as String?,
      );

  PaginatedResponse<T> copyWith({
    List<T>? data,
    bool? next,
    int? limit,
    int? total,
    String? after,
  }) =>
      PaginatedResponse(
        data: data ?? this.data,
        next: next ?? this.next,
        limit: limit ?? this.limit,
        total: total ?? this.total,
        after: after ?? this.after,
      );
}

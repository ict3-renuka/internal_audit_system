import 'audit_request_model.dart';

class AuditRequestPaginatedModel {
  final List<AuditRequestModel> data;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  AuditRequestPaginatedModel({
    required this.data,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory AuditRequestPaginatedModel.fromJson(Map<String, dynamic> json) {
    return AuditRequestPaginatedModel(
      data: (json['data'] as List)
          .map((e) => AuditRequestModel.fromJson(e))
          .toList(),
      totalCount: json['totalCount'],
      page: json['page'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],
    );
  }
}
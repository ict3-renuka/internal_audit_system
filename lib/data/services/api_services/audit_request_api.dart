import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constant/api_constant.dart';
import '../../models/audit_request_model.dart';
import '../../models/audit_request_paginated_model.dart';

class AuditRequestApi {

  Future<void> addAuditRequest(AuditRequestModel auditRequest) async {
    try {
      final url = Uri.parse("${ApiConstant.baseUrl}/AuditRequest");

      final body = jsonEncode(auditRequest.toJson());

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception("API Failed: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<AuditRequestPaginatedModel> getAllAuditRequests({int page = 1, int pageSize = 20}) async {
    try {
      final url = Uri.parse("${ApiConstant.baseUrl}/AuditRequest?page=$page&pageSize=$pageSize");

      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception("API Failed: ${response.body}");
      }

      return AuditRequestPaginatedModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<void> updateAuditRequest(int requestId, AuditRequestModel auditRequest) async {
    try {
      final url = Uri.parse(
        "${ApiConstant.baseUrl}/AuditRequest/$requestId",
      );

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(auditRequest.toJson()),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception("Update failed: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
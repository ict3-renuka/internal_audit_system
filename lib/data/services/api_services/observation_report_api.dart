import 'dart:convert';
import 'dart:js_interop';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as html;
import '../../../core/constant/api_constant.dart';
import 'dart:typed_data';

class ObservationReportApi {
  // Future<Uint8List> getReport({
  //   int? departmentId,
  //   int? internalDepartmentId,
  //   DateTime? fromDate,
  //   DateTime? toDate,
  // }) async {
  //   final uri = Uri.parse(
  //     "${ApiConstant.baseUrl}/ObservationDetails/observation-report",
  //   ).replace(queryParameters: {
  //     if (departmentId != null) "departmentId": departmentId.toString(),
  //     if (internalDepartmentId != null)
  //       "internalDepartmentId": internalDepartmentId.toString(),
  //     if (fromDate != null)
  //       "fromDate": fromDate.toIso8601String(),
  //     if (toDate != null)
  //       "toDate": toDate.toIso8601String(),
  //   });
  //
  //   final response = await http.get(uri);
  //
  //   if (response.statusCode != 200) {
  //     throw Exception("Failed to load report");
  //   }
  //
  //   return response.bodyBytes;
  // }

  // void openPdfInBrowser(Uint8List bytes) {
  //   final blob = html.Blob(
  //     <html.BlobPart>[bytes.toJS].toJS,
  //     html.BlobPropertyBag(type: 'application/pdf'),
  //   );
  //
  //   final url = html.URL.createObjectURL(blob);
  //   html.window.open(url, "_blank");
  //
  //   Future.delayed(const Duration(minutes: 1), () {
  //     html.URL.revokeObjectURL(url);
  //   });
  // }

  void openReportInBrowser({
    int? departmentId,
    int? internalDepartmentId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    final url = Uri.parse(
      "${ApiConstant.baseUrl}/ObservationDetails/observation-report",
    ).replace(queryParameters: {
      if (departmentId != null) "departmentId": departmentId.toString(),
      if (internalDepartmentId != null)
        "internalDepartmentId": internalDepartmentId.toString(),
      if (status != null)
        "status": status,
      if (fromDate != null) "fromDate": fromDate.toIso8601String(),
      if (toDate != null) "toDate": toDate.toIso8601String(),
    }).toString();

    html.window.open(url, "_blank");
  }
}
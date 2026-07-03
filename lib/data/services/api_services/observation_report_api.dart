import 'package:web/web.dart' as html;
import '../../../core/constant/api_constant.dart';

class ObservationReportApi {

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
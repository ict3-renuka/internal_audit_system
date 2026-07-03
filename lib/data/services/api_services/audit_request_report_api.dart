import 'package:web/web.dart' as html;

import '../../../core/constant/api_constant.dart';

class AuditRequestReportApi {

  void openReportInBrowser({

    String? sector,
    int? companyId,
    int? departmentId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,

  }){

    final url = Uri.parse(

      "${ApiConstant.baseUrl}/AuditRequest/audit-request-report",

    ).replace(

      queryParameters:{

        if(sector!=null)
          "sector":sector,

        if(companyId!=null)
          "companyId":companyId.toString(),

        if(departmentId!=null)
          "departmentId":departmentId.toString(),

        if(status!=null)
          "status":status,

        if(fromDate!=null)
          "fromDate":fromDate.toIso8601String(),

        if(toDate!=null)
          "toDate":toDate.toIso8601String(),

      },

    ).toString();

    html.window.open(url, "_blank");

  }

}
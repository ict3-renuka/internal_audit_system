import '../../models/audit_request_model.dart';

class AuditRequestApi {

  Future<void> addAuditRequest(
      AuditRequestModel auditRequest,
      ) async {

    print(auditRequest.toJson());

    await Future.delayed(
      const Duration(seconds: 1),
    );
  }

  Future<List<AuditRequestModel>> getAuditRequests() async {

    await Future.delayed(
      const Duration(seconds: 1),
    );

    return [

      AuditRequestModel(
        id: 1,
        meetingDate: "2026-05-01",
        description: "Financial Audit",
        preliminaryStartDate: "2026-05-10",
        auditFirmPersonId: 100,
        auditFirmPersonName: "John",
      ),

      AuditRequestModel(
        id: 2,
        meetingDate: "2026-05-02",
        description: "Inventory Audit",
        preliminaryStartDate: "2026-05-15",
        auditFirmPersonId: 101,
        auditFirmPersonName: "David",
      ),
    ];
  }
}
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
}
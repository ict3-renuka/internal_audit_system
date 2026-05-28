import 'package:flutter/material.dart';

import '../../../../data/models/audit_request_model.dart';
import '../../../../data/services/api_services/audit_request_api.dart';

class AuditRequestViewmodel extends ChangeNotifier {

  final AuditRequestApi auditRequestApi;

  AuditRequestViewmodel(this.auditRequestApi);

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController personIdController = TextEditingController();
  final TextEditingController personNameController = TextEditingController();

  DateTime? meetingDate;
  DateTime? preliminaryStartDate;

  bool isLoading = false;

  void setMeetingDate(DateTime date) {
    meetingDate = date;
    notifyListeners();
  }

  void setPreliminaryStartDate(DateTime date) {
    preliminaryStartDate = date;
    notifyListeners();
  }

  Future<void> addAuditRequest() async {

    if (meetingDate == null ||
        preliminaryStartDate == null ||
        descriptionController.text.trim().isEmpty ||
        personIdController.text.trim().isEmpty ||
        personNameController.text.trim().isEmpty) {

      return;
    }

    isLoading = true;
    notifyListeners();

    AuditRequestModel request = AuditRequestModel(

      meetingDate: meetingDate.toString(),
      description: descriptionController.text.trim(),
      preliminaryStartDate:
      preliminaryStartDate.toString(),
      auditFirmPersonId:
      int.parse(personIdController.text),
      auditFirmPersonName:
      personNameController.text.trim(),
    );

    await auditRequestApi.addAuditRequest(request);

    clearFields();

    isLoading = false;
    notifyListeners();
  }

  void clearFields() {

    descriptionController.clear();

    personIdController.clear();

    personNameController.clear();

    meetingDate = null;

    preliminaryStartDate = null;
  }
}
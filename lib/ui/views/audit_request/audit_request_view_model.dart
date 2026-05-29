import 'package:flutter/material.dart';

import '../../../../data/models/audit_request_model.dart';
import '../../../../data/services/api_services/audit_request_api.dart';

class AuditRequestViewmodel extends ChangeNotifier {

  final AuditRequestApi auditRequestApi;

  AuditRequestViewmodel(this.auditRequestApi);

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController personIdController = TextEditingController();
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  DateTime? meetingDate;
  DateTime? preliminaryStartDate;

  bool isLoading = false;
  bool isEditLoaded = false;

  List<AuditRequestModel> auditRequests = [];
  List<AuditRequestModel> filteredList = [];

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

      id: 1,
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

  Future<void> loadAuditRequests() async {

    isLoading = true;
    notifyListeners();

    auditRequests = await auditRequestApi.getAuditRequests();
    filteredList = auditRequests;
    isLoading = false;
    notifyListeners();
  }

  void search(String value) {

    filteredList = auditRequests.where((e) {
      return e.description
          .toLowerCase()
          .contains(value.toLowerCase());
    }).toList();

    notifyListeners();
  }

  void loadAuditRequest(AuditRequestModel request,) {

    if (isEditLoaded) return;

    descriptionController.text = request.description;
    personIdController.text = request.auditFirmPersonId.toString();
    personNameController.text = request.auditFirmPersonName;
    meetingDate = DateTime.parse(request.meetingDate);
    preliminaryStartDate = DateTime.parse(request.preliminaryStartDate);
    isEditLoaded = true;
    notifyListeners();
  }
}
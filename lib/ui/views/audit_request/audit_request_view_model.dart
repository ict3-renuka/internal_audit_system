import 'package:flutter/material.dart';

import '../../../../data/models/audit_request_model.dart';
import '../../../../data/services/api_services/audit_request_api.dart';

class AuditRequestViewmodel extends ChangeNotifier {

  final AuditRequestApi auditRequestApi;

  AuditRequestViewmodel(this.auditRequestApi);

  final TextEditingController departmentController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController personIdController = TextEditingController();
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  DateTime? meetingDate;
  DateTime? preliminaryStartDate;
  DateTime? infoReqDate;
  DateTime? infoSubmitDate;
  DateTime? fieldWorkStartDate;
  DateTime? fieldWorkEndDate;
  DateTime? exitMeetingDate;
  DateTime? managementDiscussionDate;
  DateTime? reportIssuedDate;
  DateTime? sharedToBoardDate;
  DateTime? auditCommitteeTableDate;

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

  void setInfoReqDate(DateTime date) {
    infoReqDate = date;
    notifyListeners();
  }

  void setInfoSubmitDate(DateTime date) {
    infoSubmitDate = date;
    notifyListeners();
  }

  void setFieldWorkStartDate(DateTime date) {
    fieldWorkStartDate = date;
    notifyListeners();
  }

  void setFieldWorkEndDate(DateTime date) {
    fieldWorkEndDate = date;
    notifyListeners();
  }

  void setExitMeetingDate(DateTime date) {
    exitMeetingDate = date;
    notifyListeners();
  }

  void setManagementDiscussionDate(DateTime date) {
    managementDiscussionDate = date;
    notifyListeners();
  }

  void setReportIssuedDate(DateTime date) {
    reportIssuedDate = date;
    notifyListeners();
  }

  void setSharedToBoardDate(DateTime date) {
    sharedToBoardDate = date;
    notifyListeners();
  }

  void setAuditCommitteeTableDate(DateTime date) {
    auditCommitteeTableDate = date;
    notifyListeners();
  }

  Future<void> addAuditRequest() async {

    if (meetingDate == null ||
        preliminaryStartDate == null ||
        descriptionController.text.trim().isEmpty ||
        personIdController.text.trim().isEmpty ||
        personNameController.text.trim().isEmpty ||
        departmentController.text.trim().isEmpty) {

      return;
    }

    isLoading = true;
    notifyListeners();

    AuditRequestModel request = AuditRequestModel(
      meetingDate: meetingDate.toString(),
      description: descriptionController.text,
      preliminaryStartDate: preliminaryStartDate.toString(),
      auditFirmPersonId: personIdController.text,
      auditFirmPersonName: personNameController.text,
      auditDepartment: departmentController.text
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
    infoReqDate = null;
    infoSubmitDate = null;
    fieldWorkStartDate = null;
    exitMeetingDate = null;
    managementDiscussionDate = null;
    reportIssuedDate = null;
    sharedToBoardDate = null;
    auditCommitteeTableDate = null;
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

  void loadAuditRequest(AuditRequestModel request) {
    descriptionController.text = request.description;
    personIdController.text = request.auditFirmPersonId.toString();
    personNameController.text = request.auditFirmPersonName;
    meetingDate = DateTime.parse(request.meetingDate);
    preliminaryStartDate = DateTime.parse(request.preliminaryStartDate);
    departmentController.text = request.auditDepartment;

    notifyListeners();
  }
}
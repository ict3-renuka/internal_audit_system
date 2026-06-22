import 'package:flutter/material.dart';
import 'package:project_one/data/services/api_services/department_api.dart';

import '../../../../data/models/audit_request_model.dart';
import '../../../../data/services/api_services/audit_request_api.dart';
import '../../../core/constant/utils.dart';
import '../../../data/models/department_model.dart';

class AuditRequestViewmodel extends ChangeNotifier {

  final AuditRequestApi auditRequestApi;
  final DepartmentApi departmentApi = DepartmentApi();

  AuditRequestViewmodel(this.auditRequestApi);

  final TextEditingController descriptionController = TextEditingController();
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

  String? selectedAuditFirm;

  bool isLoading = false;

  List<AuditRequestModel> auditRequests = [];
  List<AuditRequestModel> filteredList = [];

  DepartmentModel? selectedDepartment;
  List<DepartmentModel> departmentList = [];

  final List<String> auditFirms = ["KPMG", "EY", "Deloitte"];

  int currentPage = 1;
  int totalPages = 1;
  int totalCount = 0;
  final int pageSize = 20;

  int? _pendingDepartmentId;

  Future<void> loadDepartmentData() async {
    isLoading = true;
    departmentList = [];
    notifyListeners();

    departmentList = await departmentApi.getDepartment();

    if (_pendingDepartmentId != null) {
      selectedDepartment = departmentList.firstWhere(
            (d) => d.departmentId == _pendingDepartmentId,
        orElse: () => departmentList.first,
      );
      _pendingDepartmentId = null;
    }

    isLoading = false;
    notifyListeners();
  }

  void setDepartment(DepartmentModel? value) {
    selectedDepartment = value;
    notifyListeners();
  }

  void setAuditFirm(String? value) {
    selectedAuditFirm = value;
    notifyListeners();
  }

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

  Future<bool> addAuditRequest(BuildContext context) async {
    if (meetingDate == null ||
        preliminaryStartDate == null ||
        descriptionController.text.trim().isEmpty ||
        personNameController.text.trim().isEmpty ||
        selectedDepartment == null ||
        selectedAuditFirm == null) {
      AppSnackBar.error(
        context,
        "Please add at least a Meeting Details section.",
      );
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final request = AuditRequestModel(
        meetingDate: meetingDate!,
        description: descriptionController.text.trim(),
        auditFirm: selectedAuditFirm!,
        auditFirmPersonName: personNameController.text.trim(),
        auditDepartmentId: selectedDepartment!.departmentId!,
        preliminaryStartDate: preliminaryStartDate,
        infoRequestDate: infoReqDate,
        infoSubmitDate: infoSubmitDate,
        fieldWorkStartDate: fieldWorkStartDate,
        fieldWorkEndDate: fieldWorkEndDate,
        exitMeetingDate: exitMeetingDate,
        managementDiscussionDate: managementDiscussionDate,
        reportIssuedDate: reportIssuedDate,
        sharedToBoardDate: sharedToBoardDate,
        auditCommitteeTableDate: auditCommitteeTableDate,
      );

      await auditRequestApi.addAuditRequest(request);

      clearFields();

      AppSnackBar.success(
        context,
        "Audit Request added successfully.",
      );
      return true;
    } catch (e) {
      AppSnackBar.error(
        context,
        "Failed to add Audit Request: ${e.toString()}",
      );
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAuditRequest(BuildContext context, int requestId) async {
    isLoading = true;
    notifyListeners();

    try {
      final request = AuditRequestModel(
        requestId: requestId,
        meetingDate: meetingDate!,
        description: descriptionController.text,
        preliminaryStartDate: preliminaryStartDate,
        auditFirm: selectedAuditFirm ?? "",
        auditFirmPersonName: personNameController.text,
        auditDepartmentId: selectedDepartment!.departmentId!,
        infoRequestDate: infoReqDate,
        infoSubmitDate: infoSubmitDate,
        fieldWorkStartDate: fieldWorkStartDate,
        fieldWorkEndDate: fieldWorkEndDate,
        exitMeetingDate: exitMeetingDate,
        managementDiscussionDate: managementDiscussionDate,
        reportIssuedDate: reportIssuedDate,
        sharedToBoardDate: sharedToBoardDate,
        auditCommitteeTableDate: auditCommitteeTableDate,
      );

      await auditRequestApi.updateAuditRequest(requestId, request);
      clearFields();

      AppSnackBar.success(context, "Audit Request updated successfully.");
      return true;
    } catch (e) {
      AppSnackBar.error(context, "Failed to update: ${e.toString()}");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearFields() {
    descriptionController.clear();
    personNameController.clear();
    selectedAuditFirm = null;
    selectedDepartment = null;
    meetingDate = null;
    preliminaryStartDate = null;
    infoReqDate = null;
    infoSubmitDate = null;
    fieldWorkStartDate = null;
    fieldWorkEndDate = null;
    exitMeetingDate = null;
    managementDiscussionDate = null;
    reportIssuedDate = null;
    sharedToBoardDate = null;
    auditCommitteeTableDate = null;
  }

  Future<void> loadAuditRequests({int page = 1}) async {
    isLoading = true;
    currentPage = page;
    notifyListeners();

    final result = await auditRequestApi.getAllAuditRequests(page: page, pageSize: pageSize);
    auditRequests = result.data;
    filteredList = result.data;
    totalPages = result.totalPages;
    totalCount = result.totalCount;

    isLoading = false;
    notifyListeners();
  }

  void search(String value) {
    filteredList = auditRequests.where((e) {
      return e.description.toLowerCase().contains(value.toLowerCase());
    }).toList();
    notifyListeners();
  }

  void loadAuditRequest(AuditRequestModel request) {
    descriptionController.text = request.description;
    personNameController.text = request.auditFirmPersonName;
    meetingDate = request.meetingDate;
    selectedAuditFirm = request.auditFirm;
    preliminaryStartDate = request.preliminaryStartDate;
    infoReqDate = request.infoRequestDate;
    infoSubmitDate = request.infoSubmitDate;
    fieldWorkStartDate = request.fieldWorkStartDate;
    fieldWorkEndDate = request.fieldWorkEndDate;
    exitMeetingDate = request.exitMeetingDate;
    managementDiscussionDate = request.managementDiscussionDate;
    reportIssuedDate = request.reportIssuedDate;
    sharedToBoardDate = request.sharedToBoardDate;
    auditCommitteeTableDate = request.auditCommitteeTableDate;

    _pendingDepartmentId = request.auditDepartmentId;
    selectedDepartment = null;

    notifyListeners();
  }

  String getDepartmentName(int id) {
    return departmentList
        .firstWhere(
          (e) => e.departmentId == id,
      orElse: () => DepartmentModel(
          companyId: 0,
          departmentId: 1,
          departmentName: ""
      ),
    )
        .departmentName;
  }
}
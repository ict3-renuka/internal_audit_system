import 'package:flutter/material.dart';
import 'package:project_one/data/models/company_model.dart';
import 'package:project_one/data/services/api_services/company_api.dart';
import 'package:project_one/data/services/api_services/department_api.dart';

import '../../../../data/models/audit_request_model.dart';
import '../../../../data/services/api_services/audit_request_api.dart';
import '../../../core/constant/utils.dart';
import '../../../data/models/department_model.dart';

class AuditRequestViewmodel extends ChangeNotifier {

  final AuditRequestApi auditRequestApi;
  final DepartmentApi departmentApi = DepartmentApi();
  final CompanyApi companyApi = CompanyApi();

  AuditRequestViewmodel(this.auditRequestApi);

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController reviewReferenceController = TextEditingController();

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
  DateTime? managementResponseReceivedDate;
  DateTime? draftReportReceivedDate;
  DateTime? draftReportCirculateDate;
  String? selectedSector;
  String? selectedAuditFirm;

  bool isLoading = false;

  List<AuditRequestModel> auditRequests = [];
  List<AuditRequestModel> filteredList = [];

  DepartmentModel? selectedDepartment;
  CompanyModel? selectedCompany;
  List<DepartmentModel> departmentList = [];
  List<CompanyModel> companyList = [];
  List<CompanyModel> filteredCompanyList = [];
  List<DepartmentModel> filteredDepartmentList = [];

  final List<String> auditFirms = ["KPMG", "EY", "Deloitte"];
  final List<String> sectors = ["Agri", "FMCG",];

  int currentPage = 1;
  int totalPages = 1;
  int totalCount = 0;
  final int pageSize = 20;

  int? _pendingDepartmentId;
  int? _pendingCompanyId;

  Future<void> loadDepartmentData() async {
    isLoading = true;
    departmentList = [];
    companyList = [];
    notifyListeners();

    departmentList = await departmentApi.getDepartment();
    companyList = await companyApi.getCompanyList();

    if (_pendingDepartmentId != null) {
      selectedDepartment = departmentList.firstWhere(
            (d) => d.departmentId == _pendingDepartmentId,
        orElse: () => departmentList.first,
      );
      _pendingDepartmentId = null;
    }

    if (_pendingCompanyId != null) {
      selectedCompany = companyList.firstWhere(
            (c) => c.companyId == _pendingCompanyId,
        orElse: () => companyList.first,
      );
      _pendingCompanyId = null;
    }

    isLoading = false;
    notifyListeners();
  }

  bool get isCompanyEnabled => selectedSector != null;
  bool get isDepartmentEnabled => selectedCompany != null;

  void setSector(String? value) {
    selectedSector = value;

    selectedCompany = null;
    selectedDepartment = null;
    filteredDepartmentList = [];
    filteredCompanyList = [];

    if (value != null) {
      filteredCompanyList = companyList
          .where((c) => c.sectorName.toString() == value)
          .toList();
    }

    notifyListeners();
  }

  void setDepartment(DepartmentModel? value) {
    selectedDepartment = value;
    notifyListeners();
  }

  void setCompany(CompanyModel? value) {
    selectedCompany = value;

    selectedDepartment = null;
    filteredDepartmentList = [];

    if (value?.companyId != null) {
      filteredDepartmentList = departmentList
          .where((d) => d.companyId == value!.companyId)
          .toList();
    }
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

  void setManagementResponseReceivedDate(DateTime date) {
    managementResponseReceivedDate = date;
    notifyListeners();
  }

  void setDraftReportReceivedDate(DateTime date) {
    draftReportReceivedDate = date;
    notifyListeners();
  }

  void setDraftReportCirculateDate(DateTime date) {
    draftReportCirculateDate = date;
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
        selectedAuditFirm == null ||
        reviewReferenceController.text.trim().isEmpty ||
        selectedSector == null ||
        selectedCompany == null) {
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
        auditName: descriptionController.text.trim(),
        auditFirm: selectedAuditFirm!,
        auditManager: personNameController.text.trim(),
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
        managementResponseReceivedDate: managementResponseReceivedDate,
        reviewReference: reviewReferenceController.text.trim(),
        draftReportReceivedDate: draftReportReceivedDate,
        draftReportCirculateDate: draftReportCirculateDate,
        sector: selectedSector!,
        companyId: selectedCompany!.companyId!,
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
        auditName: descriptionController.text,
        preliminaryStartDate: preliminaryStartDate,
        auditFirm: selectedAuditFirm ?? "",
        auditManager: personNameController.text,
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
        managementResponseReceivedDate: managementResponseReceivedDate,
        reviewReference: reviewReferenceController.text,
        draftReportReceivedDate: draftReportReceivedDate,
        draftReportCirculateDate: draftReportCirculateDate,
        sector: selectedSector!,
          companyId: selectedCompany!.companyId!
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
    managementResponseReceivedDate = null;
    reviewReferenceController.clear();
    draftReportReceivedDate = null;
    draftReportCirculateDate = null;
    selectedSector = null;
    selectedCompany = null;
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
      return e.auditName.toLowerCase().contains(value.toLowerCase());
    }).toList();
    notifyListeners();
  }

  void loadAuditRequest(AuditRequestModel request) {
    descriptionController.text = request.auditName;
    personNameController.text = request.auditManager;
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
    managementResponseReceivedDate = request.managementResponseReceivedDate;
    reviewReferenceController.text = request.reviewReference;
    draftReportReceivedDate = request.draftReportReceivedDate;
    draftReportCirculateDate = request.draftReportCirculateDate;
    selectedSector = request.sector;

    _pendingDepartmentId = request.auditDepartmentId;
    _pendingCompanyId = request.companyId;
    selectedDepartment = null;
    selectedCompany = null;

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

  String getCompanyName(int id) {
    return companyList
        .firstWhere(
          (e) => e.companyId == id,
      orElse: () => CompanyModel(
          sectorId: 0,
          sectorName: "",
          companyId: 1,
          companyName: "",
      ),
    )
        .companyName;
  }
}
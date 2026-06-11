import 'package:flutter/material.dart';
import 'package:project_one/data/models/draft_observation_model.dart';
import 'package:project_one/data/services/api_services/draft_observation_api.dart';

import '../../../data/models/combined_observation_model.dart';
import '../../../data/models/department_model.dart';
import '../../../data/models/internal_department_model.dart';
import '../../../data/models/observation_details_model.dart';
import '../../../data/models/responsible_user_row_model.dart';
import '../../../data/services/api_services/combined_observation_api.dart';
import '../../../data/services/api_services/department_api.dart';
import '../../../data/services/api_services/internal_department_api.dart';
import '../../../data/services/api_services/observation_details_api.dart';
import '../../../data/services/api_services/user_api.dart';
import '../../../data/services/session_service.dart';

class DraftObservationViewmodel extends ChangeNotifier {

  final DraftObservationApi draftObservationApi;
  final ObservationDetailsApi observationDetailsApi = ObservationDetailsApi();
  final CombinedObservationApi combinedApi = CombinedObservationApi();

  DraftObservationViewmodel(this.draftObservationApi);

  final TextEditingController areaController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController riskAndRootCauseController = TextEditingController();
  final TextEditingController recommendationController = TextEditingController();
  final TextEditingController manageResponseController = TextEditingController();
  final TextEditingController correctiveActionPlanController = TextEditingController();
  final TextEditingController responsibleUserIdController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController internalDepartmentController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

  DateTime? remarkedDate;
  bool isLoading = false;
  bool isEditLoaded = false;

  List<DraftObservationModel> draftObservation = [];
  List<DraftObservationModel> filteredList = [];

  List<DepartmentModel> allDepartments = [];
  List<InternalDepartmentModel> allInternalDepartments = [];
  List<ResponsibleUserRowModel> responsibleUserRows = [ResponsibleUserRowModel()];

  String? observationErrorMessage;
  int? observationId;
  String? observationDetailsErrorMessage;
  DateTime? actionTimeline;

  List<CombinedObservationModel> combinedList = [];
  List<CombinedObservationModel> filteredCombinedList = [];
  int currentPage = 1;
  int totalPages = 1;
  int totalCount = 0;

  int? sessionInternalDepartmentId;
  String? sessionDesignation;

  bool isActionSaved = false;
  bool isResponseSaved = false;
  bool isFollowUpSaved = false;

  Future<void> initView({CombinedObservationModel? combined, DraftObservationModel? draftObservation,}) async {
    resetAll();
    await loadSessionUser();
    await loadDropdownData();

    if (combined != null) {
      loadFromCombined(combined);
    } else if (draftObservation != null) {
      loadDraftObservation(draftObservation);
    }

    if (isActionFieldsFilled) isActionSaved = true;
    if (isResponseFieldsFilled) isResponseSaved = true;
    if (isFollowUpFieldsFilled) isFollowUpSaved = true;

    notifyListeners();
  }

  Future<void> loadSessionUser() async {
    final user = await SessionService.getUser();
    sessionInternalDepartmentId = user?.internalDepartmentId;
    sessionDesignation = user?.designation;
    notifyListeners();
  }

  bool get canEditActionFields {
    if (sessionInternalDepartmentId == null) return false;
    return responsibleUserRows.any(
          (r) =>
      r.isSaved &&
          (r.selectedInternalDepartment?.internalDepartmentId ==
              sessionInternalDepartmentId ||
              r.loadedInternalDepartmentId == sessionInternalDepartmentId),
    );
  }

  bool get canEditFollowUpFields =>
      sessionDesignation?.toLowerCase() == 'admin';

  bool get isActionFieldsFilled =>
      correctiveActionPlanController.text.trim().isNotEmpty &&
          actionTimeline != null;

  bool get isResponseFieldsFilled => manageResponseController.text.trim().isNotEmpty;

  bool get isFollowUpFieldsFilled =>
      statusController.text.trim().isNotEmpty &&
          remarkController.text.trim().isNotEmpty &&
          remarkedDate != null;

  // bool get allRowsSaved =>
  //     responsibleUserRows.isNotEmpty &&
  //         responsibleUserRows.every((r) => r.isSaved);

  void setActionTimeline(DateTime date) {
    actionTimeline = date;
    notifyListeners();
  }

  Future<void> loadDropdownData() async {
    allDepartments = await DepartmentApi().getDepartment();
    allInternalDepartments = await InternalDepartmentApi().getInternalDepartment();
    notifyListeners();
  }

  void addResponsibleUserRow() {
    responsibleUserRows.add(ResponsibleUserRowModel());
    notifyListeners();
  }

  void removeResponsibleUserRow(int index) {
    if (responsibleUserRows.length > 1) responsibleUserRows.removeAt(index);
    notifyListeners();
  }

  void onDepartmentSelected(int rowIndex, DepartmentModel? dept) {
    if (dept == null) return;
    final filtered = allInternalDepartments
        .where((id) => id.departmentId == dept.departmentId)
        .toList();
    responsibleUserRows[rowIndex] = responsibleUserRows[rowIndex].copyWith(
      selectedDepartment: dept,
      filteredInternalDepts: filtered,
      clearInternalDept: true,
      clearUser: true,
    );
    notifyListeners();
  }

  Future<void> onInternalDepartmentSelected(int rowIndex, InternalDepartmentModel? intDept) async {
    if (intDept == null) return;
    responsibleUserRows[rowIndex] = responsibleUserRows[rowIndex].copyWith(
      selectedInternalDepartment: intDept,
      isLoadingUser: true,
      clearUser: true,
    );
    notifyListeners();

    try {
      final users = await UserApi().getUsersByInternalDepartment(intDept.internalDepartmentId!);
      responsibleUserRows[rowIndex] = responsibleUserRows[rowIndex].copyWith(
        resolvedUser: users.isNotEmpty ? users.first : null,
        isLoadingUser: false,
      );
    } catch (e) {
      responsibleUserRows[rowIndex] = responsibleUserRows[rowIndex].copyWith(
        isLoadingUser: false,
        clearUser: true,
      );
    }

    notifyListeners();
  }

  void setRemarkedDate(DateTime date) {
    remarkedDate = date;
    notifyListeners();
  }

  Future<void> addDraftObservation() async {
    if (areaController.text.trim().isEmpty ||
        subjectController.text.trim().isEmpty ||
        detailsController.text.trim().isEmpty ||
        riskAndRootCauseController.text.trim().isEmpty ||
        recommendationController.text.trim().isEmpty) {
      observationErrorMessage = "All fields are required.";
      notifyListeners();
      return;
    }

    observationErrorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      final observation = DraftObservationModel(
        area: areaController.text.trim(),
        subject: subjectController.text.trim(),
        details: detailsController.text.trim(),
        riskAndRootCause: riskAndRootCauseController.text.trim(),
        recommendation: recommendationController.text.trim(),
      );

      final id = await draftObservationApi.addDraftObservation(observation);
      observationId = id;
    } catch (e) {
      print(e);
      observationErrorMessage = "Failed to save. Please try again.";
    }

    isLoading = false;
    notifyListeners();
  }

  void resetAll() {
    areaController.clear();
    subjectController.clear();
    detailsController.clear();
    riskAndRootCauseController.clear();
    recommendationController.clear();
    manageResponseController.clear();
    correctiveActionPlanController.clear();
    statusController.clear();
    remarkController.clear();
    actionTimeline = null;
    remarkedDate = null;
    observationId = null;
    observationErrorMessage = null;
    observationDetailsErrorMessage = null;
    responsibleUserRows = [ResponsibleUserRowModel()];
    isActionSaved = false;
    isResponseSaved = false;
    isFollowUpSaved = false;
    notifyListeners();
  }

  Future<void> addObservationDetails() async {
    if (observationId == null) {
      observationDetailsErrorMessage = "Save observation details first.";
      notifyListeners();
      return;
    }

    final unsavedRows = responsibleUserRows.where((r) => !r.isSaved).toList();

    if (unsavedRows.isEmpty) {
      observationDetailsErrorMessage = "No new rows to save.";
      notifyListeners();
      return;
    }

    final invalidRows = unsavedRows.where(
          (r) =>
      r.selectedDepartment == null ||
          r.selectedInternalDepartment == null ||
          r.resolvedUser == null,
    ).toList();

    if (invalidRows.isNotEmpty) {
      observationDetailsErrorMessage =
      "All rows must have a department, internal department, and responsible user.";
      notifyListeners();
      return;
    }

    observationDetailsErrorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      for (int i = 0; i < responsibleUserRows.length; i++) {
        final row = responsibleUserRows[i];
        if (row.isSaved) continue;

        final model = ObservationDetailsModel(
          observationId: observationId!,
          departmentId: row.selectedDepartment!.departmentId!,
          internalDepartmentId: row.selectedInternalDepartment!.internalDepartmentId!,
          responsibleUser: row.resolvedUser!.userName,
        );

        final detailsId = await observationDetailsApi.addObservationDetails(model);

        responsibleUserRows[i] =
            row.copyWith(observationDetailsId: detailsId,
              loadedInternalDepartmentId: row.selectedInternalDepartment!.internalDepartmentId,
            );
      }
    } catch (e) {
      observationDetailsErrorMessage = "Failed to save. Please try again.";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateObservationDetails({String section = ''}) async {
    final savedRows = responsibleUserRows.where((r) => r.isSaved).toList();

    if (savedRows.isEmpty) {
      observationDetailsErrorMessage =
      "No saved rows to update. Add responsible users first.";
      notifyListeners();
      return;
    }

    observationDetailsErrorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      final fields = <String, dynamic>{};

      if(section == 'action' && (correctiveActionPlanController.text.trim().isEmpty ||
          actionTimeline == null)) {
        observationDetailsErrorMessage =
        "Corrective Action Plan & Action Timeline Fields are Required.";
        isLoading = false;
        notifyListeners();
        return;
      }

      if(section == 'response' && manageResponseController.text.trim().isEmpty) {
        observationDetailsErrorMessage =
        "Management Response Field is Required.";
        isLoading = false;
        notifyListeners();
        return;
      }

      if(section == 'followup' && (statusController.text.trim().isEmpty ||
          remarkController.text.trim().isEmpty ||
          remarkedDate == null)) {
        observationDetailsErrorMessage =
        "Status, Remark & Remarked Date Fields are Required.";
        isLoading = false;
        notifyListeners();
        return;
      }

      if (actionTimeline != null) {
        fields['action_time_line'] = actionTimeline!.toIso8601String().split('T').first;
      }
      if (correctiveActionPlanController.text.trim().isNotEmpty) {
        fields['corrective_action_plan'] =
            correctiveActionPlanController.text.trim();
      }
      if (manageResponseController.text.trim().isNotEmpty) {
        fields['management_response'] = manageResponseController.text.trim();
      }
      if (statusController.text.trim().isNotEmpty) {
        fields['status'] = statusController.text.trim();
      }
      if (remarkController.text.trim().isNotEmpty) {
        fields['remark'] = remarkController.text.trim();
      }
      if (remarkedDate != null) {
        fields['remarked_date'] =
            remarkedDate!.toIso8601String().split('T').first;
      }

      for (final row in savedRows) {
        await observationDetailsApi.updateObservationDetails(
          row.observationDetailsId!,
          fields,
        );
        if (section == 'action') isActionSaved = true;
        if (section == 'response') isResponseSaved = true;
        if (section == 'followup') isFollowUpSaved = true;
      }
    } catch (e) {
      observationDetailsErrorMessage = "Failed to update. Please try again.";
    }

    isLoading = false;
    notifyListeners();
  }

  void resetSavedFlags() {
    isActionSaved = false;
    isResponseSaved = false;
    isFollowUpSaved = false;
    notifyListeners();
  }

  void loadDraftObservation(DraftObservationModel observation) {
    areaController.text = observation.area;
    subjectController.text = observation.subject;
    detailsController.text = observation.details;
    riskAndRootCauseController.text = observation.riskAndRootCause;
    recommendationController.text = observation.recommendation;

    if (observation.observationId != null) {
      observationId = observation.observationId;
    }

    resetSavedFlags();
    notifyListeners();
  }

  Future<void> loadCombinedObservations({int page = 1}) async {
    isLoading = true;
    currentPage = page;
    notifyListeners();

    try {
      final result = await combinedApi.getCombined(page: page);
      combinedList = result.items;
      filteredCombinedList = result.items;
      totalPages = result.totalPages;
      totalCount = result.totalCount;
    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void searchCombined(String value) {
    filteredCombinedList = combinedList.where((e) {
      final q = value.toLowerCase();
      return e.area.toLowerCase().contains(q) ||
          e.subject.toLowerCase().contains(q) ||
          e.details.toLowerCase().contains(q);
    }).toList();
    notifyListeners();
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    loadCombinedObservations(page: page);
  }

  void loadFromCombined(CombinedObservationModel combined) {
    areaController.text = combined.area;
    subjectController.text = combined.subject;
    detailsController.text = combined.details;
    riskAndRootCauseController.text = combined.riskAndRootCause;
    recommendationController.text = combined.recommendation;
    observationId = combined.observationId;

    if (combined.observationDetailsId != null) {
      manageResponseController.text = combined.managementResponse ?? '';
      correctiveActionPlanController.text = combined.correctiveActionPlan ?? '';
      actionTimeline = combined.actionTimeLine;
      statusController.text = combined.status ?? '';
      remarkController.text = combined.remark ?? '';
      remarkedDate = combined.remarkedDate;

      responsibleUserRows = [
        ResponsibleUserRowModel(
          observationDetailsId: combined.observationDetailsId,
          resolvedUserName: combined.responsibleUser,
          departmentName: combined.departmentName,
          internalDepartmentName: combined.internalDepartmentName,
          loadedInternalDepartmentId: combined.internalDepartmentId,
        ),
      ];
    }else {
      responsibleUserRows = [ResponsibleUserRowModel()];
    }

    resetSavedFlags();
    notifyListeners();
  }
}
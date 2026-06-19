import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
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
import '../../../data/services/api_services/observation_attachment_api.dart';
import '../../../data/services/api_services/observation_details_api.dart';
import '../../../data/services/api_services/user_api.dart';
import '../../../data/services/session_service.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js_interop';
import 'package:web/web.dart' as html;

class DraftObservationViewmodel extends ChangeNotifier {

  final DraftObservationApi draftObservationApi;
  final ObservationDetailsApi observationDetailsApi = ObservationDetailsApi();
  final CombinedObservationApi combinedApi = CombinedObservationApi();
  final ObservationAttachmentApi observationAttachmentApi = ObservationAttachmentApi();

  DraftObservationViewmodel(this.draftObservationApi);

  final TextEditingController reviewReferenceController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController riskAndRootCauseController = TextEditingController();
  final TextEditingController recommendationController = TextEditingController();
  final TextEditingController manageResponseController = TextEditingController();
  final TextEditingController correctiveActionPlanController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

  String? selectedStatus;
  final List<String> statusList = ["Open", "Close"];

  DateTime? remarkedDate;
  bool isLoading = false;

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

  Set<int> savedInternalDepartmentIds = {};

  bool includeInactive = false;

  int? existingAttachmentId;
  String? existingFileName;

  Uint8List? newPdfBytes;
  String? newPdfName;

  Future<void> initView({CombinedObservationModel? combined}) async {
    resetAll();
    await loadSessionUser();
    await loadDropdownData();

    if (combined != null) {
      loadFromCombined(combined);
      await loadAllResponsibleRows(combined.observationId);
    }

    if (isActionFieldsFilled) isActionSaved = true;
    if (isResponseFieldsFilled) isResponseSaved = true;
    if (isFollowUpFieldsFilled) isFollowUpSaved = true;

    notifyListeners();
  }

  void setStatus(String? value) {
    selectedStatus = value;
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
          selectedStatus != null  &&
          remarkController.text.trim().isNotEmpty &&
          remarkedDate != null;

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

  Future<void> loadAllResponsibleRows(int observationId) async {
    try {
      final ids = await observationDetailsApi.getSavedInternalDepartmentIds(observationId);
      savedInternalDepartmentIds = ids.toSet();
      notifyListeners();
    } catch (e) {
      print("Failed to load saved internal dept ids: $e");
    }
  }

  Future<void> addDraftObservation() async {
    if (reviewReferenceController.text.trim().isEmpty ||
        areaController.text.trim().isEmpty ||
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
        observationId: observationId,
        reviewReference: reviewReferenceController.text.trim(),
        area: areaController.text.trim(),
        subject: subjectController.text.trim(),
        details: detailsController.text.trim(),
        riskAndRootCause: riskAndRootCauseController.text.trim(),
        recommendation: recommendationController.text.trim(),
      );

      if (observationId == null) {
        final id = await draftObservationApi.addDraftObservation(observation);
        observationId = id;
      } else {
        await draftObservationApi.updateDraftObservation(observationId!, observation);
      }
      if (newPdfBytes != null && newPdfName != null) {
        final attachmentId = await observationAttachmentApi.uploadPdf(
          observationId: observationId!,
          bytes: newPdfBytes!,
          fileName: newPdfName!,
        );

        existingAttachmentId = attachmentId;
        existingFileName = newPdfName;

        newPdfBytes = null;
        newPdfName = null;
      }
    } catch (e) {
      print(e);
      observationErrorMessage = "Failed to save. Please try again.";
    }

    isLoading = false;
    notifyListeners();
  }

  void resetAll() {
    reviewReferenceController.clear();
    areaController.clear();
    subjectController.clear();
    detailsController.clear();
    riskAndRootCauseController.clear();
    recommendationController.clear();
    manageResponseController.clear();
    correctiveActionPlanController.clear();
    selectedStatus = null;
    remarkController.clear();
    actionTimeline = null;
    remarkedDate = null;
    observationId = null;
    observationErrorMessage = null;
    observationDetailsErrorMessage = null;
    responsibleUserRows = [ResponsibleUserRowModel()];
    savedInternalDepartmentIds = {};
    isActionSaved = false;
    isResponseSaved = false;
    isFollowUpSaved = false;
    includeInactive = false;
    newPdfBytes = null;
    newPdfName = null;
    existingAttachmentId = null;
    existingFileName = null;
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

    final duplicateRows = unsavedRows.where((r) =>
        savedInternalDepartmentIds.contains(
          r.selectedInternalDepartment?.internalDepartmentId,
        )).toList();

    if (duplicateRows.isNotEmpty) {
      final names = duplicateRows
          .map((r) => r.selectedInternalDepartment?.internalDepartmentName ?? '')
          .join(', ');
      observationDetailsErrorMessage =
      "Internal department '$names' is already assigned to this observation.";
      notifyListeners();
      return;
    }

    final unsavedIds = unsavedRows
        .map((r) => r.selectedInternalDepartment?.internalDepartmentId)
        .whereType<int>()
        .toList();

    final hasDuplicatesInNewRows = unsavedIds.length != unsavedIds.toSet().length;
    if (hasDuplicatesInNewRows) {
      observationDetailsErrorMessage =
      "You have duplicate internal departments in the new rows.";
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

        savedInternalDepartmentIds.add(
          row.selectedInternalDepartment!.internalDepartmentId!,
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

      if(section == 'followup' && ( selectedStatus == null ||
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
      if (selectedStatus != null) {
        fields['status'] = selectedStatus;
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

  Future<void> loadCombinedObservations({int page = 1}) async {
    isLoading = true;
    currentPage = page;
    notifyListeners();

    try {
      final result = await combinedApi.getCombined(page: page, includeInactive: includeInactive,);
      combinedList = result.items;
      searchCombined(searchController.text);
      totalPages = result.totalPages;
      totalCount = result.totalCount;
    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void searchCombined(String value) {
    final q = value.toLowerCase();
    filteredCombinedList = combinedList.where((e) {
      if (q.isEmpty) return true;

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
    reviewReferenceController.text = combined.reviewReference;
    areaController.text = combined.area;
    subjectController.text = combined.subject;
    detailsController.text = combined.details;
    riskAndRootCauseController.text = combined.riskAndRootCause;
    recommendationController.text = combined.recommendation;
    observationId = combined.observationId;
    existingAttachmentId = combined.attachmentId;
    existingFileName = combined.fileName;

    if (combined.observationDetailsId != null) {
      manageResponseController.text = combined.managementResponse ?? '';
      correctiveActionPlanController.text = combined.correctiveActionPlan ?? '';
      actionTimeline = combined.actionTimeLine;
      selectedStatus = combined.status;
      remarkController.text = combined.remark ?? '';
      remarkedDate = combined.remarkedDate;

      responsibleUserRows = [
        ResponsibleUserRowModel(
          observationDetailsId: combined.observationDetailsId,
          resolvedUserName: combined.responsibleUser,
          departmentName: combined.departmentName,
          internalDepartmentName: combined.internalDepartmentName,
          loadedInternalDepartmentId: combined.internalDepartmentId,
          isActive: combined.isActive ?? true,
        ),
      ];
    }else {
      responsibleUserRows = [ResponsibleUserRowModel()];
    }

    resetSavedFlags();
    notifyListeners();
  }

  List<ResponsibleUserRowModel> get visibleResponsibleUserRows {
    return responsibleUserRows;
  }

  void toggleIncludeInactive() {
    includeInactive = !includeInactive;
    loadCombinedObservations(page: 1);
  }

  Future<void> toggleRowIsActive(ResponsibleUserRowModel row, bool value) async{
    final index = responsibleUserRows.indexOf(row);
    if (index == -1) ;

    final oldValue = row.isActive;
    final newValue = value;

    responsibleUserRows[index] = row.copyWith(isActive: newValue);
    notifyListeners();

    try {
      await observationDetailsApi.updateObservationDetails(
        row.observationDetailsId!,
        {'is_active': newValue},
      );
    } catch (e) {
      responsibleUserRows[index] =
          row.copyWith(isActive: oldValue);

      observationDetailsErrorMessage = "Failed to update isActive field.";
      notifyListeners();
    }
  }

  Future<void> pickPdf() async {

    if (newPdfBytes != null || existingAttachmentId != null) {
      observationErrorMessage = "Only one file can be selected. Please remove the existing file first.";
      notifyListeners();
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    newPdfBytes = result.files.first.bytes;
    newPdfName = result.files.first.name;

    notifyListeners();
  }

  Future<void> removePdf() async {
    if (newPdfBytes != null) {

      newPdfBytes = null;
      newPdfName = null;

      notifyListeners();
      return;
    }

    if (existingAttachmentId != null) {

      await observationAttachmentApi.delete(existingAttachmentId!);

      existingAttachmentId = null;
      existingFileName = null;

      notifyListeners();
      return;
    }

    observationErrorMessage = "Please choose a file first.";
    notifyListeners();
  }

  Future<void> previewPdf() async {
    if (newPdfBytes != null) {

      if (kIsWeb) {
        final blob = html.Blob(
          <html.BlobPart>[newPdfBytes!.toJS].toJS,
          html.BlobPropertyBag(type: 'application/pdf'),
        );
        final url = html.URL.createObjectURL(blob);
        html.window.open(url, "_blank");

        Future.delayed(const Duration(minutes: 1), () {
          html.URL.revokeObjectURL(url);
        });
        return;
      }

      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/preview.pdf");
      await file.writeAsBytes(newPdfBytes!);

      await OpenFilex.open(file.path);
      return;
    }

    if (existingAttachmentId != null && observationId != null) {
      openPdf(observationId!);
      return;
    }

    if(!canEditFollowUpFields || isResponseFieldsFilled){
      observationErrorMessage="No File Chosen.";
    }else{
      observationErrorMessage = "Choose a file first.";
    }
    notifyListeners();
  }

  void openPdf(int id) {
    observationAttachmentApi.openPdfInBrowser(id);
  }

  bool get pdfRemovalNeedsConfirmation => existingAttachmentId != null;

  bool get isObservationLocked => isResponseFieldsFilled || !canEditFollowUpFields;

  bool get hasPdf => newPdfBytes != null || existingAttachmentId != null;

}
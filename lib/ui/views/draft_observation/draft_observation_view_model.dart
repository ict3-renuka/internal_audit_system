import 'package:flutter/material.dart';
import 'package:project_one/data/models/draft_observation_model.dart';
import 'package:project_one/data/services/api_services/draft_observation_api.dart';

import '../../../../data/models/audit_request_model.dart';
import '../../../../data/services/api_services/audit_request_api.dart';

class DraftObservationViewmodel extends ChangeNotifier {

  final DraftObservationApi draftObservationApi;

  DraftObservationViewmodel(this.draftObservationApi);

  final TextEditingController areaController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController riskAndRootCauseController = TextEditingController();
  final TextEditingController recommendationController = TextEditingController();
  final TextEditingController manageResponseController = TextEditingController();
  final TextEditingController correctiveActionPlanController = TextEditingController();
  final TextEditingController actionTimeLineController = TextEditingController();
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

  void setRemarkedDate(DateTime date) {
    remarkedDate = date;
    notifyListeners();
  }

  Future<void> addDraftObservation() async {

    if (remarkedDate == null ||
        areaController.text.trim().isEmpty ||
        subjectController.text.trim().isEmpty ||
        detailsController.text.trim().isEmpty ||
        riskAndRootCauseController.text.trim().isEmpty ||
        recommendationController.text.trim().isEmpty ||
        manageResponseController.text.trim().isEmpty ||
        correctiveActionPlanController.text.trim().isEmpty ||
        actionTimeLineController.text.trim().isEmpty ||
        responsibleUserIdController.text.trim().isEmpty ||
        statusController.text.trim().isEmpty ||
        remarkController.text.trim().isEmpty) {

      return;
    }

    isLoading = true;
    notifyListeners();

    DraftObservationModel observation = DraftObservationModel(
      area: areaController.text.trim(),
      subject: subjectController.toString(),
      details: detailsController.toString(),
      riskAndRootCause: riskAndRootCauseController.toString(),
      recommendation: recommendationController.toString(),
      department: departmentController.toString(),
      internalDepartment: internalDepartmentController.toString(),
      manageResponse: manageResponseController.toString(),
      correctiveActionPlan: correctiveActionPlanController.toString(),
      actionTimeLine: int.parse(actionTimeLineController.text),
      responsibleUserId: responsibleUserIdController.toString(),
      status: statusController.toString(),
      remark: remarkController.toString(),
      remarkedDate: remarkedDate.toString(),
    );

    await draftObservationApi.addDraftObservation(observation);

    clearFields();
    isLoading = false;
    notifyListeners();
  }

  void clearFields() {
    areaController.clear();
    subjectController.clear();
    detailsController.clear();
    riskAndRootCauseController.clear();
    recommendationController.clear();
    manageResponseController.clear();
    correctiveActionPlanController.clear();
    actionTimeLineController.clear();
    responsibleUserIdController.clear();
    statusController.clear();
    remarkController.clear();
    remarkedDate = null;
  }

  Future<void> loadAuditRequests() async {

    isLoading = true;
    notifyListeners();

    draftObservation = await draftObservationApi.getDraftObservation();
    filteredList = draftObservation;
    isLoading = false;
    notifyListeners();
  }

  void search(String value) {

    filteredList = draftObservation.where((e) {
      return e.details
          .toLowerCase()
          .contains(value.toLowerCase());
    }).toList();

    notifyListeners();
  }

  void loadDraftObservation(DraftObservationModel observation) {
    areaController.text = observation.area;
    subjectController.text = observation.subject;
    detailsController.text = observation.details;
    riskAndRootCauseController.text = observation.riskAndRootCause;
    recommendationController.text = observation.recommendation;
    manageResponseController.text = observation.manageResponse!;
    correctiveActionPlanController.text = observation.correctiveActionPlan!;
    actionTimeLineController.text = observation.actionTimeLine.toString();
    responsibleUserIdController.text = observation.responsibleUserId!;
    statusController.text = observation.status!;
    remarkController.text = observation.remark!;
    remarkedDate = DateTime.parse(observation.remarkedDate!);

    notifyListeners();
  }
}
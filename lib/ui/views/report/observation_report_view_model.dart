import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../data/models/department_model.dart';
import '../../../data/models/internal_department_model.dart';
import '../../../data/services/api_services/department_api.dart';
import '../../../data/services/api_services/internal_department_api.dart';
import '../../../data/services/api_services/observation_report_api.dart';

class ObservationReportViewModel extends ChangeNotifier {
  final ObservationReportApi reportApi = ObservationReportApi();

  List<DepartmentModel> departments = [];
  List<InternalDepartmentModel> internalDepartments = [];

  DepartmentModel? selectedDepartment;
  InternalDepartmentModel? selectedInternalDepartment;

  DateTime? fromDate;
  DateTime? toDate;

  bool isLoading = false;
  String? errorMessage;

  Uint8List? reportBytes;

  String? selectedStatus;
  final List<String> statusList = ["Open", "Close"];

  Future<void> init() async {
    departments = await DepartmentApi().getDepartment();
    internalDepartments = await InternalDepartmentApi().getInternalDepartment();
    notifyListeners();
  }

  void setStatus(String? value) {
    selectedStatus = value;
    notifyListeners();
  }

  void setDepartment(DepartmentModel? value) {
    selectedDepartment = value;
    notifyListeners();
  }

  void setInternalDepartment(InternalDepartmentModel? value) {
    selectedInternalDepartment = value;
    notifyListeners();
  }

  void setFromDate(DateTime date) {
    fromDate = date;
    notifyListeners();
  }

  void setToDate(DateTime date) {
    toDate = date;
    notifyListeners();
  }

  Future<void> generateReport() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // reportBytes = await reportApi.getReport(
      //   departmentId: selectedDepartment?.departmentId,
      //   internalDepartmentId: selectedInternalDepartment?.internalDepartmentId,
      //   fromDate: fromDate,
      //   toDate: toDate,
      // );
      //
      // reportApi.openPdfInBrowser(reportBytes!);

      reportApi.openReportInBrowser(
        departmentId: selectedDepartment?.departmentId,
        internalDepartmentId: selectedInternalDepartment?.internalDepartmentId,
        status: selectedStatus,
        fromDate: fromDate,
        toDate: toDate,
      );
    } catch (e) {
      errorMessage = "Failed to generate report";
    }

    isLoading = false;
    notifyListeners();
  }

  void clearFilters() {
    selectedDepartment = null;
    selectedInternalDepartment = null;
    selectedStatus = null;
    fromDate = null;
    toDate = null;
    errorMessage = null;

    notifyListeners();
  }
}
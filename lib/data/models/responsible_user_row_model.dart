import 'package:project_one/data/models/responsible_user_model.dart';

import 'department_model.dart';
import 'internal_department_model.dart';

class ResponsibleUserRowModel {
  DepartmentModel? selectedDepartment;
  InternalDepartmentModel? selectedInternalDepartment;
  ResponsibleUserModel? resolvedUser;
  List<InternalDepartmentModel> filteredInternalDepts;
  bool isLoadingUser;
  int? observationDetailsId;
  String? resolvedUserName;
  String? departmentName;
  String? internalDepartmentName;
  int? loadedInternalDepartmentId;

  ResponsibleUserRowModel({
    this.selectedDepartment,
    this.selectedInternalDepartment,
    this.resolvedUser,
    this.filteredInternalDepts = const [],
    this.isLoadingUser = false,
    this.observationDetailsId,
    this.resolvedUserName,
    this.departmentName,
    this.internalDepartmentName,
    this.loadedInternalDepartmentId,
  });

  bool get isSaved => observationDetailsId != null;

  String get displayUserName =>
      resolvedUser?.userName ?? resolvedUserName ?? '—';
  String get displayDepartmentName =>
      selectedDepartment?.departmentName ?? departmentName ?? '—';
  String get displayInternalDepartmentName =>
      selectedInternalDepartment?.internalDepartmentName ??
          internalDepartmentName ?? '—';

  ResponsibleUserRowModel copyWith({
    DepartmentModel? selectedDepartment,
    InternalDepartmentModel? selectedInternalDepartment,
    ResponsibleUserModel? resolvedUser,
    List<InternalDepartmentModel>? filteredInternalDepts,
    bool? isLoadingUser,
    bool clearUser = false,
    bool clearInternalDept = false,
    int? observationDetailsId,
    String? resolvedUserName,
    String? departmentName,
    String? internalDepartmentName,
    int? loadedInternalDepartmentId,
  }) {
    return ResponsibleUserRowModel(
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedInternalDepartment: clearInternalDept
          ? null
          : (selectedInternalDepartment ?? this.selectedInternalDepartment),
      resolvedUser: clearUser ? null : (resolvedUser ?? this.resolvedUser),
      filteredInternalDepts:
      filteredInternalDepts ?? this.filteredInternalDepts,
      isLoadingUser: isLoadingUser ?? this.isLoadingUser,
      observationDetailsId: observationDetailsId ?? this.observationDetailsId,
      resolvedUserName: resolvedUserName ?? this.resolvedUserName,
      departmentName: departmentName ?? this.departmentName,
      internalDepartmentName:
      internalDepartmentName ?? this.internalDepartmentName,
      loadedInternalDepartmentId:
      loadedInternalDepartmentId ?? this.loadedInternalDepartmentId,
    );
  }
}

import 'draft_observation_model.dart';

class CombinedObservationModel {
  final int auditRequestId;
  final int observationId;
  final String area;
  final String subject;
  final String details;
  final String riskAndRootCause;
  final String recommendation;
  final DateTime observationCreationDate;
  final int? observationDetailsId;
  final String? departmentName;
  final String? internalDepartmentName;
  final int? internalDepartmentId;
  final String? responsibleUser;
  final String? managementResponse;
  final String? correctiveActionPlan;
  final DateTime? actionTimeLine;
  final String? status;
  final String? remark;
  final DateTime? remarkedDate;
  final bool? isActive;
  final bool hasPdf;
  final int? attachmentId;
  final String? fileName;
  final String? amendmentManagementResponse;

  CombinedObservationModel({
    required this.auditRequestId,
    required this.observationId,
    required this.area,
    required this.subject,
    required this.details,
    required this.riskAndRootCause,
    required this.recommendation,
    required this.observationCreationDate,
    this.observationDetailsId,
    this.departmentName,
    this.internalDepartmentName,
    this.internalDepartmentId,
    this.responsibleUser,
    this.managementResponse,
    this.correctiveActionPlan,
    this.actionTimeLine,
    this.status,
    this.remark,
    this.remarkedDate,
    this.isActive,
    required this.hasPdf,
    this.attachmentId,
    this.fileName,
    this.amendmentManagementResponse,
  });

  factory CombinedObservationModel.fromJson(Map<String, dynamic> json) {
    return CombinedObservationModel(
      auditRequestId: json['auditRequestId'] ?? 0,
      observationId: json['observationId'] ?? 0,
      area: json['area'] ?? '',
      subject: json['subject'] ?? '',
      details: json['details'] ?? '',
      riskAndRootCause: json['riskAndRootCause'] ?? '',
      recommendation: json['recommendation'] ?? '',
      observationCreationDate: DateTime.parse(json['observationCreationDate']),
      observationDetailsId: json['observationDetailsId'] as int?,
      departmentName: json['departmentName'] as String?,
      internalDepartmentName: json['internalDepartmentName'] as String?,
      internalDepartmentId: json['internalDepartmentId'] as int?,
      responsibleUser: json['responsibleUser'] as String?,
      managementResponse: json['managementResponse'] as String?,
      correctiveActionPlan: json['correctiveActionPlan'] as String?,
      actionTimeLine: json['actionTimeLine'] != null
          ? DateTime.parse(json['actionTimeLine'])
          : null,
      status: json['status'] as String?,
      remark: json['remark'] as String?,
      remarkedDate: json['remarkedDate'] != null
          ? DateTime.parse(json['remarkedDate'])
          : null,
      isActive: json['isActive'] != null
          ? (json['isActive'] == true || json['isActive'] == 1)
          : null,
      hasPdf: json['hasPdf'] ?? false,
      attachmentId: json['attachmentId'] as int?,
      fileName: json['fileName'] as String?,
      amendmentManagementResponse: json['amendmentManagementResponse'] as String?,
    );
  }

  DraftObservationModel toDraftObservationModel() {
    return DraftObservationModel(
      auditRequestID: auditRequestId,
      observationId: observationId,
      area: area,
      subject: subject,
      details: details,
      riskAndRootCause: riskAndRootCause,
      recommendation: recommendation,
    );
  }
}

class PaginatedResult<T> {
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;
  final List<T> items;

  PaginatedResult({
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.items,
  });
}
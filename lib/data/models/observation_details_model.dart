class ObservationDetailsModel {
  final int? observationDetailsId;
  final int observationId;
  final int departmentId;
  final int internalDepartmentId;
  final String? responsibleUser;
  final String? managementResponse;
  final String? correctiveActionPlan;
  final DateTime? actionTimeLine;
  final String? status;
  final String? remark;
  final DateTime? remarkedDate;
  final DateTime? creationDate;
  final DateTime? lastModifiedDate;

  ObservationDetailsModel({
    this.observationDetailsId,
    required this.observationId,
    required this.departmentId,
    required this.internalDepartmentId,
    this.responsibleUser,
    this.managementResponse,
    this.correctiveActionPlan,
    this.actionTimeLine,
    this.status,
    this.remark,
    this.remarkedDate,
    this.creationDate,
    this.lastModifiedDate,
  });

  factory ObservationDetailsModel.fromJson(Map<String, dynamic> json) {
    return ObservationDetailsModel(
      observationDetailsId: json['observation_details_id'],
      observationId: json['observation_id'],
      departmentId: json['department_id'],
      internalDepartmentId: json['internal_department_id'],
      responsibleUser: json['responsible_user'],
      managementResponse: json['management_response'],
      correctiveActionPlan: json['corrective_action_plan'],
      actionTimeLine: json['action_time_line'] != null
          ? DateTime.parse(json['action_time_line'])
          : null,
      status: json['status'],
      remark: json['remark'],
      remarkedDate: json['remarked_date'] != null
          ? DateTime.parse(json['remarked_date'])
          : null,
      creationDate: json['creation_date'] != null
          ? DateTime.parse(json['creation_date'])
          : null,
      lastModifiedDate: json['last_modified_date'] != null
          ? DateTime.parse(json['last_modified_date'])
          : null,
    );
  }

  Map<String, dynamic> toAddJson() {
    return {
      'observation_id': observationId,
      'department_id': departmentId,
      'internal_department_id': internalDepartmentId,
      'responsible_user': responsibleUser,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      if (managementResponse != null) 'management_response': managementResponse,
      if (correctiveActionPlan != null) 'corrective_action_plan': correctiveActionPlan,
      if (actionTimeLine != null) 'action_time_line': actionTimeLine!.toIso8601String().split('T').first,
      if (status != null) 'status': status,
      if (remark != null) 'remark': remark,
      if (remarkedDate != null)
        'remarked_date': remarkedDate!.toIso8601String().split('T').first,
    };
  }
}
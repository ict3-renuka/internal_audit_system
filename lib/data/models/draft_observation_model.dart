class DraftObservationModel {

  final int? observationId;
  final String area;
  final String subject;
  final String details;
  final String riskAndRootCause;
  final String recommendation;
  final String department;
  final String internalDepartment;
  final String? manageResponse;
  final String? correctiveActionPlan;
  final int? actionTimeLine;
  final String? responsibleUserId;
  final String? status;
  final String? remark;
  final String? remarkedDate;

  DraftObservationModel({
    this.observationId,
    required this.area,
    required this.subject,
    required this.details,
    required this.riskAndRootCause,
    required this.recommendation,
    required this.department,
    required this.internalDepartment,
    this.manageResponse,
    this.correctiveActionPlan,
    this.actionTimeLine,
    this.responsibleUserId,
    this.status,
    this.remark,
    this.remarkedDate,
  });

  factory DraftObservationModel.fromJson(Map<String, dynamic> json) {
    return DraftObservationModel(
      observationId: json["observation_id"],
      area: json["area"],
      subject: json["subject"],
      details: json["details"],
      riskAndRootCause: json["risk_and_root_cause"],
      recommendation: json["recommendation"],
      department: json["department"],
      internalDepartment: json["internal_department"],
      manageResponse: json["manage_response"],
      correctiveActionPlan: json["corrective_action_plan"],
      actionTimeLine: json["action_time_line"],
      responsibleUserId: json["responsible_user_id"],
      status: json["status"],
      remark: json["remark"],
      remarkedDate: json["remarked_date"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "area": area,
      "subject": subject,
      "details": details,
      "risk_and_root_cause": riskAndRootCause,
      "recommendation": recommendation,
      "department": department,
      "internal_department": internalDepartment,
      "manage_response": manageResponse,
      "corrective_action_plan": correctiveActionPlan,
      "action_time_line": actionTimeLine,
      "responsible_user_id": responsibleUserId,
      "status": status,
      "remark": remark,
      "remarked_date": remarkedDate,
    };
  }
}
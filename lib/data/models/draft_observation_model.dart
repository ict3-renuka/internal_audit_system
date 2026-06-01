class DraftObservationModel {

  final int id;
  final String area;
  final String subject;
  final String details;
  final String riskAndRootCause;
  final String recommendation;
  final String manageResponse;
  final String correctiveActionPlan;
  final int actionTimeLine;
  final String responsibleUserId;
  final String status;
  final String remark;
  final String remarkedDate;

  DraftObservationModel({
    required this.id,
    required this.area,
    required this.subject,
    required this.details,
    required this.riskAndRootCause,
    required this.recommendation,
    required this.manageResponse,
    required this.correctiveActionPlan,
    required this.actionTimeLine,
    required this.responsibleUserId,
    required this.status,
    required this.remark,
    required this.remarkedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "area": area,
      "subject": subject,
      "details": details,
      "riskAndRootCause": riskAndRootCause,
      "recommendation": recommendation,
      "manageResponse": manageResponse,
      "correctiveActionPlan": correctiveActionPlan,
      "actionTimeLine": actionTimeLine,
      "responsibleUserId": responsibleUserId,
      "status": status,
      "remark": remark,
      "remarkedDate": remarkedDate,
    };
  }
}
class DraftObservationModel {

  final int? observationId;
  final String reviewReference;
  final String area;
  final String subject;
  final String details;
  final String riskAndRootCause;
  final String recommendation;

  DraftObservationModel({
    this.observationId,
    required this.reviewReference,
    required this.area,
    required this.subject,
    required this.details,
    required this.riskAndRootCause,
    required this.recommendation,
  });

  factory DraftObservationModel.fromJson(Map<String, dynamic> json) {
    return DraftObservationModel(
      observationId: json["observation_id"],
      reviewReference: json["review_reference"],
      area: json["area"],
      subject: json["subject"],
      details: json["details"],
      riskAndRootCause: json["risk_and_root_cause"],
      recommendation: json["recommendation"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "review_reference": reviewReference,
      "area": area,
      "subject": subject,
      "details": details,
      "risk_and_root_cause": riskAndRootCause,
      "recommendation": recommendation,
    };
  }
}
class AuditRequestModel {

  final String meetingDate;
  final String description;
  final String preliminaryStartDate;
  final int auditFirmPersonId;
  final String auditFirmPersonName;

  AuditRequestModel({
    required this.meetingDate,
    required this.description,
    required this.preliminaryStartDate,
    required this.auditFirmPersonId,
    required this.auditFirmPersonName,
  });

  Map<String, dynamic> toJson() {
    return {
      "meeting_date": meetingDate,
      "description": description,
      "preliminary_start_date": preliminaryStartDate,
      "audit_firm_person_id": auditFirmPersonId,
      "audit_firm_person_name": auditFirmPersonName,
    };
  }
}
class AuditRequestModel {

  final int? requestId;
  final String meetingDate;
  final String description;
  final String preliminaryStartDate;
  final String auditFirmPersonId;
  final String auditFirmPersonName;
  final String auditDepartment;
  final String? infoRequestDate;
  final String? infoSubmitDate;
  final String? fieldWorkStartDate;
  final String? fieldWorkEndDate;
  final String? exitMeetingDate;
  final String? managementDiscussionDate;
  final String? reportIssuedDate;
  final String? sharedToBoardDate;
  final String? auditCommitteeTableDate;

  AuditRequestModel({
    this.requestId,
    required this.meetingDate,
    required this.description,
    required this.preliminaryStartDate,
    required this.auditFirmPersonId,
    required this.auditFirmPersonName,
    required this.auditDepartment,
    this.infoRequestDate,
    this.infoSubmitDate,
    this.fieldWorkStartDate,
    this.fieldWorkEndDate,
    this.exitMeetingDate,
    this.managementDiscussionDate,
    this.reportIssuedDate,
    this.sharedToBoardDate,
    this.auditCommitteeTableDate
  });

  factory AuditRequestModel.fromJson(Map<String, dynamic> json) {
    return AuditRequestModel(
      requestId: json["request_id"],
      meetingDate: json["meeting_date"],
      description: json["description"],
      preliminaryStartDate: json["preliminary_start_date"],
      auditFirmPersonId: json["audit_firm_person_id"],
      auditFirmPersonName: json["audit_firm_person_name"],
      auditDepartment: json["audit_department"],
      infoRequestDate: json["info_request_date"],
      infoSubmitDate: json["info_submit_date"],
      fieldWorkStartDate: json["field_work_start_date"],
      fieldWorkEndDate: json["field_work_end_date"],
      exitMeetingDate: json["exit_meeting_date"],
      managementDiscussionDate: json["management_discussion_date"],
      reportIssuedDate: json["report_issued_date"],
      sharedToBoardDate: json["shared_to_board_date"],
      auditCommitteeTableDate: json["audit_committee_table_date"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "meeting_date": meetingDate,
      "description": description,
      "preliminary_start_date": preliminaryStartDate,
      "audit_firm_person_id": auditFirmPersonId,
      "audit_firm_person_name": auditFirmPersonName,
      "audit_department": auditDepartment,
      "info_request_date": infoRequestDate,
      "info_submit_date": infoSubmitDate,
      "field_work_start_date": fieldWorkStartDate,
      "field_work_end_date": fieldWorkEndDate,
      "exit_meeting_date": exitMeetingDate,
      "management_discussion_date": managementDiscussionDate,
      "report_issued_date": reportIssuedDate,
      "shared_to_board_date": sharedToBoardDate,
      "audit_committee_table_date": auditCommitteeTableDate
    };
  }
}
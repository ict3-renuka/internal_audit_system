class AuditRequestModel {
  final int? requestId;
  final DateTime meetingDate;
  final String description;
  final DateTime? preliminaryStartDate;
  final String auditFirm;
  final String auditFirmPersonName;
  final String auditDepartment;
  final DateTime? infoRequestDate;
  final DateTime? infoSubmitDate;
  final DateTime? fieldWorkStartDate;
  final DateTime? fieldWorkEndDate;
  final DateTime? exitMeetingDate;
  final DateTime? managementDiscussionDate;
  final DateTime? reportIssuedDate;
  final DateTime? sharedToBoardDate;
  final DateTime? auditCommitteeTableDate;

  AuditRequestModel({
    this.requestId,
    required this.meetingDate,
    required this.description,
    this.preliminaryStartDate,
    required this.auditFirm,
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
    this.auditCommitteeTableDate,
  });

  factory AuditRequestModel.fromJson(Map<String, dynamic> json) {
    return AuditRequestModel(
      requestId: json["request_id"],
      meetingDate: DateTime.parse(json["meeting_date"]),
      description: json["description"],
      preliminaryStartDate: json["preliminary_start_date"] == null
          ? null
          : DateTime.parse(json["preliminary_start_date"]),
      auditFirm: json["audit_firm"],
      auditFirmPersonName: json["audit_firm_person_name"],
      auditDepartment: json["audit_department"],
      infoRequestDate: json["info_request_date"] == null
          ? null
          : DateTime.parse(json["info_request_date"]),
      infoSubmitDate: json["info_submit_date"] == null
          ? null
          : DateTime.parse(json["info_submit_date"]),
      fieldWorkStartDate: json["field_work_start_date"] == null
          ? null
          : DateTime.parse(json["field_work_start_date"]),
      fieldWorkEndDate: json["field_work_end_date"] == null
          ? null
          : DateTime.parse(json["field_work_end_date"]),
      exitMeetingDate: json["exit_meeting_date"] == null
          ? null
          : DateTime.parse(json["exit_meeting_date"]),
      managementDiscussionDate: json["management_discussion_date"] == null
          ? null
          : DateTime.parse(json["management_discussion_date"]),
      reportIssuedDate: json["report_issued_date"] == null
          ? null
          : DateTime.parse(json["report_issued_date"]),
      sharedToBoardDate: json["shared_to_board_date"] == null
          ? null
          : DateTime.parse(json["shared_to_board_date"]),
      auditCommitteeTableDate: json["audit_committee_table_date"] == null
          ? null
          : DateTime.parse(json["audit_committee_table_date"]),
    );
  }

  Map<String, dynamic> toJson() {
    String? format(DateTime? d) =>
        d == null ? null : d.toIso8601String().split('T')[0];

    return {
      "meeting_date": format(meetingDate),
      "description": description,
      "preliminary_start_date": format(preliminaryStartDate),
      "audit_firm": auditFirm,
      "audit_firm_person_name": auditFirmPersonName,
      "audit_department": auditDepartment,
      "info_request_date": format(infoRequestDate),
      "info_submit_date": format(infoSubmitDate),
      "field_work_start_date": format(fieldWorkStartDate),
      "field_work_end_date": format(fieldWorkEndDate),
      "exit_meeting_date": format(exitMeetingDate),
      "management_discussion_date": format(managementDiscussionDate),
      "report_issued_date": format(reportIssuedDate),
      "shared_to_board_date": format(sharedToBoardDate),
      "audit_committee_table_date": format(auditCommitteeTableDate),
    };
  }
}
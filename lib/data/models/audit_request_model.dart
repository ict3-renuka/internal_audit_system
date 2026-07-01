class AuditRequestModel {
  final int? requestId;
  final DateTime meetingDate;
  final String auditName;
  final DateTime? preliminaryStartDate;
  final String auditFirm;
  final String auditManager;
  final int auditDepartmentId;
  final DateTime? infoRequestDate;
  final DateTime? infoSubmitDate;
  final DateTime? fieldWorkStartDate;
  final DateTime? fieldWorkEndDate;
  final DateTime? exitMeetingDate;
  final DateTime? managementDiscussionDate;
  final DateTime? reportIssuedDate;
  final DateTime? sharedToBoardDate;
  final DateTime? auditCommitteeTableDate;
  final String reviewReference;
  final String sector;
  final int companyId;
  final DateTime? managementResponseReceivedDate;
  final DateTime? draftReportReceivedDate;
  final DateTime? draftReportCirculateDate;

  AuditRequestModel({
    this.requestId,
    required this.meetingDate,
    required this.auditName,
    this.preliminaryStartDate,
    required this.auditFirm,
    required this.auditManager,
    required this.auditDepartmentId,
    this.infoRequestDate,
    this.infoSubmitDate,
    this.fieldWorkStartDate,
    this.fieldWorkEndDate,
    this.exitMeetingDate,
    this.managementDiscussionDate,
    this.reportIssuedDate,
    this.sharedToBoardDate,
    this.auditCommitteeTableDate,
    required this.reviewReference,
    required this.sector,
    required this.companyId,
    this.managementResponseReceivedDate,
    this.draftReportReceivedDate,
    this.draftReportCirculateDate
  });

  factory AuditRequestModel.fromJson(Map<String, dynamic> json) {
    return AuditRequestModel(
      requestId: json["request_id"],
      meetingDate: DateTime.parse(json["meeting_date"]),
      auditName: json["audit_name"],
      preliminaryStartDate: json["preliminary_start_date"] == null
          ? null
          : DateTime.parse(json["preliminary_start_date"]),
      auditFirm: json["audit_firm"],
      auditManager: json["audit_manager"],
      auditDepartmentId: json["audit_department_id"],
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
      reviewReference: json["review_reference"],
      sector: json["sector"],
      companyId: json["company_id"],
      managementResponseReceivedDate: json["management_response_received_date"] == null
          ? null
          : DateTime.parse(json["management_response_received_date"]),
      draftReportReceivedDate: json["draft_report_received_date"] == null
          ? null
          : DateTime.parse(json["draft_report_received_date"]),
      draftReportCirculateDate: json["draft_report_circulate_date"] == null
          ? null
          : DateTime.parse(json["draft_report_circulate_date"]),
    );
  }

  Map<String, dynamic> toJson() {
    String? format(DateTime? d) =>
        d == null ? null : d.toIso8601String().split('T')[0];

    return {
      "meeting_date": format(meetingDate),
      "audit_name": auditName,
      "preliminary_start_date": format(preliminaryStartDate),
      "audit_firm": auditFirm,
      "audit_manager": auditManager,
      "audit_department_id": auditDepartmentId,
      "info_request_date": format(infoRequestDate),
      "info_submit_date": format(infoSubmitDate),
      "field_work_start_date": format(fieldWorkStartDate),
      "field_work_end_date": format(fieldWorkEndDate),
      "exit_meeting_date": format(exitMeetingDate),
      "management_discussion_date": format(managementDiscussionDate),
      "report_issued_date": format(reportIssuedDate),
      "shared_to_board_date": format(sharedToBoardDate),
      "audit_committee_table_date": format(auditCommitteeTableDate),
      "review_reference": reviewReference,
      "sector": sector,
      "company_id": companyId,
      "management_response_received_date": format(managementResponseReceivedDate),
      "draft_report_received_date": format(draftReportReceivedDate),
      "draft_report_circulate_date": format(draftReportCirculateDate),
    };
  }
}
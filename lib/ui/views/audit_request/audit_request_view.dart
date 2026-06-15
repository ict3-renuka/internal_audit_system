import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/core/theme/app_text_style.dart';
import 'package:project_one/ui/widget/nav_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/models/audit_request_model.dart';
import '../../../data/models/department_model.dart';
import '../../widget/master_date_field_widget.dart';
import '../../widget/master_text_field_widget.dart';
import 'audit_request_view_model.dart';

class AuditRequestView extends StatefulWidget {
  final AuditRequestModel? auditRequest;
  const AuditRequestView({super.key,this.auditRequest,});

  @override
  State<AuditRequestView> createState() => _AuditRequestViewState();
}

class _AuditRequestViewState extends State<AuditRequestView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final vModel = Provider.of<AuditRequestViewmodel>(context, listen: false);
      if (widget.auditRequest != null) {
        vModel.loadAuditRequest(widget.auditRequest!,);
      } else {
        vModel.clearFields();
      }
      vModel.loadDepartmentData();
    });
  }

  bool get isEditMode => widget.auditRequest != null;

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<AuditRequestViewmodel>(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondBackground,
      appBar: AppNavBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: width * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode ? "Edit Audit Request" : "New Audit Request",
              style: AppTextStyles.title,
            ),
            const SizedBox(height: 8),
            Text(
                isEditMode
                    ? "Review and update the audit request details below."
                    :
                "Initialize a new audit engagement by providing meeting details and firm contact information.",
              style: AppTextStyles.paragraph
            ),
            // const SizedBox(height: 8),
            // Text("Once you submit the data by clicking the button, you will not be able to edit or delete it.",
            //   style: TextStyle(color: Colors.red,fontSize: 12),),
            SizedBox(height: width * 0.02 ),
            Container(
              padding: EdgeInsets.all(width * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.border,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Meeting Details",
                        style: AppTextStyles.subTitle
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Meeting Date",
                          value: vModel.meetingDate,
                          onSelect: /*(isEditMode && vModel.meetingDate != null) ? (_) {} :*/ vModel.setMeetingDate,
                          disableFutureDates: true,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Preliminary Start Date",
                          value: vModel.preliminaryStartDate,
                          onSelect: /*(isEditMode && vModel.preliminaryStartDate  != null) ? (_) {} :*/ vModel.setPreliminaryStartDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text("Select Department", style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<DepartmentModel>(
                              value: vModel.departmentList
                                  .where((d) => d.departmentId == vModel.selectedDepartment?.departmentId)
                                  .firstOrNull,
                              disabledHint: Text(vModel.selectedDepartment?.departmentName ?? ""),
                              items: vModel.departmentList.map((department) {
                                return DropdownMenuItem(
                                  value: department,
                                  child: Text(department.departmentName),
                                );
                              }).toList(),
                              onChanged: /*(isEditMode && vModel.selectedDepartment != null) ? null :*/ vModel.setDepartment,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.01),
                  MasterTextFieldWidget(
                    label: "Description",
                    hintText: "Enter detailed scope and context for this audit request...",
                    controller: vModel.descriptionController,
                    maxLines: 3,
                    maxLength: 600,
                    // readOnly: isEditMode && vModel.descriptionController.text.isNotEmpty,
                  ),
                  SizedBox(height: width * 0.005),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text("Audit Firm", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: vModel.selectedAuditFirm,
                              items: vModel.auditFirms
                                  .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s),
                              ))
                                  .toList(),
                              onChanged:/*(isEditMode && vModel.selectedAuditFirm != null) ? null :*/ vModel.setAuditFirm,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            MasterTextFieldWidget(
                              label: "Audit Firm Person Name",
                              hintText: "Enter DepartmentAudit Firm Person Name",
                              controller: vModel.personNameController,
                              // readOnly: isEditMode && vModel.personNameController.text.isNotEmpty,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: width * 0.02),
            Container(
              padding: EdgeInsets.all(width * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.border,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                          "Audit Schedule Details",
                          style: AppTextStyles.subTitle
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Info Request Date",
                          value: vModel.infoReqDate,
                          onSelect: /*(isEditMode && vModel.infoReqDate != null) ? (_) {} :*/ vModel.setInfoReqDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Information Submit Date",
                          value: vModel.infoSubmitDate,
                          onSelect: /*(isEditMode && vModel.infoSubmitDate != null) ? (_) {} :*/ vModel.setInfoSubmitDate,
                          disableFutureDates: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Field Work Start Date",
                          value: vModel.fieldWorkStartDate,
                          onSelect: /*(isEditMode && vModel.fieldWorkStartDate != null) ? (_) {} :*/ vModel.setFieldWorkStartDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Field Work End Date",
                          value: vModel.fieldWorkEndDate,
                          onSelect: /*(isEditMode && vModel.fieldWorkEndDate != null) ? (_) {} :*/ vModel.setFieldWorkEndDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Exit Meeting Date",
                          value: vModel.exitMeetingDate,
                          onSelect: /*(isEditMode && vModel.exitMeetingDate != null) ? (_) {} :*/ vModel.setExitMeetingDate,
                          disableFutureDates: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: width * 0.02),
            Container(
              padding: EdgeInsets.all(width * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.border,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                          "Management Discussion Details",
                          style: AppTextStyles.subTitle
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Management Discussion Date",
                          value: vModel.managementDiscussionDate,
                          onSelect: /*(isEditMode && vModel.managementDiscussionDate != null) ? (_) {} :*/ vModel.setManagementDiscussionDate,
                          disableFutureDates: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: width * 0.02),
            Container(
              padding: EdgeInsets.all(width * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.border,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                          "Management Report Details",
                          style: AppTextStyles.subTitle
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Report Issued Date",
                          value: vModel.reportIssuedDate,
                          onSelect: /*(isEditMode && vModel.reportIssuedDate != null) ? (_) {} :*/ vModel.setReportIssuedDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Shared to Board Date",
                          value: vModel.sharedToBoardDate,
                          onSelect: /*(isEditMode && vModel.sharedToBoardDate != null) ? (_) {} :*/ vModel.setSharedToBoardDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Audit Committee Table Date",
                          value: vModel.auditCommitteeTableDate,
                          onSelect: /*(isEditMode && vModel.auditCommitteeTableDate != null) ? (_) {} :*/ vModel.setAuditCommitteeTableDate,
                          disableFutureDates: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: vModel.isLoading
                          ? null
                          : () async {
                        if (isEditMode) {
                          final bool success = await vModel.updateAuditRequest(
                            context,
                            widget.auditRequest!.requestId!,
                          );
                          if (success && context.mounted) {
                            Navigator.pop(context, true);
                          }
                        } else {
                          final bool success = await vModel.addAuditRequest(context);
                          if (success && context.mounted) {
                            Navigator.pushReplacementNamed(context, "/edit-audit-request");
                          }
                        }
                      },
                      icon: vModel.isLoading
                          ? SizedBox(
                        width: width * 0.01,
                        height: width * 0.01,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        isEditMode ? "Update Audit Request" : "Add Audit Request",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding:
                        EdgeInsets.symmetric(
                          horizontal: width * 0.02,
                          vertical: width * 0.012,
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

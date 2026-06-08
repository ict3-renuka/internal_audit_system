import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/core/theme/app_text_style.dart';
import 'package:project_one/ui/widget/nav_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/models/audit_request_model.dart';
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
      if (widget.auditRequest != null) {
        Provider.of<AuditRequestViewmodel>(
          context,
          listen: false,
        ).loadAuditRequest(
          widget.auditRequest!,
        );
      }
    });
  }
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
              "New Audit Request",
              style: AppTextStyles.title,
            ),
            const SizedBox(height: 8),
            Text(
              "Initialize a new audit engagement by providing meeting details and firm contact information.",
              style: AppTextStyles.paragraph
            ),
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
                          onSelect: vModel.setMeetingDate,
                          disableFutureDates: true,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Preliminary Start Date",
                          value: vModel.preliminaryStartDate,
                          onSelect: vModel.setPreliminaryStartDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            MasterTextFieldWidget(
                              label: "Audit Department",
                              hintText: "Enter Department",
                              controller: vModel.departmentController,
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
                    maxLines: 2,
                    maxLength: 300,
                  ),
                  SizedBox(height: width * 0.005),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text("Audit Firm"),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: vModel.selectedAuditFirm,
                              items: vModel.auditFirms
                                  .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s),
                              ))
                                  .toList(),
                              onChanged: vModel.setAuditFirm,
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
                          onSelect: vModel.setInfoReqDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Information Submit Date",
                          value: vModel.infoSubmitDate,
                          onSelect: vModel.setInfoSubmitDate,
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
                          onSelect: vModel.setFieldWorkStartDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Field Work End Date",
                          value: vModel.fieldWorkEndDate,
                          onSelect: vModel.setFieldWorkEndDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Exit Meeting Date",
                          value: vModel.exitMeetingDate,
                          onSelect: vModel.setExitMeetingDate,
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
                          onSelect: vModel.setManagementDiscussionDate,
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
                          onSelect: vModel.setReportIssuedDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Shared to Board Date",
                          value: vModel.sharedToBoardDate,
                          onSelect: vModel.setSharedToBoardDate,
                          disableFutureDates: false,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Audit Committee Table Date",
                          value: vModel.auditCommitteeTableDate,
                          onSelect: vModel.setAuditCommitteeTableDate,
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
                        await vModel.addAuditRequest();

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Audit Request Added Successfully",
                            ),
                          ),
                        );
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
                      label: const Text(
                        "Add Audit Request",
                        style: TextStyle(
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

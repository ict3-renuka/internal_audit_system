import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/data/models/draft_observation_model.dart';
import 'package:project_one/ui/widget/nav_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_text_style.dart';
import '../../widget/master_date_field_widget.dart';
import 'draft_observation_view_model.dart';

class DraftObservationView extends StatefulWidget {
  final DraftObservationModel? draftObservation;
  const DraftObservationView({super.key,this.draftObservation,});

  @override
  State<DraftObservationView> createState() => _DraftObservationViewState();
}

class _DraftObservationViewState extends State<DraftObservationView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (widget.draftObservation != null) {
        Provider.of<DraftObservationViewmodel>(
          context,
          listen: false,
        ).loadDraftObservation(
          widget.draftObservation!,
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<DraftObservationViewmodel>(context);
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
              "Draft Observation",
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
                        Icons.note_alt_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                          "Observation Details",
                          style: AppTextStyles.subTitle
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Area",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.areaController,
                              keyboardType:
                              TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Area",
                                hintStyle: AppTextStyles.hint,
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Subject",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.subjectController,
                              keyboardType:
                              TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Subject",
                                hintStyle: AppTextStyles.hint,
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.01),
                  const Text(
                    "Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: vModel.detailsController,
                    maxLines: 2,
                    maxLength: 300,
                    decoration: InputDecoration(
                      hintText:
                      "Enter detailed scope and context for this observation...",
                      hintStyle: AppTextStyles.hint,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: AppColors.border,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: width * 0.005),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Risk And Root Cause",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.riskAndRootCauseController,
                              keyboardType:
                              TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Risk And Root Cause",
                                hintStyle: AppTextStyles.hint,
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Recommendation",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.recommendationController,
                              keyboardType:
                              TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Recommendation",
                                hintStyle: AppTextStyles.hint,
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                        await vModel.addDraftObservation();

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Draft Observation Added Successfully",
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
                        "Add Draft Observation",
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
                        Icons.note_alt_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                          "Responsible User Details",
                          style: AppTextStyles.subTitle
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Department",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.departmentController,
                              keyboardType:
                              TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Department",
                                hintStyle: AppTextStyles.hint,
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Internal Department",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.internalDepartmentController,
                              keyboardType:
                              TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Internal Department",
                                hintStyle: AppTextStyles.hint,
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Responsible user",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.responsibleUserIdController,
                              keyboardType:
                              TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Responsible User",
                                hintStyle: AppTextStyles.hint,
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                        await vModel.addDraftObservation();

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Draft Observation Added Successfully",
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
                        "Add Draft Observation",
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
                        Icons.note_alt_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                          "Planned Action Details",
                          style: AppTextStyles.subTitle
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Action Timeline",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.actionTimeLineController,
                              keyboardType:
                              TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Action TimeLine (In Days)",
                                hintStyle: AppTextStyles.hint,
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.01),
                  const Text(
                    "Corrective Action Plan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: vModel.correctiveActionPlanController,
                    maxLines: 2,
                    maxLength: 300,
                    decoration: InputDecoration(
                      hintText:
                      "Enter Action Plan",
                      hintStyle: AppTextStyles.hint,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: AppColors.border,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: vModel.isLoading
                          ? null
                          : () async {
                        await vModel.addDraftObservation();

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Draft Observation Added Successfully",
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
                        "Add Draft Observation",
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
                        Icons.note_alt_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                          "Response Details",
                          style: AppTextStyles.subTitle
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Management Response",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: vModel.manageResponseController,
                    maxLines: 2,
                    maxLength: 300,
                    decoration: InputDecoration(
                      hintText:
                      "Enter Management Response",
                      hintStyle: AppTextStyles.hint,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: AppColors.border,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: vModel.isLoading
                          ? null
                          : () async {
                        await vModel.addDraftObservation();

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Draft Observation Added Successfully",
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
                        "Add Draft Observation",
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
                        Icons.note_alt_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                          "Follow Up Details",
                          style: AppTextStyles.subTitle
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Status",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.statusController,
                              keyboardType:
                              TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Status",
                                hintStyle: AppTextStyles.hint,
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Remark",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.remarkController,
                              keyboardType:
                              TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Remark",
                                hintStyle: AppTextStyles.hint,
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Remarked Date",
                          value: vModel.remarkedDate,
                          onSelect: vModel.setRemarkedDate,
                          disableFutureDates: true,
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
                        await vModel.addDraftObservation();

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Draft Observation Added Successfully",
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
                        "Add Draft Observation",
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

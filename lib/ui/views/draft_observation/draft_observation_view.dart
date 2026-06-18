import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/core/theme/app_text_style.dart';
import 'package:project_one/data/models/department_model.dart';
import 'package:project_one/data/models/internal_department_model.dart';
import 'package:project_one/ui/widget/master_date_field_widget.dart';
import 'package:project_one/ui/widget/master_text_field_widget.dart';
import 'package:project_one/ui/widget/nav_bar_widget.dart';
import 'package:project_one/ui/widget/section_card_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/utils.dart';
import '../../../data/models/combined_observation_model.dart';
import 'draft_observation_view_model.dart';

class DraftObservationView extends StatefulWidget {
  final CombinedObservationModel? combined;
  const DraftObservationView({super.key, this.combined});

  @override
  State<DraftObservationView> createState() => _DraftObservationViewState();
}

class _DraftObservationViewState extends State<DraftObservationView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final vModel = Provider.of<DraftObservationViewmodel>(
        context,
        listen: false,
      );
      vModel.initView(
        combined: widget.combined,
      );
    });
  }

  Future<void> _handleRemovePdf(BuildContext context, DraftObservationViewmodel vModel) async {
    if (vModel.pdfRemovalNeedsConfirmation) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Remove File"),
          content: const Text(
            "This will permanently delete the file from the database. Do you want to continue?",
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("No")),
            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("Yes")),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    await vModel.removePdf();

    if (vModel.observationErrorMessage != null) {
      AppSnackBar.error(context, vModel.observationErrorMessage!);
      vModel.observationErrorMessage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<DraftObservationViewmodel>(context);
    final width = MediaQuery.of(context).size.width;

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
            Text("Draft Observation", style: AppTextStyles.title),
            const SizedBox(height: 8),
            Text(
              "Initialize a new audit engagement by providing meeting details and firm contact information.",
              style: AppTextStyles.paragraph,
            ),
            SizedBox(height: width * 0.02),
            SectionCard(
              icon: Icons.note_alt_outlined,
              title: "Observation Details",
              width: width,
              isLoading: vModel.isLoading,
              onSubmit: (vModel.isResponseFieldsFilled || !vModel.canEditFollowUpFields)
                  ? null
                  : () async {
                      await vModel.addDraftObservation();
                      if (vModel.observationErrorMessage != null) {
                        AppSnackBar.error(
                          context,
                          vModel.observationErrorMessage!,
                        );
                      } else {
                        AppSnackBar.success(
                          context,
                          "Draft Observation Saved Successfully",
                        );
                      }
                    },
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MasterTextFieldWidget(
                        label: "Area",
                        controller: vModel.areaController,
                        hintText: "Enter Area",
                        readOnly: (vModel.isResponseFieldsFilled || !vModel.canEditFollowUpFields),
                      ),
                    ),
                    SizedBox(width: width * 0.01),
                    Expanded(
                      child: MasterTextFieldWidget(
                        label: "Subject",
                        controller: vModel.subjectController,
                        hintText: "Enter Subject",
                        readOnly: (vModel.isResponseFieldsFilled || !vModel.canEditFollowUpFields),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.01),
                MasterTextFieldWidget(
                  label: "Details",
                  controller: vModel.detailsController,
                  hintText:
                      "Enter detailed scope and context for this observation...",
                  readOnly: (vModel.isResponseFieldsFilled || !vModel.canEditFollowUpFields),
                  maxLines: 3,
                  maxLength: 600,
                ),
                SizedBox(height: width * 0.005),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                      (vModel.isResponseFieldsFilled || !vModel.canEditFollowUpFields)
                          ? null
                          : () async {
                        await vModel.pickPdf();
                        if (vModel.observationErrorMessage != null) {
                          AppSnackBar.error(context, vModel.observationErrorMessage!);
                          vModel.observationErrorMessage = null;
                        }
                      },
                      icon: Icon(Icons.upload_file,color: AppColors.primary ,),
                      label: Text("Choose PDF",style: TextStyle(color: AppColors.primary),),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.005,
                          vertical: width * 0.01,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),

                    const SizedBox(width: 15),

                    if(vModel.newPdfBytes != null || vModel.existingAttachmentId != null)
                      ElevatedButton.icon(
                        onPressed: () async {
                          await vModel.previewPdf();
                          if (vModel.observationErrorMessage != null) {
                            AppSnackBar.error(context, vModel.observationErrorMessage!);
                            vModel.observationErrorMessage = null;
                          }
                        },
                        icon: Icon(Icons.picture_as_pdf,color: AppColors.primary ,),
                        label: Text("Preview",style: TextStyle(color: AppColors.primary),),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.005,
                            vertical: width * 0.01,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),

                    const SizedBox(width: 15),

                    if(vModel.newPdfBytes != null || vModel.existingAttachmentId != null)

                      ElevatedButton.icon(
                        onPressed: (vModel.isResponseFieldsFilled || !vModel.canEditFollowUpFields)
                            ? null
                            : () async => await _handleRemovePdf(context, vModel),
                        icon: Icon(Icons.delete,color: AppColors.primary ,),
                        label: Text("Remove",style: TextStyle(color: AppColors.primary),),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.005,
                            vertical: width * 0.01,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                  ],
                ),
                if(vModel.newPdfBytes != null || vModel.existingAttachmentId != null)
                  Padding(
                    padding: const EdgeInsets.only(top:10),
                    child: Text(vModel.newPdfName ?? vModel.existingFileName ?? "" , style: TextStyle(color: AppColors.textLight),),
                  ),
                SizedBox(height: width * 0.01),
                Row(
                  children: [
                    Expanded(
                      child: MasterTextFieldWidget(
                        label: "Risk And Root Cause",
                        controller: vModel.riskAndRootCauseController,
                        hintText: "Enter Risk And Root Cause",
                        readOnly: (vModel.isResponseFieldsFilled || !vModel.canEditFollowUpFields),
                        maxLines: 3,
                        maxLength: 600,
                      ),
                    ),
                    SizedBox(width: width * 0.01),
                    Expanded(
                      child: MasterTextFieldWidget(
                        label: "Recommendation",
                        controller: vModel.recommendationController,
                        hintText: "Enter Recommendation",
                        readOnly: (vModel.isResponseFieldsFilled || !vModel.canEditFollowUpFields),
                        maxLines: 3,
                        maxLength: 600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (vModel.observationId != null) ...[
              SizedBox(height: width * 0.02),
              SectionCard(
                icon: Icons.note_alt_outlined,
                title: "Responsible User Details",
                width: width,
                isLoading: vModel.isLoading,
                onSubmit: !vModel.canEditFollowUpFields
                    ? null
                    : () async {
                        await vModel.addObservationDetails();
                        if (vModel.observationDetailsErrorMessage != null) {
                          AppSnackBar.error(
                            context,
                            vModel.observationDetailsErrorMessage!,
                          );
                        } else {
                          AppSnackBar.success(
                            context,
                            "Responsible users saved.",
                          );
                        }
                      },
                children: [
                  _buildResponsibleUserTable(vModel, width),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: !vModel.canEditFollowUpFields
                        ? null
                        : TextButton.icon(
                            onPressed: vModel.addResponsibleUserRow,
                            icon: const Icon(Icons.add),
                            label: const Text("Add Row"),
                          ),
                  ),
                ],
              ),
              SizedBox(height: width * 0.02),

              SectionCard(
                icon: Icons.note_alt_outlined,
                title: "Response Details",
                width: width,
                isLoading: vModel.isLoading,
                onSubmit:
                (!vModel.canEditActionFields || vModel.isFollowUpSaved)
                    ? null
                    : () async {
                  await vModel.updateObservationDetails(
                    section: 'response',
                  );
                  if (vModel.observationDetailsErrorMessage != null) {
                    AppSnackBar.error(
                      context,
                      vModel.observationDetailsErrorMessage!,
                    );
                  } else {
                    AppSnackBar.success(context, "Updated successfully.");
                  }
                },
                children: [
                  MasterTextFieldWidget(
                    label: "Management Response",
                    controller: vModel.manageResponseController,
                    hintText: "Enter Management Response",
                    maxLines: 3 ,
                    maxLength: 600,
                    readOnly: !vModel.canEditActionFields || vModel.isFollowUpSaved,
                  ),
                ],
              ),
              SizedBox(height: width * 0.02),
              SectionCard(
                icon: Icons.note_alt_outlined,
                title: "Planned Action Details",
                width: width,
                isLoading: vModel.isLoading,
                onSubmit: (!vModel.canEditActionFields || vModel.isFollowUpSaved)
                    ? null
                    : () async {
                        await vModel.updateObservationDetails(
                          section: 'action',
                        );
                        if (vModel.observationDetailsErrorMessage != null) {
                          AppSnackBar.error(
                            context,
                            vModel.observationDetailsErrorMessage!,
                          );
                        } else {
                          AppSnackBar.success(context, "Updated successfully.");
                        }
                      },
                children: [
                  MasterDateFieldWidget(
                    label: "Action Timeline",
                    value: vModel.actionTimeline,
                    onSelect:
                        (vModel.canEditActionFields &&
                            !vModel.isFollowUpSaved)
                        ? vModel.setActionTimeline
                        : (_) {},
                    disableFutureDates: false,
                  ),
                  SizedBox(height: width * 0.01),
                  MasterTextFieldWidget(
                    label: "Corrective Action Plan",
                    controller: vModel.correctiveActionPlanController,
                    hintText: "Enter Action Plan",
                    maxLines: 3,
                    maxLength: 600,
                    readOnly: !vModel.canEditActionFields || vModel.isFollowUpSaved,
                  ),
                ],
              ),
              SizedBox(height: width * 0.02),
              SectionCard(
                icon: Icons.note_alt_outlined,
                title: "Follow Up Details",
                width: width,
                isLoading: vModel.isLoading,
                onSubmit:
                    !vModel.canEditFollowUpFields
                    ? null
                    : () async {
                        await vModel.updateObservationDetails(
                          section: 'followup',
                        );
                        if (vModel.observationDetailsErrorMessage != null) {
                          AppSnackBar.error(
                            context,
                            vModel.observationDetailsErrorMessage!,
                          );
                        } else {
                          AppSnackBar.success(context, "Updated successfully.");
                        }
                      },
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MasterTextFieldWidget(
                          label: "Status",
                          controller: vModel.statusController,
                          hintText: "Enter Status",
                          readOnly: !vModel.canEditFollowUpFields,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterTextFieldWidget(
                          label: "Remark",
                          controller: vModel.remarkController,
                          hintText: "Enter Remark",
                          readOnly: !vModel.canEditFollowUpFields,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: MasterDateFieldWidget(
                          label: "Remarked Date",
                          value: vModel.remarkedDate,
                          onSelect: vModel.canEditFollowUpFields
                              ? vModel.setRemarkedDate
                              : (_) {},
                          disableFutureDates: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResponsibleUserTable(
    DraftObservationViewmodel vModel,
    double width,
  ) {
    const headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 13);
    const cellPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 6);

    final hasSavedRows = vModel.responsibleUserRows.any((r) => r.isSaved);
    final isAdmin = vModel.canEditFollowUpFields;
    final rows = vModel.visibleResponsibleUserRows;

    return Table(
      border: TableBorder.all(color: AppColors.border, width: 1),
      columnWidths: {
        0: const FlexColumnWidth(2),
        1: const FlexColumnWidth(2),
        2: const FlexColumnWidth(2),
        3: const IntrinsicColumnWidth(),
        if (isAdmin && hasSavedRows) 4: const IntrinsicColumnWidth(),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: AppColors.secondBackground),
          children: [
            Padding(
              padding: cellPadding,
              child: Text("Department", style: headerStyle),
            ),
            Padding(
              padding: cellPadding,
              child: Text("Internal Department", style: headerStyle),
            ),
            Padding(
              padding: cellPadding,
              child: Text("Responsible User", style: headerStyle),
            ),
            const SizedBox.shrink(),
            Padding(
              padding: cellPadding,
              child: Text("Is Active", style: headerStyle),
            ),
          ],
        ),

    ...List.generate(rows.length, (i) {
    final row = rows[i];
          return TableRow(
            children: [
              row.isSaved
                  ? Padding(
                      padding: cellPadding,
                      child: Text(row.displayDepartmentName),
                    )
                  : Padding(
                      padding: cellPadding,
                      child: DropdownButtonFormField<DepartmentModel>(
                        initialValue: row.selectedDepartment,
                        isExpanded: true,
                        hint: Text("Select", style: AppTextStyles.hint),
                        decoration: _dropdownDecor(),
                        items: vModel.allDepartments
                            .map(
                              (d) => DropdownMenuItem(
                                value: d,
                                child: Text(
                                  d.departmentName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (d) => vModel.onDepartmentSelected(i, d),
                      ),
                    ),

              row.isSaved
                  ? Padding(
                      padding: cellPadding,
                      child: Text(row.displayInternalDepartmentName),
                    )
                  : Padding(
                      padding: cellPadding,
                      child: DropdownButtonFormField<InternalDepartmentModel>(
                        initialValue: row.selectedInternalDepartment,
                        isExpanded: true,
                        hint: Text(
                          row.selectedDepartment == null
                              ? "Select dept first"
                              : "Select",
                          style: AppTextStyles.hint,
                        ),
                        decoration: _dropdownDecor(),
                        items: row.selectedDepartment == null
                            ? null
                            : row.filteredInternalDepts
                                  .map(
                                    (id) => DropdownMenuItem(
                                      value: id,
                                      child: Text(
                                        id.internalDepartmentName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        onChanged: row.selectedDepartment == null
                            ? null
                            : (id) =>
                                  vModel.onInternalDepartmentSelected(i, id),
                      ),
                    ),

              Padding(
                padding: cellPadding,
                child: row.isLoadingUser
                    ? Center(
                        child: const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : Text(
                        row.displayUserName,
                        style: TextStyle(
                          color: row.isSaved ? Colors.black87 : Colors.grey,
                        ),
                      ),
              ),

              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: row.isSaved ? Colors.grey : Colors.red,
                ),
                onPressed: row.isSaved
                    ? null
                    : () => vModel.removeResponsibleUserRow(i),
              ),
              if (isAdmin && row.isSaved)
                Padding(
                  padding: cellPadding,
                  child: Checkbox(
                    value: row.isActive,
                    activeColor: AppColors.primary,
                    onChanged: (value) => vModel.toggleRowIsActive(row, value ?? false),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          );
        }),
      ],
    );
  }

  InputDecoration _dropdownDecor() => InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: AppColors.border),
    ),
  );
}

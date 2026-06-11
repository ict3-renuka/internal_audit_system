import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/core/theme/app_text_style.dart';
import 'package:project_one/data/models/department_model.dart';
import 'package:project_one/data/models/draft_observation_model.dart';
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
  final DraftObservationModel? draftObservation;
  final CombinedObservationModel? combined;
  const DraftObservationView({super.key, this.draftObservation, this.combined,});

  @override
  State<DraftObservationView> createState() => _DraftObservationViewState();
}

class _DraftObservationViewState extends State<DraftObservationView> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() async{
      final vModel = Provider.of<DraftObservationViewmodel>(context, listen: false);
      vModel.initView(
        combined: widget.combined,
        draftObservation: widget.draftObservation,
      );
    });
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
              onSubmit: vModel.observationId != null ? null : () async {
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
                        readOnly: vModel.observationId != null,
                      ),
                    ),
                    SizedBox(width: width * 0.01),
                    Expanded(
                      child: MasterTextFieldWidget(
                        label: "Subject",
                        controller: vModel.subjectController,
                        hintText: "Enter Subject",
                        readOnly: vModel.observationId != null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.01),
                MasterTextFieldWidget(
                  label: "Details",
                  controller: vModel.detailsController,
                  hintText: "Enter detailed scope and context for this observation...",
                  readOnly: vModel.observationId != null,
                  maxLines: 2,
                  maxLength: 300,
                ),
                SizedBox(height: width * 0.005),
                Row(
                  children: [
                    Expanded(
                      child: MasterTextFieldWidget(
                        label: "Risk And Root Cause",
                        controller: vModel.riskAndRootCauseController,
                        hintText: "Enter Risk And Root Cause",
                        readOnly: vModel.observationId != null,
                        maxLines: 2,
                        maxLength: 300,
                      ),
                    ),
                    SizedBox(width: width * 0.01),
                    Expanded(
                      child: MasterTextFieldWidget(
                        label: "Recommendation",
                        controller: vModel.recommendationController,
                        hintText: "Enter Recommendation",
                        readOnly: vModel.observationId != null,
                        maxLines: 2,
                        maxLength: 300,
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
              onSubmit:
              !vModel.canEditFollowUpFields ? null :
                  () async {
                await vModel.addObservationDetails();
                if (vModel.observationDetailsErrorMessage != null) {
                  AppSnackBar.error(context, vModel.observationDetailsErrorMessage!);
                } else {
                  AppSnackBar.success(context, "Responsible users saved.");
                }
              },
              children: [
                _buildResponsibleUserTable(vModel, width),
                Align(
                  alignment: Alignment.centerLeft,
                  child: !vModel.canEditFollowUpFields ? null : TextButton.icon(
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
              title: "Planned Action Details",
              width: width,
              isLoading: vModel.isLoading,
              onSubmit: (!vModel.canEditActionFields || vModel.isActionSaved)
                  ? null
                  : () async {
                await vModel.updateObservationDetails(section: 'action' );
                if (vModel.observationDetailsErrorMessage != null) {
                  AppSnackBar.error(context, vModel.observationDetailsErrorMessage!);
                } else {
                  AppSnackBar.success(context, "Updated successfully.");
                }
              },
              children: [
                MasterDateFieldWidget(
                  label: "Action Timeline",
                  value: vModel.actionTimeline,
                  onSelect: (vModel.canEditActionFields && !vModel.isActionFieldsFilled)
                      ? vModel.setActionTimeline
                      : (_) {},
                  disableFutureDates: false,
                ),
                SizedBox(height: width * 0.01),
                MasterTextFieldWidget(
                  label: "Corrective Action Plan",
                  controller: vModel.correctiveActionPlanController,
                  hintText: "Enter Action Plan",
                  maxLines: 2,
                  maxLength: 300,
                  readOnly: !vModel.canEditActionFields,
                ),
              ],
            ),
            SizedBox(height: width * 0.02),

            SectionCard(
              icon: Icons.note_alt_outlined,
              title: "Response Details",
              width: width,
              isLoading: vModel.isLoading,
              onSubmit:(!vModel.canEditActionFields || vModel.isResponseSaved)
                  ? null
                  : () async {
                await vModel.updateObservationDetails(section: 'response');
                if (vModel.observationDetailsErrorMessage != null) {
                  AppSnackBar.error(context, vModel.observationDetailsErrorMessage!);
                } else {
                  AppSnackBar.success(context, "Updated successfully.");
                }
              },
              children: [
                MasterTextFieldWidget(
                  label: "Management Response",
                  controller: vModel.manageResponseController,
                  hintText: "Enter Management Response",
                  maxLines: 2,
                  maxLength: 300,
                  readOnly: !vModel.canEditActionFields,
                ),
              ],
            ),
            SizedBox(height: width * 0.02),

            SectionCard(
              icon: Icons.note_alt_outlined,
              title: "Follow Up Details",
              width: width,
              isLoading: vModel.isLoading,
              onSubmit: (!vModel.canEditFollowUpFields || vModel.isFollowUpSaved)
                  ? null
                  :  () async {
                await vModel.updateObservationDetails(section: 'followup');
                if (vModel.observationDetailsErrorMessage != null) {
                  AppSnackBar.error(context, vModel.observationDetailsErrorMessage!);
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
           ]
          ],
        ),
      ),
    );
  }

  Widget _buildResponsibleUserTable(DraftObservationViewmodel vModel, double width) {
    const headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 13);
    const cellPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 6);

    return Table(
      border: TableBorder.all(color: AppColors.border, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: AppColors.secondBackground),
          children: [
            Padding(padding: cellPadding, child: Text("Department", style: headerStyle)),
            Padding(padding: cellPadding, child: Text("Internal Department", style: headerStyle)),
            Padding(padding: cellPadding, child: Text("Responsible User", style: headerStyle)),
            const SizedBox.shrink(),
          ],
        ),

        ...List.generate(vModel.responsibleUserRows.length, (i) {
          final row = vModel.responsibleUserRows[i];
          return TableRow(
            children: [
              row.isSaved
                  ? Padding(
                padding: cellPadding,
                child: Text(row.displayDepartmentName),
              ) :
              Padding(
                padding: cellPadding,
                child: DropdownButtonFormField<DepartmentModel>(
                  value: row.selectedDepartment,
                  isExpanded: true,
                  hint: Text("Select", style: AppTextStyles.hint),
                  decoration: _dropdownDecor(),
                  items: vModel.allDepartments
                      .map((d) => DropdownMenuItem(
                    value: d,
                    child: Text(d.departmentName, overflow: TextOverflow.ellipsis),
                  ))
                      .toList(),
                  onChanged: (d) => vModel.onDepartmentSelected(i, d),
                ),
              ),

              row.isSaved
                  ? Padding(
                padding: cellPadding,
                child: Text(row.displayInternalDepartmentName),
              ) :
              Padding(
                padding: cellPadding,
                child: DropdownButtonFormField<InternalDepartmentModel>(
                  value: row.selectedInternalDepartment,
                  isExpanded: true,
                  hint: Text(
                    row.selectedDepartment == null ? "Select dept first" : "Select",
                    style: AppTextStyles.hint,
                  ),
                  decoration: _dropdownDecor(),
                  items: row.selectedDepartment == null
                      ? null
                      : row.filteredInternalDepts
                      .map((id) => DropdownMenuItem(
                    value: id,
                    child: Text(id.internalDepartmentName, overflow: TextOverflow.ellipsis),
                  ))
                      .toList(),
                  onChanged: row.selectedDepartment == null
                      ? null
                      : (id) => vModel.onInternalDepartmentSelected(i, id),
                ),
              ),

              Padding(
                padding: cellPadding,
                child: row.isLoadingUser
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    :
                Text(
                  row.displayUserName,
                  style: TextStyle(
                    color: row.isSaved ? Colors.black87 : Colors.grey,
                  ),
                ),
              ),

              IconButton(
                icon: Icon(Icons.delete_outline, color: row.isSaved ? Colors.grey : Colors.red),
                onPressed: row.isSaved ? null : () => vModel.removeResponsibleUserRow(i),
              ),
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
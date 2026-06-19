import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../widget/nav_bar_widget.dart';
import '../../widget/master_date_field_widget.dart';
import '../../widget/section_card_widget.dart';
import '../../widget/submit_button_widget.dart';
import 'observation_report_view_model.dart';

class ObservationReportView extends StatefulWidget {
  const ObservationReportView({super.key});

  @override
  State<ObservationReportView> createState() => _ObservationReportViewState();
}

class _ObservationReportViewState extends State<ObservationReportView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ObservationReportViewModel>(
        context,
        listen: false,
      ).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<ObservationReportViewModel>(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondBackground,
      appBar: AppNavBar(),

      body: Padding(
        padding: EdgeInsets.all(width * 0.03),
        child: SectionCard(
          icon: Icons.picture_as_pdf,
          title: "Observation Report",
          buttonText: "View Report",
          width: width,
          isLoading: vModel.isLoading,
          onSubmit: vModel.generateReport,
          actions: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: vModel.clearFilters,
                icon: Icon(Icons.clear),
                label: Text("Clear Filters"),
              ),

              SubmitButton(
                isLoading: vModel.isLoading,
                width: width,
                onSubmit: vModel.generateReport,
                buttonText: "View Report",
              ),
            ],
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    initialValue: vModel.selectedDepartment?.departmentId,
                    items: vModel.departments
                        .map(
                          (d) => DropdownMenuItem(
                        value: d.departmentId,
                        child: Text(d.departmentName),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      final selected = vModel.departments.firstWhere(
                            (d) => d.departmentId == value,
                      );
                      vModel.setDepartment(selected);
                    },
                    decoration: _decoration("Department"),
                  ),
                ),
                SizedBox(width: width * 0.01),
                Expanded(
                  child: DropdownButtonFormField(
                    initialValue: vModel.selectedInternalDepartment?.internalDepartmentId,
                    items: vModel.internalDepartments
                        .map(
                          (d) => DropdownMenuItem(
                        value: d.internalDepartmentId,
                        child: Text(d.internalDepartmentName),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      final selected = vModel.internalDepartments.firstWhere(
                            (d) => d.internalDepartmentId == value,
                      );
                      vModel.setInternalDepartment(selected);
                    },
                    decoration: _decoration("Internal Department"),
                  ),
                ),
                SizedBox(width: width * 0.01),
                Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: vModel.selectedStatus,
                      items: vModel.statusList
                          .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      ))
                          .toList(),
                      onChanged:vModel.setStatus,
                      decoration: _decoration("Status"),
                    ),)
              ],
            ),
            SizedBox(height: width * 0.01),

            Row(
              children: [
                Expanded(
                  child: MasterDateFieldWidget(
                    label: "From Date",
                    value: vModel.fromDate,
                    onSelect: vModel.setFromDate,
                    disableFutureDates: false,
                  ),
                ),
                SizedBox(width: width * 0.01),

                Expanded(
                  child: MasterDateFieldWidget(
                    label: "To Date",
                    value: vModel.toDate,
                    onSelect: vModel.setToDate,
                    disableFutureDates: false,
                  ),
                ),
              ],
            ),

            if (vModel.errorMessage != null) ...[
              SizedBox(height: 10),
              Text(
                vModel.errorMessage!,
                style: TextStyle(color: Colors.red),
              )
            ],
          ],
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
  );
}
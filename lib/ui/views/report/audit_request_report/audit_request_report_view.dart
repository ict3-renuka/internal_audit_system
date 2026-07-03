import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../widget/master_date_field_widget.dart';
import '../../../widget/nav_bar_widget.dart';
import '../../../widget/section_card_widget.dart';
import '../../../widget/submit_button_widget.dart';
import 'audit_request_report_view_model.dart';

class AuditRequestReportView extends StatefulWidget {
  const AuditRequestReportView({super.key});

  @override
  State<AuditRequestReportView> createState() =>
      _AuditRequestReportViewState();
}

class _AuditRequestReportViewState
    extends State<AuditRequestReportView> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final vm = Provider.of<AuditRequestReportViewModel>(context, listen: false,);
      vm.init();
      vm.clearFilters();
    });
  }

  @override
  Widget build(BuildContext context) {

    final vModel = Provider.of<AuditRequestReportViewModel>(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondBackground,
      appBar: AppNavBar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * .03),
          child: SectionCard(
            icon: Icons.picture_as_pdf,
            title: "Audit Request Report",
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
                  width: width,
                  buttonText: "View Report",
                  isLoading: vModel.isLoading,
                  onSubmit: vModel.generateReport,
                )

              ],
            ),

            children: [

              Row(
                children: [

                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: vModel.selectedSector,
                      items: vModel.sectorList
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: vModel.setSector,
                      decoration: _decoration("Sector"),
                    ),
                  ),

                  SizedBox(width: width * .01),

                  Expanded(
                    child: DropdownButtonFormField(
                      value: vModel.selectedCompany?.companyId,
                      isExpanded: true,
                      items: vModel.companies
                          .map((e) => DropdownMenuItem(
                        value: e.companyId,
                        child: Text(e.companyName),
                      ))
                          .toList(),
                      onChanged: (value){

                        final company =
                        vModel.companies.firstWhere(
                                (e)=>e.companyId==value);

                        vModel.setCompany(company);

                      },
                      decoration: _decoration("Company"),
                    ),
                  ),

                  SizedBox(width: width * .01),

                  Expanded(
                    child: DropdownButtonFormField(
                      value: vModel.selectedDepartment?.departmentId,
                      isExpanded: true,
                      items: vModel.departments
                          .map((e)=>DropdownMenuItem(
                        value: e.departmentId,
                        child: Text(e.departmentName),
                      ))
                          .toList(),
                      onChanged: (value){

                        final dep =
                        vModel.departments.firstWhere(
                                (e)=>e.departmentId==value);

                        vModel.setDepartment(dep);

                      },
                      decoration: _decoration("Department"),
                    ),
                  ),

                  SizedBox(width: width * .01),

                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: vModel.selectedStatus,
                      items: vModel.statusList
                          .map((e)=>DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: vModel.setStatus,
                      decoration: _decoration("Status"),
                    ),
                  ),

                ],
              ),

              SizedBox(height: width*.01),

              Row(
                children: [

                  Expanded(
                    child: MasterDateFieldWidget(
                      label: "From Date",
                      value: vModel.fromDate,
                      onSelect: vModel.setFromDate,
                    ),
                  ),

                  SizedBox(width: width*.01),

                  Expanded(
                    child: MasterDateFieldWidget(
                      label: "To Date",
                      value: vModel.toDate,
                      onSelect: vModel.setToDate,
                    ),
                  )

                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label){

    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    );

  }
}
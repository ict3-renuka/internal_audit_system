import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/ui/widget/nav_bar_widget.dart';
import 'package:provider/provider.dart';

import 'audit_request_view.dart';
import 'audit_request_view_model.dart';

class EditAuditRequestView extends StatefulWidget {
  const EditAuditRequestView({super.key});

  @override
  State<EditAuditRequestView> createState() => _EditAuditRequestViewState();
}

class _EditAuditRequestViewState extends State<EditAuditRequestView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<AuditRequestViewmodel>(
        context,
        listen: false,
      ).loadAuditRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<AuditRequestViewmodel>(context);
    double width = MediaQuery.of(context).size.width;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppNavBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.background,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.07,
                vertical: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Audit Requests',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Search and manage all audit request entries.',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.07,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      controller: vModel.searchController,
                      onChanged: vModel.search,
                      decoration: const InputDecoration(
                        hintText: "Search audit requests...",
                        prefixIcon: Icon(Icons.search, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: vModel.isLoading
                        ? const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingRowColor: WidgetStateProperty.all(AppColors.thirdBackground),
                            columnSpacing: 16,
                            horizontalMargin: 16,
                            columns: const [
                              DataColumn(label: _HeaderLabel('Meeting Date')),
                              DataColumn(label: _HeaderLabel('Description')),
                              DataColumn(label: _HeaderLabel('Preliminary Start')),
                              DataColumn(label: _HeaderLabel('Person ID')),
                              DataColumn(label: _HeaderLabel('Person Name')),
                              DataColumn(label: _HeaderLabel('Audit Department')),
                              DataColumn(label: _HeaderLabel('Info. Request')),
                              DataColumn(label: _HeaderLabel('Info. Submit')),
                              DataColumn(label: _HeaderLabel('Field Work Start')),
                              DataColumn(label: _HeaderLabel('Field Work End')),
                              DataColumn(label: _HeaderLabel('Exit Meeting')),
                              DataColumn(label: _HeaderLabel('Management Discussion')),
                              DataColumn(label: _HeaderLabel('Report Issued')),
                              DataColumn(label: _HeaderLabel('Shared to Board')),
                              DataColumn(label: _HeaderLabel('Audit Committee Table')),
                            ],
                            rows: vModel.filteredList.map((e) {
                              return DataRow(
                                onSelectChanged: (_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AuditRequestView(
                                        auditRequest: e,
                                      ),
                                    ),
                                  );
                                },
                                cells: [
                                  DataCell(Text(e.meetingDate == null ? "" : DateFormat('yyyy-MM-dd').format(e.meetingDate),),),
                                  DataCell(
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        e.description,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(e.preliminaryStartDate == null ? "" : DateFormat('yyyy-MM-dd').format(e.preliminaryStartDate!),),),
                                  DataCell(Text(e.auditFirm)),
                                  DataCell(Text(e.auditFirmPersonName)),
                                  DataCell(Text(e.auditDepartment)),
                                  DataCell(Text(e.infoRequestDate == null ? "" : DateFormat('yyyy-MM-dd').format(e.infoRequestDate!),),),
                                  DataCell(Text(e.infoSubmitDate == null ? "" : e.infoSubmitDate!.toString())),
                                  DataCell(Text(e.fieldWorkStartDate == null ? "" : e.fieldWorkStartDate!.toString())),
                                  DataCell(Text(e.fieldWorkEndDate == null ? "" : e.fieldWorkEndDate!.toString())),
                                  DataCell(Text(e.exitMeetingDate == null ? "" : e.exitMeetingDate!.toString())),
                                  DataCell(Text(e.managementDiscussionDate == null ? "" : e.managementDiscussionDate!.toString())),
                                  DataCell(Text(e.reportIssuedDate == null ? "" : e.reportIssuedDate!.toString())),
                                  DataCell(Text(e.sharedToBoardDate == null ? "" : e.sharedToBoardDate!.toString())),
                                  DataCell(Text(e.auditCommitteeTableDate == null ? "" : e.auditCommitteeTableDate!.toString())),
                                ],
                              );
                            }).toList(),
                          ),
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

class _HeaderLabel extends StatelessWidget {
  final String text;
  const _HeaderLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.black87,
      ),
    );
  }
}
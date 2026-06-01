import 'package:flutter/material.dart';
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
                        child: DataTable(
                          showCheckboxColumn: false,
                          headingRowColor: WidgetStateProperty.all(AppColors.thirdBackground),
                          columnSpacing: 16,
                          horizontalMargin: 16,
                          columns: const [
                            DataColumn(label: _HeaderLabel('MEETING DATE')),
                            DataColumn(label: _HeaderLabel('DESCRIPTION')),
                            DataColumn(label: _HeaderLabel('PRELIMINARY START')),
                            DataColumn(label: _HeaderLabel('PERSON ID')),
                            DataColumn(label: _HeaderLabel('PERSON NAME')),
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
                                DataCell(Text(e.meetingDate)),
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      e.description,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(e.preliminaryStartDate)),
                                DataCell(Text(e.auditFirmPersonId.toString())),
                                DataCell(Text(e.auditFirmPersonName)),
                              ],
                            );
                          }).toList(),
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
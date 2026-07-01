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
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AuditRequestViewmodel>(
        context,
        listen: false,
      ).loadAuditRequests(page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<AuditRequestViewmodel>(context);
    final double width = MediaQuery.of(context).size.width;
    final DateFormat fmt = DateFormat('yyyy-MM-dd');

    String fmtDate(DateTime? d) => d == null ? "" : fmt.format(d);

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
                vertical: 32,
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
                  const SizedBox(height: 8),
                  Text(
                    'Search and manage all audit request entries.',
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
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
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Scrollbar(
                            controller: _horizontalScrollController,
                            thumbVisibility: true,
                            trackVisibility: true,
                            child: SingleChildScrollView(
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                showCheckboxColumn: false,
                                headingRowColor: WidgetStateProperty.all(
                                  AppColors.thirdBackground,
                                ),
                                columnSpacing: 16,
                                horizontalMargin: 16,
                                columns: const [
                                  DataColumn(
                                    label: _HeaderLabel('Review Reference'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Kick of Meeting Date'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Audit Name'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Preliminary Information Request Date'),
                                  ),
                                  DataColumn(label: _HeaderLabel('Audit Firm')),
                                  DataColumn(
                                    label: _HeaderLabel('Audit Manager'),
                                  ),
                                  DataColumn(label: _HeaderLabel('Sector')),
                                  DataColumn(label: _HeaderLabel('Company')),
                                  DataColumn(label: _HeaderLabel('Department')),
                                  DataColumn(
                                    label: _HeaderLabel('Info. Request'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Info. Submit'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Field Work Start'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Field Work End'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Exit Meeting'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Mgmt. Discussion'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Mgmt. Response Received'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Draft Report Received'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Draft Report Circulate'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Final Report Issued'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Shared to Board of Directors'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Audit Committee Table Date'),
                                  ),
                                ],
                                rows: vModel.filteredList.map((e) {
                                  return DataRow(
                                    onSelectChanged: (_) async {
                                      final updated = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              AuditRequestView(auditRequest: e),
                                        ),
                                      );
                                      if (updated == true) {
                                        vModel.loadAuditRequests(
                                          page: vModel.currentPage,
                                        );
                                      }
                                    },
                                    cells: [
                                      DataCell(Text(e.reviewReference)),
                                      DataCell(Text(fmtDate(e.meetingDate))),
                                      DataCell(
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            e.auditName,
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(fmtDate(e.preliminaryStartDate)),
                                      ),
                                      DataCell(Text(e.auditFirm)),
                                      DataCell(Text(e.auditManager)),
                                      DataCell(Text(e.sector)),
                                      DataCell(
                                        Text(
                                          vModel.getCompanyName(
                                            e.companyId,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          vModel.getDepartmentName(
                                            e.auditDepartmentId,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(fmtDate(e.infoRequestDate)),
                                      ),
                                      DataCell(Text(fmtDate(e.infoSubmitDate))),
                                      DataCell(
                                        Text(fmtDate(e.fieldWorkStartDate)),
                                      ),
                                      DataCell(
                                        Text(fmtDate(e.fieldWorkEndDate)),
                                      ),
                                      DataCell(
                                        Text(fmtDate(e.exitMeetingDate)),
                                      ),
                                      DataCell(
                                        Text(
                                          fmtDate(e.managementDiscussionDate),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          fmtDate(e.managementResponseReceivedDate),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          fmtDate(e.draftReportReceivedDate),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          fmtDate(e.draftReportCirculateDate),
                                        ),
                                      ),
                                      DataCell(
                                        Text(fmtDate(e.reportIssuedDate)),
                                      ),
                                      DataCell(
                                        Text(fmtDate(e.sharedToBoardDate)),
                                      ),
                                      DataCell(
                                        Text(
                                          fmtDate(e.auditCommitteeTableDate),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  if (!vModel.isLoading)
                    Builder(
                      builder: (context) {
                        final summaryText = Text(
                          "Showing page ${vModel.currentPage} of ${vModel.totalPages}  •  ${vModel.totalCount} total records",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        );

                        final pagination = Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            IconButton(
                              tooltip: "First page",
                              onPressed: vModel.currentPage > 1
                                  ? () => vModel.loadAuditRequests(page: 1)
                                  : null,
                              icon: const Icon(Icons.first_page),
                            ),
                            IconButton(
                              tooltip: "Previous page",
                              onPressed: vModel.currentPage > 1
                                  ? () => vModel.loadAuditRequests(
                                      page: vModel.currentPage - 1,
                                    )
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                            ),
                            ...List.generate(vModel.totalPages, (i) => i + 1)
                                .where(
                                  (p) =>
                                      p == 1 ||
                                      p == vModel.totalPages ||
                                      (p - vModel.currentPage).abs() <= 2,
                                )
                                .fold<List<Widget>>([], (acc, p) {
                                  if (acc.isNotEmpty &&
                                      acc.last is! _PageChip) {
                                    acc.add(
                                      const Text(
                                        "...",
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                    );
                                  }
                                  acc.add(
                                    _PageChip(
                                      page: p,
                                      isSelected: p == vModel.currentPage,
                                      onTap: () =>
                                          vModel.loadAuditRequests(page: p),
                                    ),
                                  );
                                  return acc;
                                }),
                            IconButton(
                              tooltip: "Next page",
                              onPressed: vModel.currentPage < vModel.totalPages
                                  ? () => vModel.loadAuditRequests(
                                      page: vModel.currentPage + 1,
                                    )
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                            ),
                            IconButton(
                              tooltip: "Last page",
                              onPressed: vModel.currentPage < vModel.totalPages
                                  ? () => vModel.loadAuditRequests(
                                      page: vModel.totalPages,
                                    )
                                  : null,
                              icon: const Icon(Icons.last_page),
                            ),
                          ],
                        );
                        if (width >= 700) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [summaryText, pagination],
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            summaryText,
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: pagination,
                            ),
                          ],
                        );
                      },
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

class _PageChip extends StatelessWidget {
  final int page;
  final bool isSelected;
  final VoidCallback onTap;
  const _PageChip({
    required this.page,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          "$page",
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

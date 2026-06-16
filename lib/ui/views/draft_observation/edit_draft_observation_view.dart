import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/ui/views/draft_observation/draft_observation_view.dart';
import 'package:project_one/ui/views/draft_observation/draft_observation_view_model.dart';
import 'package:project_one/ui/widget/nav_bar_widget.dart';
import 'package:provider/provider.dart';

class EditDraftObservationView extends StatefulWidget {
  const EditDraftObservationView({super.key});

  @override
  State<EditDraftObservationView> createState() => _EditDraftObservationViewState();
}

class _EditDraftObservationViewState extends State<EditDraftObservationView> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    Future.microtask(() async{
      final vModel = Provider.of<DraftObservationViewmodel>(context, listen: false);
      vModel.searchController.clear();
      vModel.filteredCombinedList = [];
      await vModel.loadSessionUser();
      await vModel.loadCombinedObservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<DraftObservationViewmodel>(context);
    final width = MediaQuery.of(context).size.width;

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
                    'Draft Observations',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Search and manage all draft observation entries.',
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
                  Row(
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
                          onChanged: vModel.searchCombined,
                          decoration: const InputDecoration(
                            hintText: "Search observations...",
                            prefixIcon: Icon(Icons.search, size: 20),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (vModel.canEditFollowUpFields) ...[
                        Checkbox(
                          value: vModel.includeInactive,
                          activeColor: AppColors.primary,
                          onChanged: (_) => vModel.toggleIncludeInactive(),
                        ),
                        const Text("Include Inactive", style: TextStyle(fontSize: 13)),
                      ],
                    ],
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
                          dataRowMinHeight: 48,
                          dataRowMaxHeight: double.infinity,
                          columns: const [
                            DataColumn(label: _HeaderLabel('Area')),
                            DataColumn(label: _HeaderLabel('Subject')),
                            DataColumn(label: _HeaderLabel('Details')),
                            DataColumn(label: _HeaderLabel('Risk & Root Cause')),
                            DataColumn(label: _HeaderLabel('Recommendation')),
                            DataColumn(label: _HeaderLabel('Department')),
                            DataColumn(label: _HeaderLabel('Internal Department')),
                            DataColumn(label: _HeaderLabel('Responsible User')),
                            DataColumn(label: _HeaderLabel('Management Response')),
                            DataColumn(label: _HeaderLabel('Action Plan')),
                            DataColumn(label: _HeaderLabel('Action Timeline')),
                            DataColumn(label: _HeaderLabel('Status')),
                            DataColumn(label: _HeaderLabel('Remark')),
                            DataColumn(label: _HeaderLabel('Remarked Date')),
                          ],
                          rows: vModel.filteredCombinedList.map((e) {
                            final isInactive = !(e.isActive ?? true);
                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                    (states) {
                                  if (isInactive) {
                                    return Colors.grey.shade300;
                                  }
                                  return null;
                                },
                              ),
                              onSelectChanged: (_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DraftObservationView(
                                      draftObservation: e.toDraftObservationModel(),
                                      combined: e,
                                    ),
                                  ),
                                );
                              },
                              cells: [
                                DataCell(Text(e.area)),
                                DataCell(Text(e.subject)),
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      e.details,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      e.riskAndRootCause,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      e.recommendation,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                                DataCell(Text(e.departmentName ?? '—')),
                                DataCell(Text(e.internalDepartmentName ?? '—')),
                                DataCell(Text(e.responsibleUser ?? '—')),
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      e.managementResponse ?? '—',
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      e.correctiveActionPlan ?? '—',
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                                DataCell(Text(
                                  e.actionTimeLine != null
                                      ? e.actionTimeLine!
                                      .toIso8601String()
                                      .split('T')
                                      .first
                                      : '—',
                                )),
                                DataCell(Text(e.status ?? '—')),
                                DataCell(Text(e.remark ?? '—')),
                                DataCell(Text(
                                  e.remarkedDate != null
                                      ? e.remarkedDate!
                                      .toIso8601String()
                                      .split('T')
                                      .first
                                      : '—',
                                )),
                              ],
                            );
                          }).toList(),
                                                  ),
                                                ),
                        ),
                  ),
                  const SizedBox(height: 16),
                  if (!vModel.isLoading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Showing page ${vModel.currentPage} of ${vModel.totalPages} '
                              '(${vModel.totalCount} total)',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.first_page),
                              onPressed: vModel.currentPage > 1
                                  ? () => vModel.goToPage(1)
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: vModel.currentPage > 1
                                  ? () => vModel.goToPage(vModel.currentPage - 1)
                                  : null,
                            ),
                            ..._pageNumbers(
                              vModel.currentPage,
                              vModel.totalPages,
                            ).map(
                                  (p) => Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 2),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: p == vModel.currentPage
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    foregroundColor: p == vModel.currentPage
                                        ? Colors.white
                                        : Colors.black87,
                                    minimumSize: const Size(36, 36),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () => vModel.goToPage(p),
                                  child: Text('$p'),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: vModel.currentPage < vModel.totalPages
                                  ? () => vModel.goToPage(vModel.currentPage + 1)
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.last_page),
                              onPressed: vModel.currentPage < vModel.totalPages
                                  ? () => vModel.goToPage(vModel.totalPages)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<int> _pageNumbers(int current, int total) {
    final start = (current - 2).clamp(1, total);
    final end = (start + 4).clamp(1, total);
    return List.generate(end - start + 1, (i) => start + i);
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
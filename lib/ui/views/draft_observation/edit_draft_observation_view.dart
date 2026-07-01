import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/ui/views/draft_observation/draft_observation_view.dart';
import 'package:project_one/ui/views/draft_observation/draft_observation_view_model.dart';
import 'package:project_one/ui/widget/nav_bar_widget.dart';
import 'package:provider/provider.dart';

class EditDraftObservationView extends StatefulWidget {
  const EditDraftObservationView({super.key});

  @override
  State<EditDraftObservationView> createState() =>
      _EditDraftObservationViewState();
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
    Future.microtask(() async {
      final vModel = Provider.of<DraftObservationViewmodel>(
        context,
        listen: false,
      );
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
                        const Text(
                          "Include Inactive",
                          style: TextStyle(fontSize: 13),
                        ),
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
                                  DataColumn(
                                    label: _HeaderLabel('Risk & Root Cause'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Recommendation'),
                                  ),
                                  DataColumn(label: _HeaderLabel('Department')),
                                  DataColumn(
                                    label: _HeaderLabel('Internal Department'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Responsible User'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Management Response'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Action Plan'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Action Timeline'),
                                  ),
                                  DataColumn(label: _HeaderLabel('Status')),
                                  DataColumn(label: _HeaderLabel('Remark')),
                                  DataColumn(
                                    label: _HeaderLabel('Remarked Date'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel('Amendment Management Response'),
                                  ),
                                  DataColumn(
                                    label: _HeaderLabel("Attachments"),
                                  ),
                                ],
                                rows: vModel.filteredCombinedList.map((e) {
                                  final isInactive = !(e.isActive ?? true);
                                  return DataRow(
                                    color:
                                        WidgetStateProperty.resolveWith<Color?>(
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
                                          builder: (_) =>
                                              DraftObservationView(combined: e),
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
                                      DataCell(
                                        Text(e.internalDepartmentName ?? '—'),
                                      ),
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
                                      DataCell(
                                        Text(
                                          e.actionTimeLine != null
                                              ? e.actionTimeLine!
                                                    .toIso8601String()
                                                    .split('T')
                                                    .first
                                              : '—',
                                        ),
                                      ),
                                      DataCell(Text(e.status ?? '—')),
                                      DataCell(Text(e.remark ?? '—')),
                                      DataCell(
                                        Text(
                                          e.remarkedDate != null
                                              ? e.remarkedDate!
                                                    .toIso8601String()
                                                    .split('T')
                                                    .first
                                              : '—',
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            e.amendmentManagementResponse ?? '—',
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        e.hasPdf
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.picture_as_pdf,
                                                  color: AppColors.primary,
                                                ),
                                                onPressed: () async {
                                                  vModel.openPdf(
                                                    e.observationId,
                                                  );
                                                },
                                              )
                                            : const Text("-"),
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
                                  ? () => vModel.loadCombinedObservations(page: 1)
                                  : null,
                              icon: const Icon(Icons.first_page),
                            ),
                            IconButton(
                              tooltip: "Previous page",
                              onPressed: vModel.currentPage > 1
                                  ? () => vModel.loadCombinedObservations(
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
                                      vModel.loadCombinedObservations(page: p),
                                ),
                              );
                              return acc;
                            }),
                            IconButton(
                              tooltip: "Next page",
                              onPressed: vModel.currentPage < vModel.totalPages
                                  ? () => vModel.loadCombinedObservations(
                                page: vModel.currentPage + 1,
                              )
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                            ),
                            IconButton(
                              tooltip: "Last page",
                              onPressed: vModel.currentPage < vModel.totalPages
                                  ? () => vModel.loadCombinedObservations(
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

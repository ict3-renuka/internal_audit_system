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
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<DraftObservationViewmodel>(
        context,
        listen: false,
      ).loadAuditRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<DraftObservationViewmodel>(context);
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
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingRowColor: WidgetStateProperty.all(AppColors.thirdBackground),
                            columnSpacing: 16,
                            horizontalMargin: 16,
                            columns: const [
                              DataColumn(label: _HeaderLabel('Area')),
                              DataColumn(label: _HeaderLabel('Subject')),
                              DataColumn(label: _HeaderLabel('Details')),
                              DataColumn(label: _HeaderLabel('Risk and Root Cause')),
                              DataColumn(label: _HeaderLabel('Recommendation')),
                              DataColumn(label: _HeaderLabel('Management Response')),
                              DataColumn(label: _HeaderLabel('Action Plan')),
                              DataColumn(label: _HeaderLabel('Action Timeline')),
                              DataColumn(label: _HeaderLabel('Responsible User')),
                              DataColumn(label: _HeaderLabel('status')),
                              DataColumn(label: _HeaderLabel('Remark')),
                              DataColumn(label: _HeaderLabel('Remarked Date')),
                            ],
                            rows: vModel.filteredList.map((e) {
                              return DataRow(
                                onSelectChanged: (_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DraftObservationView(
                                        draftObservation: e,
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
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(e.riskAndRootCause)),
                                  DataCell(Text(e.recommendation)),
                                  DataCell(Text(e.manageResponse!)),
                                  DataCell(Text(e.correctiveActionPlan!)),
                                  DataCell(Text(e.actionTimeLine!.toString())),
                                  DataCell(Text(e.responsibleUserId.toString())),
                                  DataCell(Text(e.status!)),
                                  DataCell(Text(e.remark!)),
                                  DataCell(Text(e.remarkedDate!)),
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
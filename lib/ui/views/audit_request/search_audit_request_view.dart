import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'audit_request_view.dart';
import 'audit_request_view_model.dart';

class SearchAuditRequestView extends StatefulWidget {

  const SearchAuditRequestView({super.key});

  @override
  State<SearchAuditRequestView> createState() => _SearchAuditRequestViewState();
}

class _SearchAuditRequestViewState extends State<SearchAuditRequestView> {

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

    final vModel =
    Provider.of<AuditRequestViewmodel>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search Audit Requests",
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.blue,
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: vModel.searchController,
              onChanged: vModel.search,
              decoration: InputDecoration(
                labelText: "Search by Description",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: vModel.isLoading
                  ? const Center(
                child:
                CircularProgressIndicator(),
              )
                  : SingleChildScrollView(
                scrollDirection:
                Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                      label: Text("Meeting Date"),
                    ),
                    DataColumn(
                      label: Text("Description"),
                    ),
                    DataColumn(
                      label: Text(
                        "Preliminary Start",
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Person ID",
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Person Name",
                      ),
                    ),
                  ],
                  rows: vModel.filteredList.map((e) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(e.meetingDate),
                        ),
                        DataCell(
                          Text(e.description),
                        ),
                        DataCell(
                          Text(
                            e.preliminaryStartDate,
                          ),
                        ),
                        DataCell(
                          Text(
                            e.auditFirmPersonId
                                .toString(),
                          ),
                        ),
                        DataCell(
                          Text(
                            e.auditFirmPersonName,
                          ),
                        ),
                      ],
                      onSelectChanged: (_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return AuditRequestView(
                                auditRequest: e,
                              );
                            },
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
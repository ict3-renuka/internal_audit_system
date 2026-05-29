import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_center_viewmodel.dart';

class AddCenterView extends StatefulWidget {
  const AddCenterView({super.key});

  @override
  State<AddCenterView> createState() => _AddCenterViewState();
}

class _AddCenterViewState extends State<AddCenterView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<AddCenterViewmodel>(
        context,
        listen: false,
      ).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F9),
      appBar: AppBar(
        title: const Text("Add Center"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
          ),
        ),
      ),

      body: Consumer<AddCenterViewmodel>(
        builder: (context, vModel, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Add Center",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 30),
                          DropdownButtonFormField<String>(
                            initialValue: vModel.selectedCompany,
                            decoration: InputDecoration(
                              labelText: "Select Company",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: vModel.companyList.map((company) {
                              return DropdownMenuItem(
                                value: company.companyName,
                                child: Text(company.companyName),
                              );
                            }).toList(),
                            onChanged: vModel.setCompany,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: vModel.centerController,
                            decoration: InputDecoration(
                              labelText: "Center Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: vModel.isLoading
                                  ? null
                                  : () async {
                                await vModel.addCenter();
                              },
                              child: const Text(
                                "Add Center",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Center List",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: vModel.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor:
                                WidgetStateProperty.all(
                                  Colors.green.shade100,
                                ),
                                columns: const [
                                  DataColumn(label: Text("Center ID")),
                                  DataColumn(label: Text("Company Name")),
                                  DataColumn(label: Text("Center Name")),
                                ],
                                rows: vModel.centerList.map((e) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(e.centerId.toString())),

                                      DataCell(
                                        Text(
                                          vModel.getCompanyName(e.companyId),
                                        ),
                                      ),

                                      DataCell(Text(e.centerName)),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

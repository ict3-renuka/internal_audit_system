import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../widget/nav_bar_widget.dart';
import 'add_department_viewmodel.dart';

class AddDepartmentView extends StatefulWidget {
  const AddDepartmentView({super.key});

  @override
  State<AddDepartmentView> createState() => _AddDepartmentViewState();
}

class _AddDepartmentViewState extends State<AddDepartmentView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<AddDepartmentViewmodel>(
        context,
        listen: false,
      ).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondBackground,
      appBar: AppNavBar(),
      body: Consumer<AddDepartmentViewmodel>(
        builder: (context, vModel, child) {
          return Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "System Master",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Text(
                  "Manage organizational units structures for group-wide audits.",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.border,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Add Department",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text("Select Company"),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                initialValue: vModel.selectedCompany,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                  ),
                                ),
                                items: vModel.companyList.map((company) {
                                  return DropdownMenuItem(
                                    value: company.companyName,
                                    child:
                                    Text(company.companyName),
                                  );
                                }).toList(),
                                onChanged: vModel.setCompany,
                              ),
                              const SizedBox(height: 20),
                              const Text("Audit Department Name"),
                              const SizedBox(height: 8),
                              TextField(
                                controller:
                                vModel.auditDepartmentController,
                                decoration: InputDecoration(
                                  hintText:
                                  "Enter Audit Department Name",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              const SizedBox(height: 20),
                              const Text("Internal Department Name"),
                              const SizedBox(height: 8),
                              TextField(
                                controller:
                                vModel.internalDepartmentController,
                                decoration: InputDecoration(
                                  hintText:
                                  "Enter Internal Department Name",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: vModel.isLoading
                                      ? null
                                      : () async {
                                    await vModel.addDepartment();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Department Added Successfully"),
                                      ),
                                    );
                                  },
                                  style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor:
                                    AppColors.primary,
                                    foregroundColor:
                                    Colors.white,
                                    disabledBackgroundColor:
                                    AppColors.primary,
                                    disabledForegroundColor:
                                    Colors.white,
                                    padding:
                                    const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          4),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: 20,
                                    width: double.infinity,
                                    child: Center(
                                      child: vModel.isLoading
                                          ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child:
                                        CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                          AlwaysStoppedAnimation<
                                              Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                          : const Text(
                                        "Add Department",
                                        style: TextStyle(
                                          color:
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.border,
                            ),
                            borderRadius:
                            BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.all(24),
                                child: Text(
                                  "Department List",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.all(8.0),
                                child: Container(
                                  color:
                                  AppColors.thirdBackground,
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: const Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            "Company Name"),
                                      ),
                                      Expanded(
                                        child:
                                        Text("Audit Department Name"),
                                      ),
                                      Expanded(
                                        child:
                                        Text("Internal Department Name"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: vModel.isLoading
                                    ? const Center(
                                  child:
                                  CircularProgressIndicator(),
                                )
                                    : ListView.builder(
                                  itemCount:
                                  vModel.departmentList
                                      .length,
                                  itemBuilder:
                                      (context, index) {
                                    final e = vModel
                                        .departmentList[index];
                                    return Container(
                                      padding:
                                      const EdgeInsets
                                          .symmetric(
                                        horizontal: 30,
                                        vertical: 8,
                                      ),
                                      decoration:
                                      BoxDecoration(
                                        border: Border(
                                          bottom:
                                          BorderSide(
                                            color:
                                            AppColors
                                                .border,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              vModel.getCompanyName(
                                                e.companyId,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              e.auditDepartmentName,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              e.internalDepartmentName,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

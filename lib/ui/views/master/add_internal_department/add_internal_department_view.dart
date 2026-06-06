import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../widget/nav_bar_widget.dart';
import 'add_internal_department_viewmodel.dart';

class AddInternalDepartmentView extends StatefulWidget {
  const AddInternalDepartmentView({super.key});

  @override
  State<AddInternalDepartmentView> createState() => _AddInternalDepartmentViewState();
}

class _AddInternalDepartmentViewState extends State<AddInternalDepartmentView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<AddInternalDepartmentViewmodel>(
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
      body: Consumer<AddInternalDepartmentViewmodel>(
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
                                "Add Internal Department",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text("Select Department"),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                initialValue: vModel.selectedDepartment,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                  ),
                                ),
                                items: vModel.departmentList.map((company) {
                                  return DropdownMenuItem(
                                    value: company.departmentName,
                                    child:
                                    Text(company.departmentName),
                                  );
                                }).toList(),
                                onChanged: vModel.setDepartment,
                              ),
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
                              const SizedBox(height: 20),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: vModel.isLoading
                                      ? null
                                      : () async {
                                    await vModel.addInternalDepartment();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Internal Department Added Successfully"),
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
                                        "Add Internal Department",
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
                                  "Internal Department List",
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
                                            "Department Name"),
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
                                  vModel.internalDepartmentList
                                      .length,
                                  itemBuilder:
                                      (context, index) {
                                    final e = vModel
                                        .internalDepartmentList[index];
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
                                                e.departmentId,
                                              ),
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

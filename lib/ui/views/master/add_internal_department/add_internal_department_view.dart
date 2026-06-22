import 'package:flutter/material.dart';
import 'package:project_one/data/models/department_model.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../widget/master_button_widget.dart';
import '../../../widget/master_form_card_widget.dart';
import '../../../widget/master_page_layout_widget.dart';
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
    return Consumer<AddInternalDepartmentViewmodel>(
      builder: (context, vModel, child) {
        return MasterPageLayoutWidget(
          title: "System Master",
          subtitle:
          "Manage organizational units structures for group-wide audits.",
          formSection: MasterFormCardWidget(
            title: "Add Internal Department",
            button: MasterButtonWidget(
              text: "Add Internal Department",
              isLoading: vModel.isSaving,
              onPressed: vModel.isSaving
                  ? null
                  : () async {
                if (vModel.selectedDepartment == null) {
                  AppSnackBar.error(
                    context,
                    "Please select a department.",
                  );
                  return;
                }

                if (vModel.internalDepartmentController.text.trim().isEmpty) {
                  AppSnackBar.error(
                    context,
                    "Internal department name is required.",
                  );
                  return;
                }

                bool success = await vModel.addInternalDepartment();

                if (!context.mounted) return;

                if (success) {
                  AppSnackBar.success(
                    context,
                    "Internal Department Added Successfully.",
                  );
                } else {
                  AppSnackBar.error(
                    context,
                    "Failed to add internal department.",
                  );
                }
              },
            ),
            children: [
              const Text("Select Department"),
              const SizedBox(height: 8),

              DropdownButtonFormField<DepartmentModel>(
                isExpanded: true,
                initialValue: vModel.selectedDepartment,
                items: vModel.departmentList.map((company) {
                  return DropdownMenuItem(
                    value: company,
                    child: Text(
                      company.departmentName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: vModel.setDepartment,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Center Name"),
              const SizedBox(height: 8),

              TextField(
                controller: vModel.internalDepartmentController,
                decoration: InputDecoration(
                  hintText: "Enter Internal Department Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          listSectionBuilder: (fillAvailableSpace) {
            Widget rowBuilder(int index) {
              final e = vModel.internalDepartmentList[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(vModel.getDepartmentName(e.departmentId))),
                    Expanded(child: Text(e.internalDepartmentName)),
                  ],
                ),
              );
            }

            final listBody = vModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : fillAvailableSpace
                ? ListView.builder(
              itemCount: vModel.internalDepartmentList.length,
              itemBuilder: (context, index) => rowBuilder(index),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vModel.internalDepartmentList.length,
              itemBuilder: (context, index) => rowBuilder(index),
            );

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                fillAvailableSpace ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      "Internal Department List",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Container(
                    color: AppColors.thirdBackground,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: const Row(
                      children: [
                        Expanded(child: Text("Department Name")),
                        Expanded(child: Text("Internal Department Name")),
                      ],
                    ),
                  ),
                  fillAvailableSpace ? Expanded(child: listBody) : listBody,
                ],
              ),
            );
          },
        );
      },
    );
  }
}
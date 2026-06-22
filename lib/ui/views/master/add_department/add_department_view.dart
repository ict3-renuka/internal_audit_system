import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/company_model.dart';
import '../../../widget/master_button_widget.dart';
import '../../../widget/master_form_card_widget.dart';
import '../../../widget/master_page_layout_widget.dart';
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
    return Consumer<AddDepartmentViewmodel>(
      builder: (context, vModel, child) {
        return MasterPageLayoutWidget(
          title: "System Master",
          subtitle:
          "Manage organizational units structures for group-wide audits.",
          formSection: MasterFormCardWidget(
            title: "Add Department",
            button: MasterButtonWidget(
              text: "Add Department",
              isLoading: vModel.isSaving,
              onPressed: vModel.isSaving
                  ? null
                  : () async {
                if (vModel.selectedCompany == null) {
                  AppSnackBar.error(
                    context,
                    "Please select a company.",
                  );
                  return;
                }

                if (vModel.departmentController.text.trim().isEmpty) {
                  AppSnackBar.error(
                    context,
                    "Department name is required.",
                  );
                  return;
                }

                bool success = await vModel.addDepartment();

                if (!context.mounted) return;

                if (success) {
                  AppSnackBar.success(
                    context,
                    "Department Added Successfully.",
                  );
                } else {
                  AppSnackBar.error(
                    context,
                    "Failed to add department.",
                  );
                }
              },
            ),
            children: [
              const Text("Select Company"),
              const SizedBox(height: 8),

              DropdownButtonFormField<CompanyModel>(
                isExpanded: true,
                value: vModel.selectedCompany,
                items: vModel.companyList.map((company) {
                  return DropdownMenuItem(
                    value: company,
                    child: Text(
                      company.companyName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: vModel.setCompany,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Department Name"),
              const SizedBox(height: 8),

              TextField(
                controller: vModel.departmentController,
                decoration: InputDecoration(
                  hintText: "Enter Department Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          listSectionBuilder: (fillAvailableSpace) {
            Widget rowBuilder(int index) {
              final e = vModel.departmentList[index];
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
                    Expanded(child: Text(vModel.getCompanyName(e.companyId))),
                    Expanded(child: Text(e.departmentName)),
                  ],
                ),
              );
            }

            final listBody = vModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : fillAvailableSpace
                ? ListView.builder(
              itemCount: vModel.departmentList.length,
              itemBuilder: (context, index) => rowBuilder(index),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vModel.departmentList.length,
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
                      "Department List",
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
                        Expanded(child: Text("Company Name")),
                        Expanded(child: Text("Department Name")),
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
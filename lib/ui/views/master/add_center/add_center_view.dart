import 'package:flutter/material.dart';
import 'package:project_one/ui/widget/master_button_widget.dart';
import 'package:project_one/ui/widget/master_page_layout_widget.dart';
import 'package:provider/provider.dart';

import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/data/models/company_model.dart';

import '../../../../core/constant/utils.dart';
import '../../../widget/master_form_card_widget.dart';

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
    return Consumer<AddCenterViewmodel>(
      builder: (context, vModel, child) {
        return MasterPageLayoutWidget(
          title: "System Master",
          subtitle:
          "Manage organizational units structures for group-wide audits.",
          formSection: MasterFormCardWidget(
            title: "Add Center",
            button: MasterButtonWidget(
              text: "Add Center",
              isLoading: vModel.isLoading,
              onPressed: () async {
                if (vModel.selectedCompany == null) {
                  AppSnackBar.error(
                    context,
                    "Please select a company.",
                  );
                  return;
                }

                if (vModel.centerController.text.trim().isEmpty) {
                  AppSnackBar.error(
                    context,
                    "Center name is required.",
                  );
                  return;
                }

                bool success = await vModel.addCenter();

                if (!context.mounted) return;

                if (success) {
                  AppSnackBar.success(
                    context,
                    "Center Added Successfully.",
                  );
                } else {
                  AppSnackBar.error(
                    context,
                    "Failed to add center.",
                  );
                }
              },
            ),
            children: [
              const Text("Select Company"),
              const SizedBox(height: 8),

              DropdownButtonFormField<CompanyModel>(
                value: vModel.selectedCompany,
                items: vModel.companyList.map((company) {
                  return DropdownMenuItem(
                    value: company,
                    child: Text(company.companyName),
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

              const Text("Center Name"),
              const SizedBox(height: 8),

              TextField(
                controller: vModel.centerController,
                decoration: InputDecoration(
                  hintText: "Enter Center Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          listSection: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "Center List",
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
                      Expanded(child: Text("Center Name")),
                    ],
                  ),
                ),

                Expanded(
                  child: vModel.isLoading
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : ListView.builder(
                    itemCount: vModel.centerList.length,
                    itemBuilder: (context, index) {
                      final e = vModel.centerList[index];

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.border,
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
                              child: Text(e.centerName),
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
        );
      },
    );
  }
}
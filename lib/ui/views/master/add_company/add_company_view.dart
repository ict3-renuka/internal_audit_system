import 'package:flutter/material.dart';
import 'package:project_one/ui/widget/master_button_widget.dart';
import 'package:project_one/ui/widget/master_form_card_widget.dart';
import 'package:project_one/ui/widget/master_list_widget.dart';
import 'package:project_one/ui/widget/master_page_layout_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/utils.dart';
import '../../../../core/theme/app_colors.dart';
import 'add_company_viewmodel.dart';

class AddCompanyView extends StatefulWidget {
  const AddCompanyView({super.key});

  @override
  State<AddCompanyView> createState() => _AddCompanyViewState();
}

class _AddCompanyViewState extends State<AddCompanyView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AddCompanyViewmodel>(
        context,
        listen: false,
      ).loadCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddCompanyViewmodel>(
      builder: (context, vModel, child) {
        return MasterPageLayoutWidget(
          title: "System Master",
          subtitle:
          "Manage organizational units structures for group-wide audits.",
          formSection: MasterFormCardWidget(
            title: "Add Company",
            button: SizedBox(
              width: double.infinity,
              child: MasterButtonWidget(
                text: "Add Company",
                isLoading: vModel.isSaving,
                onPressed: vModel.isSaving
                    ? null
                    : () async {
                  if (vModel.selectedSector == null) {
                    AppSnackBar.error(
                      context,
                      "Please select a sector.",
                    );
                    return;
                  }

                  if (vModel.companyController.text.trim().isEmpty) {
                    AppSnackBar.error(
                      context,
                      "Company name is required.",
                    );
                    return;
                  }

                  bool success = await vModel.addCompany();

                  if (!context.mounted) return;

                  if (success) {
                    AppSnackBar.success(
                      context,
                      "Company Added Successfully.",
                    );
                  } else {
                    AppSnackBar.error(
                      context,
                      "Failed to add company.",
                    );
                  }
                },
              ),
            ),
            children: [
              const Text("Sector"),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: vModel.selectedSector,
                items: vModel.sectors
                    .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s),
                ))
                    .toList(),
                onChanged: vModel.setSector,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Company Name"),
              const SizedBox(height: 8),
              TextField(
                controller: vModel.companyController,
                maxLength: 100,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  hintText: "Enter company name",
                ),
              ),
            ],
          ),

          listSection: MasterListWidget(
            title: "Added Companies",
            headers: const ["Sector", "Company"],
            rows: vModel.companyList.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(e.sectorName)),
                    Expanded(child: Text(e.companyName)),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../data/models/company_model.dart';
import '../../../../data/services/api_services/company_api.dart';

class AddCompanyViewmodel extends ChangeNotifier {

  final CompanyApi companyApi;

  AddCompanyViewmodel(this.companyApi);

  final TextEditingController companyController =
  TextEditingController();

  String? selectedSector;

  bool isLoading = false;

  final List<String> sectors = [
    "Agri",
    "FMCG",
  ];

  void setSector(String? value) {
    selectedSector = value;
    notifyListeners();
  }

  Future<void> addCompany() async {

    if (selectedSector == null ||
        companyController.text.trim().isEmpty) {
      return;
    }

    isLoading = true;
    notifyListeners();

    int sectorId = selectedSector == "Agri" ? 1 : 2;

    CompanyModel company = CompanyModel(
      sectorId: sectorId,
      companyId: 0,
      companyName: companyController.text.trim(),
    );

    await companyApi.addCompany(company);

    companyController.clear();
    selectedSector = null;

    isLoading = false;
    notifyListeners();
  }
}
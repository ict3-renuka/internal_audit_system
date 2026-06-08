import 'package:flutter/material.dart';
import '../../../../data/models/company_model.dart';
import '../../../../data/services/api_services/company_api.dart';

class AddCompanyViewmodel extends ChangeNotifier {

  final CompanyApi companyApi;

  AddCompanyViewmodel(this.companyApi);

  final TextEditingController companyController = TextEditingController();
  String? selectedSector;
  bool isLoading = false;
  bool isSaving = false;

  List<CompanyModel> companyList = [];

  final List<String> sectors = ["Agri", "FMCG",];

  final Map<String, int> sectorMap = {
    "Agri": 1,
    "FMCG": 2,
  };

  Future<void> loadCompanies() async {

    isLoading = true;
    notifyListeners();

    companyList = await companyApi.getCompanyList();
    isLoading = false;
    notifyListeners();
  }

  void setSector(String? value) {
    selectedSector = value;
    notifyListeners();
  }

  Future<bool> addCompany() async {
    if (selectedSector == null ||
        companyController.text.trim().isEmpty) {
      return false;
    }

    isSaving = true;
    notifyListeners();

    try {
      final sectorId = sectorMap[selectedSector!];

      if (sectorId == null) return false;

      CompanyModel company = CompanyModel(
        sectorId: sectorId,
        sectorName: selectedSector!,
        companyName: companyController.text.trim(),
      );

      await companyApi.addCompany(company);

      companyController.clear();
      selectedSector = null;

      await loadCompanies();

      return true;

    } catch (e) {
      print("ViewModel Error: $e");
      return false;

    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
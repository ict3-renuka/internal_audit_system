import 'package:flutter/material.dart';
import 'package:project_one/data/models/center_model.dart';
import 'package:project_one/data/services/api_services/center_api.dart';
import 'package:project_one/data/services/api_services/company_api.dart';

import '../../../../data/models/company_model.dart';

class AddCenterViewmodel extends ChangeNotifier {

  final CenterApi centerApi;
  final CompanyApi companyApi;

  AddCenterViewmodel(this.centerApi,this.companyApi);

  final TextEditingController centerController = TextEditingController();

  CompanyModel? selectedCompany;

  bool isLoading = false;
  bool isSaving = false;
  bool isDuplicate = false;

  List<CenterModel> centerList = [];
  List<CompanyModel> companyList = [];

  void setCompany(CompanyModel? value) {
    selectedCompany = value;
    notifyListeners();
  }

  Future<void> loadData() async {

    isLoading = true;
    notifyListeners();

    centerList = await centerApi.getCenterList();
    companyList = await companyApi.getCompanyList();

    isLoading = false;
    notifyListeners();
  }

  String getCompanyName(int id) {
    return companyList
        .firstWhere(
          (e) => e.companyId == id,
      orElse: () => CompanyModel(
          companyId: 0,
          sectorId: 1,
          sectorName: "",
          companyName: ""
      ),
    ).companyName;
  }

  Future<bool> addCenter() async {
    if (selectedCompany == null ||
        centerController.text.trim().isEmpty) {
      return false;
    }

    try {
      isSaving = true;
      notifyListeners();

      final newCenterName = centerController.text.trim().toLowerCase();

      isDuplicate = centerList.any((c) =>
      c.centerName.trim().toLowerCase() == newCenterName &&
          c.companyId == selectedCompany!.companyId!);

      if (isDuplicate) {
        return false;
      }

      CenterModel center = CenterModel(
        companyId: selectedCompany!.companyId!,
        centerName: centerController.text.trim(),
      );

      await centerApi.addCenter(center);

      centerController.clear();
      selectedCompany = null;

      await loadData();

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
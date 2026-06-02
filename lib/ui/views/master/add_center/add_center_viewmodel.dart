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

  String? selectedCompany;

  bool isLoading = false;

  List<CenterModel> centerList = [];
  List<CompanyModel> companyList = [];

  final List<String> sectors = [
    "RDL",
    "SWCL",
  ];

  void setCompany(String? value) {
    selectedCompany = value;
    notifyListeners();
  }

  Future<void> loadData() async {

    isLoading = true;
    notifyListeners();

    centerList = await centerApi.getCenters();
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

  Future<void> addCenter() async {

    if (selectedCompany == null ||
        centerController.text.trim().isEmpty) {
      return;
    }

    isLoading = true;
    notifyListeners();

    int companyId = selectedCompany == "RDL" ? 1 : 2;

    CenterModel center = CenterModel(
      companyId: companyId,
      centerName: centerController.text.trim(),
    );

    await centerApi.addCenter(center);
    centerList = await centerApi.getCenters();

    centerController.clear();
    selectedCompany = null;

    isLoading = false;
    notifyListeners();
  }
}
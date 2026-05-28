import 'package:flutter/material.dart';
import 'package:project_one/data/models/center_model.dart';
import 'package:project_one/data/services/api_services/center_api.dart';

class AddCenterViewmodel extends ChangeNotifier {

  final CenterApi centerApi;

  AddCenterViewmodel(this.centerApi);

  final TextEditingController centerController = TextEditingController();

  String? selectedCompany;

  bool isLoading = false;

  final List<String> sectors = [
    "RDL",
    "SWCL",
  ];

  void setCompany(String? value) {
    selectedCompany = value;
    notifyListeners();
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
      centerId: 0,
      centerName: centerController.text.trim(),
    );

    await centerApi.addCenter(center);

    centerController.clear();
    selectedCompany = null;

    isLoading = false;
    notifyListeners();
  }
}
import '../../models/company_model.dart';

class CompanyApi {

  Future<void> addCompany(CompanyModel company) async {

    print(company.toJson());

    await Future.delayed(
      const Duration(seconds: 1),
    );
  }

  Future<List<CompanyModel>> getCompanyList() async {

    await Future.delayed(const Duration(seconds: 1));

    return [
      CompanyModel(
        sectorId: 1,
        sectorName: "Agri",
        companyId: 1,
        companyName: "ABC Company",
      ),
      CompanyModel(
        sectorId: 2,
        sectorName: "FMCG",
        companyId: 2,
        companyName: "XYZ Company",
      ),
    ];
  }
}
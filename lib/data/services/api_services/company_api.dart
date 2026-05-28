import '../../models/company_model.dart';

class CompanyApi {

  Future<void> addCompany(CompanyModel company) async {

    print(company.toJson());

    await Future.delayed(
      const Duration(seconds: 1),
    );
  }
}
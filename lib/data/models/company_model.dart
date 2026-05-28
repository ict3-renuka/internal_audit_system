class CompanyModel {
  final int sectorId;
  final int companyId;
  final String companyName;

  CompanyModel({
    required this.sectorId,
    required this.companyId,
    required this.companyName,
  });

  Map<String, dynamic> toJson() {
    return {
      "sector_id": sectorId,
      "company_id": companyId,
      "company_name": companyName,
    };
  }
}
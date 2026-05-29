class CompanyModel {
  final int sectorId;
  final int companyId;
  final String companyName;

  CompanyModel({
    required this.sectorId,
    required this.companyId,
    required this.companyName,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      sectorId: json["sector_id"],
      companyId: json["company_id"],
      companyName: json["company_name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sector_id": sectorId,
      "company_id": companyId,
      "company_name": companyName,
    };
  }
}
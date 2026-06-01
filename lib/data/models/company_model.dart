class CompanyModel {
  final int sectorId;
  final String sectorName;
  final int? companyId;
  final String companyName;

  CompanyModel({
    required this.sectorId,
    required this.sectorName,
    this.companyId,
    required this.companyName,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      sectorId: json["sector_id"],
      sectorName: json["sector_name"],
      companyId: json["company_id"],
      companyName: json["company_name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sector_id": sectorId,
      "sector_name": sectorName,
      "company_name": companyName,
    };
  }
}
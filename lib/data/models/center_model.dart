class CenterModel {
  final int companyId;
  final int centerId;
  final String centerName;

  CenterModel({
    required this.companyId,
    required this.centerId,
    required this.centerName,
  });

  Map<String, dynamic> toJson() {
    return {
      "company_id": companyId,
      "center_id": centerId,
      "center_name": centerName,
    };
  }
}
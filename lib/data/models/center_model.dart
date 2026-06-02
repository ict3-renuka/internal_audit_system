class CenterModel {
  final int companyId;
  final int? centerId;
  final String centerName;

  CenterModel({
    required this.companyId,
    this.centerId,
    required this.centerName,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      companyId: json["company_id"],
      centerId: json["center_id"],
      centerName: json["center_name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "company_id": companyId,
      "center_name": centerName,
    };
  }
}
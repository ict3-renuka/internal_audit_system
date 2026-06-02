import 'package:project_one/data/models/center_model.dart';

class CenterApi {

  Future<void> addCenter(CenterModel center) async {

    print(center.toJson());

    await Future.delayed(
      const Duration(seconds: 1),
    );
  }

  Future<List<CenterModel>> getCenters() async {

    await Future.delayed(const Duration(seconds: 1));

    return [
      CenterModel(centerId: 1, companyId: 1, centerName: "Colombo Center"),
      CenterModel(centerId: 2, companyId: 2, centerName: "Kandy Center"),
    ];
  }
}
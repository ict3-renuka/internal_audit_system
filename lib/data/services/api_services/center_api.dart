import 'package:project_one/data/models/center_model.dart';

class CenterApi {

  Future<void> addCenter(CenterModel center) async {

    print(center.toJson());

    await Future.delayed(
      const Duration(seconds: 1),
    );
  }
}
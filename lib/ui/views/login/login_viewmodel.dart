import 'package:flutter/cupertino.dart';
import 'package:project_one/data/services/api_services/user_api.dart';

import '../../../data/models/user_model.dart';
import '../../../data/services/session_service.dart';

class LoginViewmodel extends ChangeNotifier{
  final UserApi userApi;
  UserModel? currentUser;

  LoginViewmodel(this.userApi);

  bool isLoading = false;
  String? errorMsg;

  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMsg = null;
    notifyListeners();

    try {
      currentUser = await userApi.login(username, password);

      await SessionService.saveUser(currentUser!);

      isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      errorMsg = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
import 'package:flutter/cupertino.dart';
import 'package:project_one/data/services/api_services/user_api.dart';

import '../../../data/models/user_model.dart';
import '../../../data/services/session_service.dart';

class LoginViewmodel extends ChangeNotifier{
  final UserApi userApi;
  UserModel? currentUser;

  LoginViewmodel(this.userApi);

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMsg;

  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> login() async {
    isLoading = true;
    errorMsg = null;
    notifyListeners();

    try {
      if (userNameController.text.trim().isEmpty) {
        errorMsg = "Username is required";
        isLoading = false;
        notifyListeners();
        return false;
      }

      if (passwordController.text.isEmpty) {
        errorMsg = "Password is required";
        isLoading = false;
        notifyListeners();
        return false;
      }

      currentUser = await userApi.login(userNameController.text.trim(), passwordController.text);

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

  @override
  void dispose() {
  userNameController.dispose();
  passwordController.dispose();
  super.dispose();
  }
}
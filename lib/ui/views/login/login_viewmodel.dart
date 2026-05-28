import 'package:flutter/cupertino.dart';
import 'package:project_one/data/services/api_services/login_api.dart';

class LoginViewmodel extends ChangeNotifier{
  final LoginApi loginApi;

  LoginViewmodel(this.loginApi);

  bool isLoading = false;
  String? errorMsg;

  Future<bool> login(String email, String password) async{
    try{
      isLoading = true;
      errorMsg = null;
      notifyListeners();

      await loginApi.login(email, password);

      isLoading = false;
      notifyListeners();

      return true;
    }catch (e){
      isLoading = false;
      errorMsg = e.toString();
      notifyListeners();

      return false;
    }
  }
}
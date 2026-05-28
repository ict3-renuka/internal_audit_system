import 'package:project_one/data/models/user_model.dart';

class LoginApi {
  Future<UserModel> login(String email, String password) async{
    await Future.delayed(Duration(seconds: 2));

    if(email == "admin@gmail.com" && password == "12345"){
      return UserModel(email: email, password: password);
    }else{
      throw Exception("Invalid credentials");
    }
  }
}
import 'package:flutter/material.dart';
import 'package:project_one/ui/views/login/login_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<LoginViewmodel>(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width:width*0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login", style: TextStyle(fontSize: 28, color: Colors.green)),

              SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),

              SizedBox(height: 10),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),

              SizedBox(height: 20),

              vModel.isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () async {
                  bool success = await vModel.login(
                    emailController.text,
                    passwordController.text,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Login Success")),
                    );

                    Navigator.pushReplacementNamed(context, "/home");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(vModel.errorMsg ?? "Error")),
                    );
                  }
                },
                child: Text("Login",style: TextStyle(color: Colors.green),),
              ),

              if (vModel.errorMsg != null)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    vModel.errorMsg!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
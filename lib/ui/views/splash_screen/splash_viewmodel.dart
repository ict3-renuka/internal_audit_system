import 'package:flutter/material.dart';
import '../../../data/services/session_service.dart';

class SplashViewModel extends ChangeNotifier {

  Future<void> checkSession(BuildContext context) async {

    await Future.delayed(const Duration(seconds: 1));

    final user = await SessionService.getUser();

    if (!context.mounted) return;

    if (user == null) {
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }
}
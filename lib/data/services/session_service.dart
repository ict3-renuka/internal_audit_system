import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class SessionService {

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("user_id", user.userId);
    await prefs.setString("name", user.name);
    await prefs.setString("user_name", user.userName);
    await prefs.setString("designation", user.designation);
    await prefs.setString("email", user.email!);
    await prefs.setInt("internal_department_id", user.internalDepartmentId);
    await prefs.setBool("is_login", true);
    await prefs.setString("login_time", DateTime.now().toIso8601String(),);
  }

  static Future<UserModel?> getUser() async {
    final valid = await isSessionValid();
    if (!valid) return null;

    final prefs = await SharedPreferences.getInstance();

    return UserModel(
      userId: prefs.getInt("user_id") ?? 0,
      name: prefs.getString("name") ?? "",
      userName: prefs.getString("user_name") ?? "",
      designation: prefs.getString("designation") ?? "",
      email: prefs.getString("email") ?? "",
      internalDepartmentId: prefs.getInt("internal_department_id") ?? 0,
      isActive: true,
    );
  }

  static Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();

    final loginTimeString = prefs.getString("login_time");

    if (loginTimeString == null) return false;

    final loginTime = DateTime.parse(loginTimeString);

    final now = DateTime.now();

    if (now.difference(loginTime).inHours >= 24) {
      await clear();
      return false;
    }

    return prefs.getBool("is_login") ?? false;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
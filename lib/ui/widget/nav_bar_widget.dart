import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/data/models/internal_department_model.dart';
import 'package:project_one/data/services/api_services/internal_department_api.dart';

import '../../data/services/session_service.dart';

class AppNavBar extends StatefulWidget implements PreferredSizeWidget {
  const AppNavBar({super.key});

  @override
  State<AppNavBar> createState() => _AppNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _AppNavBarState extends State<AppNavBar> {
  String?   userName;
  String? name;
  String? designation;
  String? email;
  String? internalDeptName;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await SessionService.getUser();
    if (user == null) return;
    String deptName = "";
    try {
      final departments = await InternalDepartmentApi().getInternalDepartment();
      final match = departments.firstWhere(
            (d) => d.internalDepartmentId == user.internalDepartmentId,
        orElse: () => InternalDepartmentModel(
          departmentId: 0,
          internalDepartmentName: "",
        ),
      );
      deptName = match.internalDepartmentName;
    } catch (_) {}

    setState(() {
      userName = user.userName;
      name = user.name;
      designation = user.designation;
      email = user.email;
      internalDeptName = deptName;
    });
  }

  bool get isAdmin => userName?.toLowerCase() == "admin";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          const Text(
            "Internal Audit System",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (isAdmin)
                    _buildDropdownMenu(context, "Master", [
                      "Add Company",
                      "Add Center",
                      "Add Department",
                      "Add Internal Department",
                    ]),

                  if (isAdmin)
                    _buildDropdownMenu(context, "Audit Requests", [
                      "New Audit Request",
                      "Edit Audit Request",
                    ]),

                  _buildDropdownMenu(context, "Draft Observation", [
                    if (isAdmin) "New Draft Observation",
                    "Edit Draft Observation",
                  ]),

                  _buildDropdownMenu(context, "Report", [
                    "Observation Report",
                    "Audit Request Report"
                  ]),
                ],
              ),
            ),
          ),

          const SizedBox(width: 20),

          PopupMenuButton(
            offset: const Offset(-160, 50),
            color: Colors.white,
            elevation: 4,
            constraints: const BoxConstraints(minWidth: 240),
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: false,
                padding: EdgeInsets.zero,
                child: _ProfilePopup(
                  name: name ?? "",
                  userName: userName ?? "",
                  designation: designation ?? "",
                  email: email ?? "",
                  internalDeptName: internalDeptName ?? "",
                ),
              ),
            ],
            child: Row(
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 6),
                Text(
                  name ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownMenu(
      BuildContext context,
      String title,
      List<String> items,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 45),
        color: AppColors.textLight,
        onSelected: (value) {
          if (value == "Add Company") Navigator.pushNamed(context, "/add-company");
          if (value == "Add Center") Navigator.pushNamed(context, "/add-center");
          if (value == "Add Department") Navigator.pushNamed(context, "/add-department");
          if (value == "Add Internal Department") Navigator.pushNamed(context, "/add-internal-department");
          if (value == "New Audit Request") Navigator.pushNamed(context, "/new-audit-request");
          if (value == "Edit Audit Request") Navigator.pushNamed(context, "/edit-audit-request");
          if (value == "New Draft Observation") Navigator.pushNamed(context, "/new-draft-observation");
          if (value == "Edit Draft Observation") Navigator.pushNamed(context, "/edit-draft-observation");
          if (value == "Observation Report") Navigator.pushNamed(context, "/observation-report");
          if (value == "Audit Request Report") Navigator.pushNamed(context, "/audit-request-report");
        },
        itemBuilder: (context) => items
            .map((e) => PopupMenuItem<String>(
          value: e,
          child: Text(e, style: const TextStyle(color: Colors.white)),
        ))
            .toList(),
        child: Row(
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _ProfilePopup extends StatelessWidget {
  final String name;
  final String userName;
  final String designation;
  final String email;
  final String internalDeptName;

  const _ProfilePopup({
    required this.name,
    required this.userName,
    required this.designation,
    required this.email,
    required this.internalDeptName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Icon(Icons.person, color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "@$userName",
                      style: const TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          _InfoRow(icon: Icons.badge_outlined, label: "Designation", value: designation),
          const Divider(height: 20),
          _InfoRow(icon: Icons.email, label: "Email", value: email),
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.apartment_outlined, label: "Internal Department", value: internalDeptName),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45)),
              Text(
                value.isEmpty ? "—" : value,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
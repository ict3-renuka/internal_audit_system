import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  const AppNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

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
          const SizedBox(width: 50),

          _buildDropdownMenu(context, "Master", [
            "Add Company",
            "Add Center",
            "Add Department"
          ]),

          _buildDropdownMenu(context, "Audit Requests", [
            "New Audit Request",
            "Edit Audit Request",
          ]),

          _buildDropdownMenu(context, "Draft Observation", [
            "New Draft Observation",
            "Edit Draft Observation",
          ]),

          const Spacer(),
          const Icon(
            Icons.account_circle_outlined,
            color: Colors.white,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/add-company");
        },
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
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
          if (value == "Add Company") {
            Navigator.pushNamed(context, "/add-company");
          }
          if (value == "Add Center") {
            Navigator.pushNamed(context, "/add-center");
          }
          if (value == "New Audit Request") {
            Navigator.pushNamed(context, "/new-audit-request");
          }
          if (value == "Edit Audit Request") {
            Navigator.pushNamed(context, "/edit-audit-request");
          }
          if (value == "New Draft Observation") {
            Navigator.pushNamed(context, "/new-draft-observation");
          }
          if (value == "Edit Draft Observation") {
            Navigator.pushNamed(context, "/edit-draft-observation");
          }
        },
        itemBuilder: (context) {
          return items
              .map(
                (e) => PopupMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
              .toList();
        },
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
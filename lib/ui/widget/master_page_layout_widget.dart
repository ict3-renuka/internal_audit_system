import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/ui/widget/nav_bar_widget.dart';

class MasterPageLayoutWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget formSection;
  final Widget listSection;

  const MasterPageLayoutWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.formSection,
    required this.listSection,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondBackground,
      appBar: AppNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: formSection),
                  const SizedBox(width: 24),
                  Expanded(child: listSection),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
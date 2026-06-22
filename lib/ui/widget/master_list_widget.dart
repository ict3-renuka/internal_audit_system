import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';

class MasterListWidget extends StatelessWidget {
  final String title;
  final List<String> headers;
  final List<Widget> rows;
  final bool fillAvailableSpace;

  const MasterListWidget({
    super.key,
    required this.title,
    required this.headers,
    required this.rows,
    this.fillAvailableSpace = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: fillAvailableSpace ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          Container(
            color: AppColors.thirdBackground,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: headers.map((h) => Expanded(child: Text(h))).toList(),
            ),
          ),
          fillAvailableSpace
              ? Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) => rows[index],
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows.length,
            itemBuilder: (context, index) => rows[index],
          ),
        ],
      ),
    );
  }
}
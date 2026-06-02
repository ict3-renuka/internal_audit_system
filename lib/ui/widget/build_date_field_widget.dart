import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

Widget buildDateField({
  required BuildContext context,
  required String label,
  required DateTime? value,
  required Function(DateTime) onSelect,
  bool disableFutureDates = false,
}) {
  return InkWell(
    onTap: () async {
      final now = DateTime.now();

      final pickedDate = await showDatePicker(
        context: context,
        initialDate: value ?? now,
        firstDate: DateTime(2000),
        lastDate: disableFutureDates ? now : DateTime(2100),
      );

      if (pickedDate != null) {
        onSelect(pickedDate);
      }
    },
    child: InputDecorator(
      decoration: InputDecoration(
        hintText: label,
        suffixIcon: const Icon(
          Icons.calendar_month_outlined,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Text(
        value == null
            ? label
            : "${value.day.toString().padLeft(2, '0')}/"
            "${value.month.toString().padLeft(2, '0')}/"
            "${value.year}",
        style: TextStyle(
          color: value == null
              ? Colors.black45
              : Colors.black87,
        ),
      ),
    ),
  );
}
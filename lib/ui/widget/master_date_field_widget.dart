import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class MasterDateFieldWidget extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onSelect;
  final bool disableFutureDates;

  const MasterDateFieldWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onSelect,
    this.disableFutureDates = false,
  });

  Future<void> _pickDate(BuildContext context) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickDate(context),
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
                  : "${value!.day.toString().padLeft(2, '0')}/"
                  "${value!.month.toString().padLeft(2, '0')}/"
                  "${value!.year}",
              style: TextStyle(
                color: value == null
                    ? Colors.black45
                    : Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/data/models/draft_observation_model.dart';
import 'package:project_one/ui/widget/nav_bar_widget.dart';
import 'package:provider/provider.dart';

import 'draft_observation_view_model.dart';

class DraftObservationView extends StatefulWidget {
  final DraftObservationModel? draftObservation;
  const DraftObservationView({super.key,this.draftObservation,});

  @override
  State<DraftObservationView> createState() => _DraftObservationViewState();
}

class _DraftObservationViewState extends State<DraftObservationView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (widget.draftObservation != null) {
        Provider.of<DraftObservationViewmodel>(
          context,
          listen: false,
        ).loadDraftObservation(
          widget.draftObservation!,
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<DraftObservationViewmodel>(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondBackground,
      appBar: AppNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 100,
          vertical: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Draft Observation",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Initialize a new audit engagement by providing meeting details and firm contact information.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.border,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Meeting Details",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Meeting Date",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDateField(
                              context: context,
                              label: "Meeting Date",
                              value: vModel.remarkedDate,
                              onSelect: vModel.setRemarkedDate,
                              disableFutureDates: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: vModel.detailsController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText:
                      "Enter detailed scope and context for this audit request...",
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color(0xFFD8DADC),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.border,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.business_center_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Audit Firm Contact",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Audit Firm Person ID",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.responsibleUserIdController,
                              keyboardType:
                              TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "ID-0000-X",
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Audit Firm Person Name",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller:
                              vModel.riskAndRootCauseController,
                              decoration: InputDecoration(
                                hintText:
                                "Full Legal Name",
                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: vModel.isLoading
                          ? null
                          : () async {
                        await vModel.addDraftObservation();

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Audit Request Added Successfully",
                            ),
                          ),
                        );
                      },
                      icon: vModel.isLoading
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        "Add Audit Request",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF002D62),
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 24,
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? value,
    required Function(DateTime) onSelect,
    bool disableFutureDates = false,
  }) {
    return InkWell(
      onTap: () async {
        DateTime now = DateTime.now();

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(2000),
          lastDate: disableFutureDates
              ? now
              : DateTime(2100),
        );

        if (pickedDate != null) {
          onSelect(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: "Select Date",
          suffixIcon: const Icon(
            Icons.calendar_month_outlined,
          ),
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: Color(0xFFD8DADC),
            ),
          ),
        ),
        child: Text(
          value == null
              ? "Select Date"
              : value.toString().split(" ")[0],
          style: TextStyle(
            color: value == null
                ? Colors.black45
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}

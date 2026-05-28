import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'audit_request_view_model.dart';

class AuditRequestView extends StatelessWidget {
  const AuditRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<AuditRequestViewmodel>(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F9),
      appBar: AppBar(
        title: const Text("New Audit Request"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: width * 0.25,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Create Audit Request",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 30),
                _buildDateField(
                  context: context,
                  label: "Meeting Date",
                  value: vModel.meetingDate,
                  onSelect: vModel.setMeetingDate,
                  disableFutureDates: true,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: vModel.descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildDateField(
                  context: context,
                  label: "Preliminary Start Date",
                  value: vModel.preliminaryStartDate,
                  onSelect: vModel.setPreliminaryStartDate,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: vModel.personIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Audit Firm Person ID",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: vModel.personNameController,
                  decoration: InputDecoration(
                    labelText: "Audit Firm Person Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: vModel.isLoading
                        ? null
                        : () async {
                            await vModel.addAuditRequest();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Audit Request Added Successfully",
                                ),
                              ),
                            );
                          },
                    child: vModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Add Audit Request",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
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
          initialDate: now,
          firstDate: DateTime(2000),
          lastDate: disableFutureDates ? now : DateTime(2100),
        );
        if (pickedDate != null) {
          onSelect(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          value == null ? "Select Date" : value.toString().split(" ")[0],
        ),
      ),
    );
  }
}

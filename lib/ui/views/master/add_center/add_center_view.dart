import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_center_viewmodel.dart';

class AddCenterView extends StatelessWidget {
  const AddCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<AddCenterViewmodel>(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F9),

      appBar: AppBar(
        title: const Text("Add Center"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
          ),
        ),
      ),

      body: Center(
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
                "Add Center",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 30),

              DropdownButtonFormField<String>(
                initialValue: vModel.selectedCompany,

                decoration: InputDecoration(
                  labelText: "Select Company",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                items: vModel.sectors.map((sector) {
                  return DropdownMenuItem(value: sector, child: Text(sector));
                }).toList(),

                onChanged: vModel.setCompany,
              ),

              const SizedBox(height: 20),

              TextField(
                controller: vModel.centerController,

                decoration: InputDecoration(
                  labelText: "Center Name",

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
                    await vModel.addCenter();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Center Added Successfully"),
                      ),
                    );
                  },

                  child: vModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Add Center",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

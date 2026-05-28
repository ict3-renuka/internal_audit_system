import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_company_viewmodel.dart';

class AddCompanyView extends StatelessWidget {
  const AddCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<AddCompanyViewmodel>(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F9),

      appBar: AppBar(
        title: const Text("Add Company"),
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
                "Add Company",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 30),

              DropdownButtonFormField<String>(
                initialValue: vModel.selectedSector,

                decoration: InputDecoration(
                  labelText: "Select Sector",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                items: vModel.sectors.map((sector) {
                  return DropdownMenuItem(value: sector, child: Text(sector));
                }).toList(),

                onChanged: vModel.setSector,
              ),

              const SizedBox(height: 20),

              TextField(
                controller: vModel.companyController,

                decoration: InputDecoration(
                  labelText: "Company Name",

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
                          await vModel.addCompany();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Company Added Successfully"),
                            ),
                          );
                        },

                  child: vModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Add Company",
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

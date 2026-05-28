import 'dart:async';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedMenu = "Home";

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> images = [
    "assets/images/audit_image_1.jpg",
    "assets/images/audit_image_2.jpg",
    "assets/images/audit_image_3.jpg",
  ];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      _currentPage++;

      if (_currentPage >= images.length) {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: width * 0.05,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.blue],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Internal Audit System",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: [
                    _buildDropdownMenu("Master",[
                      "Add Company",
                      "Add Center"
                    ]),
                    _buildDropdownMenu("Audit Requests", [
                      "New",
                      "Search",
                    ]),
                    _buildMenu("Draft Observation"),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE8F5E9), Color(0xFFE3F2FD)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: width * 0.2,
                    width: width * 0.4,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(images[index]),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Welcome to Internal Audit System",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Manage audits, reports and compliance efficiently",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/add-company");
        },
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildDropdownMenu(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 40),
        color: Colors.white,
        child: Row(
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
        onSelected: (value) {
          if (value == "Add Company") {
            Navigator.pushNamed(context, "/add-company");
          }
          if (value == "Add Center") {
            Navigator.pushNamed(context, "/add-center");
          }
          if (value == "New") {
            Navigator.pushNamed(context, "/new-audit-request");
          }
        },
        itemBuilder: (context) {
          return items
              .map((e) => PopupMenuItem(value: e, child: Text(e)))
              .toList();
        },
      ),
    );
  }
}
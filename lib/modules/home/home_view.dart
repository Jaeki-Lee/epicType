import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Epic Type'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings page
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Choose a category to start practicing.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildCategoryTile(
                  "Famous Speeches",
                  "Iconic words from history.",
                  Icons.translate,
                ),
                _buildCategoryTile(
                  "Classic Novels",
                  "Excerpts from timeless literature.",
                  Icons.menu_book,
                ),
                _buildCategoryTile(
                  "Proverbs & Sayings",
                  "Wise and memorable phrases.",
                  Icons.format_quote,
                ),
                _buildCategoryTile(
                  "Poetry Corner",
                  "Type verses from new and classic poems.",
                  Icons.edit,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.shuffle),
              label: const Text("Start Random Practice"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onPressed: () {
                // TODO: Implement random practice
              },
            ),
          ),
        ],
      ),
    );

    throw UnimplementedError();
  }

  Widget _buildCategoryTile(String title, String subtitle, IconData icon) {
    return GestureDetector(
      onTap: () => controller.selectCategory(title),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(20),
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

import 'package:get/get.dart';

class HomeController extends GetxController {
  final selectedCategory = "".obs;

  void selectCategory(String category) {
    selectedCategory.value = category;
    Get.toNamed('/practice', arguments: category);
  }

  void startRandomPractice() {
    Get.toNamed('/practice', arguments: 'random');
  }
}

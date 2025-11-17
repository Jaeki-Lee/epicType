import 'package:epic_type/modules/home/home_binding.dart';
import 'package:epic_type/modules/practice/practice_view.dart';
import 'package:epic_type/modules/practice/practice_controller.dart';
import 'package:get/get.dart';
import '../modules/home/home_controller.dart';
import '../modules/home/home_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/home',
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/practice',
      page: () => const PracticeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PracticeController>(() => PracticeController());
      }),
    ),
  ];
}

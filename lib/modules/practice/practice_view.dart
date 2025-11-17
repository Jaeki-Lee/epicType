import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'practice_controller.dart';

class PracticeView extends StatefulWidget {
  const PracticeView({super.key});

  @override
  State<PracticeView> createState() => _PracticeViewState();
}

class _PracticeViewState extends State<PracticeView> {
  final inputController = TextEditingController();
  final inputFocusNode = FocusNode();

  final PracticeController controller = Get.find<PracticeController>();

  @override
  void initState() {
    super.initState();

    // 자동으로 키보드 focus
    Future.delayed(const Duration(microseconds: 100), () {
      FocusScope.of(context).requestFocus(inputFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            // title: Obx(() => Text(controller.categoryTitle)),
            title: const Text("Epic Type"),
            centerTitle: true,
            actions: [
              IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 24.0),
                Obx(() {
                  // RxList 의존성 명시적으로 건드리기
                  final spans = controller.charSpans; // <- 이 한 줄로 Obx가 변화를 추적
                  return RichText(
                    text: TextSpan(
                      // 부모 스타일에서 color는 빼고 size만
                      style: const TextStyle(fontSize: 20),
                      children: spans.toList(), // <- toList()로 안전하게 전달
                    ),
                  );
                }),
                const SizedBox(height: 12.0),
                const Text(
                  "사느냐 죽느냐 그것이 문제로다.",
                  style: TextStyle(color: Colors.grey),
                ),
                const Text(
                  "Hamlet, William Shakespeare",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 32.0),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStat("WPM", controller.wpm.value.toString()),
                      const SizedBox(width: 32),
                      _buildStat("Accuracy", "${controller.accuracy.value}%"),
                    ],
                  ),
                ),
                const Spacer(),
                Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: inputController,
                    focusNode: inputFocusNode,
                    onChanged: controller.onType,
                    autofocus: true,
                    showCursor: false,
                    enableInteractiveSelection: false,
                    decoration: const InputDecoration.collapsed(hintText: ""),
                    keyboardType: TextInputType.text,
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    controller.nextSentence();
                    inputController.clear();
                    FocusScope.of(context).requestFocus(inputFocusNode);
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Next Sentence"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF137fec),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

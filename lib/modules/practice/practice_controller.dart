import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class PracticeController extends GetxController {
  final sentence = "To be, or not to be, that is the question.".obs;
  final typed = "".obs;
  final charSpans = RxList<TextSpan>([]);

  final wpm = 0.obs;
  final accuracy = 100.obs;

  DateTime? startTime;
  Timer? timer;

  // ===== Helper: 필수 비교 문자 판단 (영문/숫자/스페이스만) =====
  bool _isRequiredChar(String ch) {
    // 한 글자 보장 전제
    final code = ch.codeUnitAt(0);
    final isLetter =
        (code >= 65 && code <= 90) || (code >= 97 && code <= 122); // A-Z, a-z
    final isDigit = (code >= 48 && code <= 57); // 0-9
    final isSpace = (code == 32);
    return isLetter || isDigit || isSpace;
  }

  // ===== Helper: 사용자 입력에서 특수문자 제거(스페이스는 유지) =====
  String _filterInputKeepSpace(String s) {
    final buf = StringBuffer();
    for (final rune in s.runes) {
      final ch = String.fromCharCode(rune);
      if (_isRequiredChar(ch)) {
        buf.write(ch);
      }
      // 특수문자는 그냥 스킵
    }
    return buf.toString();
  }

  @override
  void onInit() {
    super.onInit();
    _updateCharSpans(); // 최초 문장 표시
  }

  void onType(String input) {
    if (startTime == null) {
      startTime = DateTime.now();
      _startTimer();
    }
    typed.value = input;
    _updateCharSpans();
    _calculateAccuracy();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateWPM();
    });
  }

  void _calculateWPM() {
    if (startTime == null) return;
    final minutes =
        DateTime.now().difference(startTime!).inMilliseconds / 60000.0;
    // WPM: 필수 문자만 센 입력 길이를 5자로 나눔 (표준)
    final filtered = _filterInputKeepSpace(typed.value);
    final words = filtered.length / 5.0;
    wpm.value = minutes > 0 ? (words / minutes).round() : 0;
  }

  void _calculateAccuracy() {
    final target = sentence.value;
    final filtered = _filterInputKeepSpace(typed.value);

    int requiredTyped = 0; // 사용자가 실제로 비교에 참여한 수(=필수문자에 대해 소비된 입력 수)
    int correct = 0;

    int j = 0; // filtered 인덱스
    for (int i = 0; i < target.length; i++) {
      final t = target[i];
      if (_isRequiredChar(t)) {
        if (j < filtered.length) {
          final match = t.toLowerCase() == filtered[j].toLowerCase();
          if (match) correct++;
          requiredTyped++;
          j++;
        } else {
          // 아직 이 필수문자에 도달 못함
          break;
        }
      }
    }

    // 아직 아무것도 치지 않았으면 100으로 유지
    accuracy.value = requiredTyped == 0
        ? 100
        : ((correct / requiredTyped) * 100).round();
  }

  void _updateCharSpans() {
    final target = sentence.value;
    final inputFiltered = _filterInputKeepSpace(typed.value);

    final List<TextSpan> spans = [];
    int j = 0; // inputFiltered 소비 인덱스
    int nextCompareIndex = -1; // "현재" 커서 표시용(다음에 비교해야 할 타겟 필수문자 위치)

    // 먼저 nextCompareIndex를 계산 (첫 번째 미입력 필수문자 위치)
    for (int i = 0; i < target.length; i++) {
      final t = target[i];
      if (_isRequiredChar(t)) {
        if (j < inputFiltered.length) {
          j++;
        } else {
          nextCompareIndex = i;
          break;
        }
      }
    }
    if (nextCompareIndex == -1) {
      // 모든 필수문자를 이미 입력했거나 타겟 끝
      nextCompareIndex = target.split('').indexWhere((c) => _isRequiredChar(c));
      if (nextCompareIndex == -1) nextCompareIndex = 0; // 전부 특수문자만인 이상 케이스
    }

    // 다시 그릴 때는 j를 0으로 초기화하고 실제 색칠 로직 진행
    j = 0;
    for (int i = 0; i < target.length; i++) {
      final t = target[i];
      Color color;

      if (_isRequiredChar(t)) {
        if (j < inputFiltered.length) {
          final match = t.toLowerCase() == inputFiltered[j].toLowerCase();
          color = match
              ? const Color(0xFF4CAF50)
              : const Color(0xFFD32F2F); // 녹/빨
          j++; // 입력 소비
        } else {
          // 아직 이 필수문자에 도달 못함 → 현재 커서 or 미입력
          color = (i == nextCompareIndex)
              ? const Color(0xFF137fec) // 현재 커서(파랑)
              : const Color(0xFF9E9E9E); // 미입력(회색)
        }
      } else {
        // 특수문자: 비교 대상이 아님 → 항상 중립색(회색)
        color = const Color(0xFF9E9E9E);
      }

      spans.add(
        TextSpan(
          text: t,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            decoration:
                (!_isRequiredChar(t) || color == const Color(0xFF4CAF50))
                ? TextDecoration.none
                : TextDecoration.none, // 필요 시 오타 밑줄 등 추가 가능
          ),
        ),
      );
    }

    charSpans.assignAll(spans);
    charSpans.refresh();
  }

  void nextSentence() {
    sentence.value =
        "All the world’s a stage, and all the men and women merely players.";
    typed.value = "";
    charSpans.clear();
    startTime = null;
    wpm.value = 0;
    accuracy.value = 100;
    timer?.cancel();
    _updateCharSpans(); // 새 문장 즉시 반영
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}

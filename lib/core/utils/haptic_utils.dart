import 'package:flutter/services.dart';

abstract final class HapticUtils {
  static Future<void> lightTap() async {
    await HapticFeedback.lightImpact();
  }

  static Future<void> mediumTap() async {
    await HapticFeedback.mediumImpact();
  }

  static Future<void> errorFeedback() async {
    await HapticFeedback.heavyImpact();
  }

  static Future<void> successFeedback() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }
}

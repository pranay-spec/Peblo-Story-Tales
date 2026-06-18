import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

class OptionButton extends StatelessWidget {
  final String text;

  final int index;

  final bool isSelected;

  final bool isWrong;

  final bool isCorrect;

  final bool isDisabled;

  final VoidCallback? onTap;

  const OptionButton({
    super.key,
    required this.text,
    required this.index,
    this.isSelected = false,
    this.isWrong = false,
    this.isCorrect = false,
    this.isDisabled = false,
    this.onTap,
  });

  String get _letter => String.fromCharCode(65 + index);

  Color get _backgroundColor {
    if (isCorrect) return AppColors.success.withValues(alpha: 0.15);
    if (isWrong) return AppColors.accent.withValues(alpha: 0.15);
    if (isSelected) return AppColors.primary.withValues(alpha: 0.1);
    return AppColors.cardBackground;
  }

  Color get _borderColor {
    if (isCorrect) return AppColors.success;
    if (isWrong) return AppColors.accent;
    if (isSelected) return AppColors.primary;
    return AppColors.border;
  }

  Color get _letterBgColor {
    if (isCorrect) return AppColors.success;
    if (isWrong) return AppColors.accent;
    if (isSelected) return AppColors.primary;
    return AppColors.primary.withValues(alpha: 0.1);
  }

  Color get _letterColor {
    if (isCorrect || isWrong || isSelected) return Colors.white;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    Widget button = Semantics(
      label: 'Option $_letter: $text',
      button: true,
      enabled: !isDisabled,
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          constraints: const BoxConstraints(
            minHeight: AppDimensions.optionButtonHeight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMD,
            vertical: AppDimensions.paddingSM + 4,
          ),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            border: Border.all(
              color: _borderColor,
              width: (isSelected || isCorrect || isWrong) ? 2.0 : 1.5,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _letterBgColor,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSM + 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _letter,
                  style: TextStyle(
                    color: _letterColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMD),

              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isWrong
                        ? AppColors.accent
                        : isCorrect
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),
              ),

              if (isCorrect)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 24,
                )
              else if (isWrong)
                const Icon(
                  Icons.cancel_rounded,
                  color: AppColors.accent,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );

    if (isWrong) {
      button = button.animate().shakeX(hz: 4, amount: 6, duration: 500.ms);
    }

    return button;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/haptic_utils.dart';
import '../providers/audio_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/ui_provider.dart';

class SuccessWidget extends ConsumerWidget {
  const SuccessWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 64)).animate().scale(
                begin: const Offset(0.0, 0.0),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),
              const SizedBox(height: AppDimensions.paddingMD),

              Text(
                AppStrings.successTitle,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.success,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: AppDimensions.paddingSM),

              Text(
                AppStrings.successMessage,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(height: 1.4),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
              const SizedBox(height: AppDimensions.paddingSM),

              Text(
                AppStrings.successSubtext,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
              const SizedBox(height: AppDimensions.paddingLG),

              GestureDetector(
                    onTap: () => _onPlayAgain(ref),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingXL,
                        vertical: AppDimensions.paddingMD,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.successGradient,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusFull,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        AppStrings.playAgain,
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(fontSize: 18),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0, delay: 800.ms, duration: 400.ms),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 500.ms,
          curve: Curves.easeOutBack,
        );
  }

  void _onPlayAgain(WidgetRef ref) {
    HapticUtils.lightTap();

    ref.read(uiProvider.notifier).reset();
    ref.read(quizProvider.notifier).reset();
    ref.read(audioProvider.notifier).reset();
  }
}

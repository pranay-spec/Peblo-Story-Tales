import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/haptic_utils.dart';
import '../providers/audio_provider.dart';
import '../providers/ui_provider.dart';

class StoryErrorWidget extends ConsumerWidget {
  const StoryErrorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('😢', style: TextStyle(fontSize: 40)),
              const SizedBox(height: AppDimensions.paddingMD),

              Text(
                AppStrings.errorMessage,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.accent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingSM),

              Text(
                AppStrings.errorHint,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingLG),

              Semantics(
                label: AppStrings.retryButtonLabel,
                button: true,
                child: GestureDetector(
                  onTap: () => _onRetry(ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingXL,
                      vertical: AppDimensions.paddingMD,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.errorGradient,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: AppDimensions.paddingSM),
                        Text(
                          AppStrings.retryButton,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .shakeX(hz: 2, amount: 4, duration: 500.ms);
  }

  void _onRetry(WidgetRef ref) {
    HapticUtils.lightTap();
    ref.read(audioProvider.notifier).reset();
    ref.read(uiProvider.notifier).reset();
  }
}

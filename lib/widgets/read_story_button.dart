import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/haptic_utils.dart';
import '../providers/audio_provider.dart';
import '../providers/ui_provider.dart';

class ReadStoryButton extends ConsumerWidget {
  const ReadStoryButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final isDisabled =
        audioState.state == AudioState.loading ||
        audioState.state == AudioState.playing ||
        audioState.state == AudioState.completed;

    return Semantics(
      label: AppStrings.readStoryButtonLabel,
      button: true,
      enabled: !isDisabled,
      child:
          Opacity(
                opacity: isDisabled ? 0.6 : 1.0,
                child: GestureDetector(
                  onTap: isDisabled ? null : () => _onPressed(ref),
                  child: Container(
                    width: double.infinity,
                    height: AppDimensions.buttonHeight + 4,
                    decoration: BoxDecoration(
                      gradient: isDisabled
                          ? LinearGradient(
                              colors: [
                                AppColors.disabled,
                                AppColors.disabled.withValues(alpha: 0.8),
                              ],
                            )
                          : AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                      boxShadow: isDisabled
                          ? []
                          : [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                                spreadRadius: 0,
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('📚', style: TextStyle(fontSize: 26)),
                        const SizedBox(width: AppDimensions.paddingMD),
                        Text(
                          AppStrings.readMeAStory,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                fontSize: AppDimensions.fontLG,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms, delay: 400.ms)
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeOut,
              )
              .then(delay: 500.ms)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.02,
                duration: 1500.ms,
                curve: Curves.easeInOut,
              ),
    );
  }

  void _onPressed(WidgetRef ref) {
    HapticUtils.lightTap();

    final audioNotifier = ref.read(audioProvider.notifier);
    final uiNotifier = ref.read(uiProvider.notifier);

    audioNotifier.onNarrationComplete = () {
      uiNotifier.onNarrationComplete();
    };

    audioNotifier.startNarration();

    uiNotifier.onNarrationStart();
  }
}

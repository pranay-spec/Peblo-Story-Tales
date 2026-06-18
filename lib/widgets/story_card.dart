import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../providers/ui_provider.dart';

class StoryCard extends ConsumerWidget {
  const StoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHighlighted = ref.watch(
      uiProvider.select((s) => s.isStoryHighlighted),
    );

    return Semantics(
      label: 'Story card. ${AppStrings.storyTitle}. ${AppStrings.storyText}',
      child:
          AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(AppDimensions.paddingLG),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                  border: Border.all(
                    color: isHighlighted ? AppColors.primary : AppColors.border,
                    width: isHighlighted ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isHighlighted
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.shadow,
                      blurRadius: isHighlighted ? 20 : 10,
                      offset: const Offset(0, 4),
                      spreadRadius: isHighlighted ? 2 : 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                            AppDimensions.paddingSM,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMD,
                            ),
                          ),
                          child: const Text(
                            '📖',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.paddingMD),
                        Expanded(
                          child: Text(
                            AppStrings.storyTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),

                    Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondary.withValues(alpha: 0.5),
                            AppColors.primary.withValues(alpha: 0.3),
                            AppColors.secondary.withValues(alpha: 0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingMD),

                    Text(
                      AppStrings.storyText,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(
                begin: 0.1,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOut,
              ),
    );
  }
}

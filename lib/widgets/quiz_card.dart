import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/haptic_utils.dart';
import '../providers/quiz_provider.dart';
import '../providers/ui_provider.dart';
import 'option_button.dart';

class QuizCard extends ConsumerWidget {
  const QuizCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);
    final quiz = quizState.quiz;

    if (quiz == null) return const SizedBox.shrink();

    return Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingSM),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMD,
                      ),
                    ),
                    child: const Text('🧠', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: Text(
                      AppStrings.quizInstruction,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingMD),

              Text(
                quiz.question,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(height: 1.4),
              ),
              const SizedBox(height: AppDimensions.paddingLG),

              ...quiz.options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isSelected = quizState.selectedOption == option;
                final isWrong =
                    isSelected && quizState.result == AnswerResult.wrong;
                final isCorrect =
                    isSelected && quizState.result == AnswerResult.correct;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < quiz.options.length - 1
                        ? AppDimensions.paddingSM + 4
                        : 0,
                  ),
                  child: OptionButton(
                    text: option,
                    index: index,
                    isSelected: isSelected,
                    isWrong: isWrong,
                    isCorrect: isCorrect,
                    isDisabled: quizState.isCompleted,
                    onTap: () => _onOptionTapped(ref, option),
                  ),
                );
              }),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }

  Future<void> _onOptionTapped(WidgetRef ref, String option) async {
    HapticUtils.lightTap();

    final isCorrect = await ref
        .read(quizProvider.notifier)
        .submitAnswer(option);

    if (isCorrect) {
      await HapticUtils.successFeedback();
      ref.read(uiProvider.notifier).onCorrectAnswer();
    } else {
      await HapticUtils.errorFeedback();
    }
  }
}

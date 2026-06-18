import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz_model.dart';

enum AnswerResult { none, correct, wrong }

class QuizProviderState {
  final QuizModel? quiz;

  final String? selectedOption;

  final AnswerResult result;

  final bool isCompleted;

  final String? errorMessage;

  const QuizProviderState({
    this.quiz,
    this.selectedOption,
    this.result = AnswerResult.none,
    this.isCompleted = false,
    this.errorMessage,
  });

  QuizProviderState copyWith({
    QuizModel? quiz,
    String? selectedOption,
    AnswerResult? result,
    bool? isCompleted,
    String? errorMessage,
  }) {
    return QuizProviderState(
      quiz: quiz ?? this.quiz,
      selectedOption: selectedOption ?? this.selectedOption,
      result: result ?? this.result,
      isCompleted: isCompleted ?? this.isCompleted,
      errorMessage: errorMessage,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizProviderState> {
  QuizNotifier() : super(const QuizProviderState()) {
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/quiz_data.json',
      );
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final quiz = QuizModel.fromJson(jsonMap);
      if (mounted) {
        state = state.copyWith(quiz: quiz);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          quiz: const QuizModel(
            question: "What colour was Pip the Robot's lost gear?",
            options: ['Red', 'Green', 'Blue', 'Yellow'],
            answer: 'Blue',
          ),
        );
      }
    }
  }

  Future<bool> submitAnswer(String option) async {
    if (state.isCompleted || state.quiz == null) return false;

    state = state.copyWith(selectedOption: option, result: AnswerResult.none);

    if (state.quiz!.isCorrect(option)) {
      state = state.copyWith(result: AnswerResult.correct, isCompleted: true);
      return true;
    } else {
      state = state.copyWith(result: AnswerResult.wrong);

      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        state = QuizProviderState(
          quiz: state.quiz,
          selectedOption: null,
          result: AnswerResult.none,
          isCompleted: false,
        );
      }
      return false;
    }
  }

  void reset() {
    state = QuizProviderState(quiz: state.quiz);
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, QuizProviderState>((
  ref,
) {
  return QuizNotifier();
});

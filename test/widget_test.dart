import 'package:flutter_test/flutter_test.dart';
import 'package:peblo_story_tales/models/quiz_model.dart';

/// Unit tests for the QuizModel to verify data-driven quiz parsing.
void main() {
  group('QuizModel', () {
    test('fromJson parses valid JSON correctly', () {
      final json = {
        'question': "What colour was Pip the Robot's lost gear?",
        'options': ['Red', 'Green', 'Blue', 'Yellow'],
        'answer': 'Blue',
      };

      final quiz = QuizModel.fromJson(json);

      expect(quiz.question, "What colour was Pip the Robot's lost gear?");
      expect(quiz.options, ['Red', 'Green', 'Blue', 'Yellow']);
      expect(quiz.answer, 'Blue');
    });

    test('isCorrect returns true for correct answer', () {
      const quiz = QuizModel(
        question: 'Test?',
        options: ['A', 'B', 'C'],
        answer: 'B',
      );

      expect(quiz.isCorrect('B'), isTrue);
    });

    test('isCorrect returns false for wrong answer', () {
      const quiz = QuizModel(
        question: 'Test?',
        options: ['A', 'B', 'C'],
        answer: 'B',
      );

      expect(quiz.isCorrect('A'), isFalse);
      expect(quiz.isCorrect('C'), isFalse);
    });

    test('toJson serializes correctly', () {
      const quiz = QuizModel(
        question: 'Test question?',
        options: ['X', 'Y', 'Z'],
        answer: 'Y',
      );

      final json = quiz.toJson();

      expect(json['question'], 'Test question?');
      expect(json['options'], ['X', 'Y', 'Z']);
      expect(json['answer'], 'Y');
    });

    test('supports variable option counts (3, 4, 5 options)', () {
      // 3 options
      final quiz3 = QuizModel.fromJson({
        'question': 'Q?',
        'options': ['A', 'B', 'C'],
        'answer': 'A',
      });
      expect(quiz3.options.length, 3);

      // 5 options
      final quiz5 = QuizModel.fromJson({
        'question': 'Q?',
        'options': ['A', 'B', 'C', 'D', 'E'],
        'answer': 'E',
      });
      expect(quiz5.options.length, 5);
    });

    test('equality works correctly', () {
      const quiz1 = QuizModel(
        question: 'Same?',
        options: ['A', 'B'],
        answer: 'A',
      );
      const quiz2 = QuizModel(
        question: 'Same?',
        options: ['A', 'B'],
        answer: 'A',
      );

      expect(quiz1, equals(quiz2));
    });
  });
}

class QuizModel {
  final String question;

  final List<String> options;

  final String answer;

  const QuizModel({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    final question = json['question'] as String? ?? '';
    final options =
        (json['options'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final answer = json['answer'] as String? ?? '';

    assert(question.isNotEmpty, 'Quiz question cannot be empty');
    assert(options.isNotEmpty, 'Quiz options cannot be empty');
    assert(
      options.contains(answer),
      'Answer "$answer" must be one of the options: $options',
    );

    return QuizModel(question: question, options: options, answer: answer);
  }

  Map<String, dynamic> toJson() {
    return {'question': question, 'options': options, 'answer': answer};
  }

  bool isCorrect(String selectedOption) => selectedOption == answer;

  @override
  String toString() {
    return 'QuizModel(question: $question, options: $options, answer: $answer)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuizModel &&
        other.question == question &&
        other.answer == answer;
  }

  @override
  int get hashCode => question.hashCode ^ answer.hashCode;
}

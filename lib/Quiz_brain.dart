import 'Question.dart';

class QuizBrain {
  int _questionNumber = 0;  // Variable to track the current question

  List<Question> questionBank = [
    Question('Who was the first Prime Minister of Pakistan?', true),
    Question('When did Pakistan become a republic?', false),
    Question('What year was the creation of Pakistan?', true),
    Question('Who was the founder of Pakistan?', true),
    Question('Which political party did Benazir Bhutto lead?', true),
    Question('Who was the President of Pakistan before Arif Alvi?', false),
    Question('What is the name of the current Prime Minister of Pakistan?', false),
    Question('Which Pakistani leader is known for the Green Revolution?', true),
    Question('In which city was the 1970 general election held?', false),
    Question('Who served as the Chief Martial Law Administrator in 1958?', true),
  ];

  void nextQuestion() {
    if (_questionNumber < questionBank.length - 1) {
      _questionNumber++;
    }
  }

  String getQuestion() {
    return questionBank[_questionNumber].questionText;
  }

  bool getCorrectAnswer() {
    return questionBank[_questionNumber].questionAnswer;
  }

  bool isFinished() {
    return _questionNumber >= questionBank.length - 1;
  }

  void reset() {
    _questionNumber = 0;
  }

}

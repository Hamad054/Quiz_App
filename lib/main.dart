import 'package:flutter/material.dart';
import 'dart:async';  // Import the async library
import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: const Text('Quiz App'),
          backgroundColor: Colors.black,
        ),
        body: const QuizPage(),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  Timer? _timer;  // Variable to hold the timer
  static const int _timeoutDuration = 4;  // Timer duration in seconds
  int _remainingTime = _timeoutDuration;  // Variable to track remaining time

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingTime = _timeoutDuration;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timer.cancel();
          if (!quizBrain.isFinished()) {
            setState(() {
              quizBrain.nextQuestion();
              scoreKeeper.clear();  // Clear the score keeper on timeout
              _startTimer();  // Restart the timer for the next question
            });
          }
        }
      });
    });
  }

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();

    setState(() {
      _timer?.cancel();  // Cancel the timer when an answer is selected
      if (quizBrain.isFinished()) {
        // Show an alert dialog here to notify the user that the quiz is over
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Quiz Finished'),
              content: const Text('You have completed the quiz!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    quizBrain.reset();
                    setState(() {
                      scoreKeeper.clear();
                      _remainingTime = _timeoutDuration;  // Reset timer
                    });
                    _startTimer();  // Restart timer after resetting
                  },
                  child: const Text('Restart Quiz'),
                ),
              ],
            );
          },
        );
      } else {
        if (userPickedAnswer == correctAnswer) {
          scoreKeeper.add(const Icon(
            Icons.check,
            color: Colors.green,
          ));
        } else {
          scoreKeeper.add(const Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
        quizBrain.nextQuestion();
        _startTimer();  // Restart the timer for the next question
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();  // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              '$_remainingTime seconds left',  // Display remaining time
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestion(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: OutlinedButton(
              onPressed: () {
                _timer?.cancel();  // Cancel the timer when an answer is selected
                checkAnswer(true);
              },
              child: const Text(
                'True',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green), // Background color of the button
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: OutlinedButton(
              onPressed: () {
                _timer?.cancel();  // Cancel the timer when an answer is selected
                checkAnswer(false);
              },
              child: const Text(
                'False',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Background color of the button
              ),
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}

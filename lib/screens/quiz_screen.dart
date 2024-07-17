import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:project_quiz/model/questions_model.dart';
import 'package:project_quiz/screens/result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.totalTime,
    required this.questions,
  });

  final int totalTime;
  final List<Question> questions;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late int _currentTime;
  late Timer _timer;
  int _currentIndex = 0;
  String _selectedAnswer = '';
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.totalTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime -= 1;
      });
      if (_currentTime == 0) {
        timer.cancel();
        PushResultScreen(context);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final currentQuestion = widget.questions[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 45, left: 25, right: 25, bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                height: height * 0.032,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      LinearProgressIndicator(
                        value: _currentTime / widget.totalTime,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Timer:',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Text(
                              _currentTime.toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Center(
                              child: Image.asset(
                                'images/timer.png',
                                width: 22,
                                height: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.06),
              Text(
                'Question:',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                currentQuestion.question,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: currentQuestion.answers.length,
                  itemBuilder: (context, index) {
                    final answer = currentQuestion.answers[index];
                    return AnswerTile(
                      index: index,
                      isSelected: answer == _selectedAnswer,
                      answer: answer,
                      correctAnswer: currentQuestion.correctAnswer,
                      onTap: () {
                        setState(() {
                          _selectedAnswer = answer;
                        });

                        if (answer == currentQuestion.correctAnswer) {
                          _score++;
                        }
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (_currentIndex == widget.questions.length - 1) {
                            PushResultScreen(context);
                          } else {
                            setState(() {
                              _currentIndex++;
                              _selectedAnswer = '';
                            });
                          }
                        });
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void PushResultScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: _score,
          questions: widget.questions,
        ),
      ),
    );
  }
}

class AnswerTile extends StatelessWidget {
  const AnswerTile({
    super.key,
    required this.index,
    required this.isSelected,
    required this.answer,
    required this.correctAnswer,
    required this.onTap,
  });

  final int index;
  final bool isSelected;
  final String answer;
  final String correctAnswer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 12,
        color: cardColor,
        child: ListTile(
          leading: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: Text(_indexToLetter(index)),
          ),
          onTap: onTap,
          title: Text(
            answer,
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  String _indexToLetter(int index) {
    return String.fromCharCode(index + 65);
  }

  Color get cardColor {
    if (!isSelected) return Colors.blue;
    if (answer == correctAnswer) {
      return Colors.green;
    }
    return Colors.red;
  }
}

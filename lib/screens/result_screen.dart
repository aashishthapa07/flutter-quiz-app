import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_quiz/model/questions_model.dart';
import 'package:project_quiz/screens/quiz_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final List<Question> questions;

  const ResultScreen({
    super.key,
    required this.score,
    required this.questions,
  }) : super();

  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  int rewardPoints = 0;

  @override
  void initState() {
    super.initState();
    // Fetch reward points from SharedPreferences on widget initialization
    _loadRewardPoints();
    // Update reward points immediately based on score
    _updateRewardPointsIfNeeded();
  }

  Future<void> _loadRewardPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rewardPoints = prefs.getInt('rewardPoints') ?? 0;
    });
  }

  Future<void> _updateRewardPointsIfNeeded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentPoints = prefs.getInt('rewardPoints') ?? 0;

    if (widget.score >= 0.6 * widget.questions.length) {
      // Add 5 points if score is more than or equal to 60% of total questions
      rewardPoints = currentPoints + 5;
      prefs.setInt('rewardPoints', rewardPoints);
      print('Reward points updated to: $rewardPoints');
    } else {
      // No points added if condition is not met
      rewardPoints = currentPoints;
      print('No reward points added.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height * 0.4,
                width: width * 0.8,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Result: ${widget.score}/${widget.questions.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      widget.score >= 0.6 * widget.questions.length
                          ? "Well Played"
                          : "Better luck next time",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/medal.png',
                          height: 45,
                          width: 45,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          'Reward Points: $rewardPoints',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      height: height * 0.05,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              totalTime: 280,
                              questions: widget.questions,
                            ),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                          foregroundColor: Colors.black,
                          elevation: 18,
                        ),
                        child: Text(
                          "Play Again",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:project_quiz/model/questions_model.dart';
// import 'package:project_quiz/screens/quiz_screen.dart';

// class ResultScreen extends StatelessWidget {
//   const ResultScreen({
//     super.key,
//     required this.score,
//     // required this.totalQuestion,
//     required this.questions,
//   });

//   final int score;
//   // final int totalQuestion;
//   final List<Question> questions;

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SizedBox.expand(
//         child: Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: height * 0.3,
//                 width: width * 0.8,
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFEEEEEE),
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Result: $score/${questions.length}',
//                       style: GoogleFonts.poppins(
//                         fontSize: 25,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: height * 0.02),
//                     Text(
//                       score >= 0.6 * questions.length
//                           ? "Well Played"
//                           : "Better luck next time",
//                       style: GoogleFonts.poppins(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: height * 0.02),
//                     SizedBox(
//                       height: height * 0.05,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => QuizScreen(
//                                     totalTime: 280,
//                                     questions: questions,
//                                   )));
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue[300],
//                             foregroundColor: Colors.black,
//                             elevation: 18),
//                         child: Text(
//                           "Play Again",
//                           style: GoogleFonts.poppins(
//                             fontSize: 25,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

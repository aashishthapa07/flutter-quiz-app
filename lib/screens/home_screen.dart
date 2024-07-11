import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_quiz/model/questions_model.dart';
import 'package:project_quiz/screens/quiz_screen.dart';
import 'package:project_quiz/services/firebase_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final firestoreService = FirestoreService();

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
                height: height * 0.3,
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
                      "Free Quiz",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    StreamBuilder<List<Question>>(
                      stream: firestoreService.getQuestionsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        final questions = snapshot.data ?? [];

                        return StreamBuilder<Map<String, dynamic>>(
                          stream: firestoreService.getConfigStream(),
                          builder: (context, configSnapshot) {
                            if (!configSnapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final config = configSnapshot.data!;
                            if (!config.containsKey('key') ||
                                config['key'] is! int) {
                              return const Center(
                                child: Text('Invalid config data format.'),
                              );
                            }
                            final totalTime = config['key'];

                            return Column(
                              children: [
                                SizedBox(
                                  height: height * 0.05,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => QuizScreen(
                                          totalTime: totalTime,
                                          questions: questions,
                                        ),
                                      ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[300],
                                      foregroundColor: Colors.black,
                                      elevation: 18,
                                    ),
                                    child: Text(
                                      "Start Quiz",
                                      style: GoogleFonts.poppins(
                                        fontSize: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  'Total Questions: ${questions.length}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
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
// import 'package:cloud_firestore/cloud_firestore.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

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
//                       "Free Quiz",
//                       style: GoogleFonts.poppins(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: height * 0.02),
//                     StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance
//                           .collection('questions')
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                         if (snapshot.hasError) {
//                           return Center(
//                             child: Text('Error: ${snapshot.error}'),
//                           );
//                         }
//                         final questionDocs = snapshot.data!.docs;
//                         final questions = questionDocs
//                             .map((e) => Question.fromQueryDocumentSnapshot(e))
//                             .toList();

//                         return StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance
//                               .collection('config')
//                               .snapshots(),
//                           builder: (context, configSnapshot) {
//                             if (!configSnapshot.hasData) {
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }
//                             final configDoc = configSnapshot.data!.docs.first
//                                 .data() as Map<String, dynamic>;

//                             if (!configDoc.containsKey('key') ||
//                                 configDoc['key'] is! int) {
//                               return const Center(
//                                 child: Text('Invalid config data format.'),
//                               );
//                             }
//                             final totalTime = configDoc['key'];

//                             return Column(
//                               children: [
//                                 SizedBox(
//                                   height: height * 0.05,
//                                   child: ElevatedButton(
//                                     onPressed: () {
//                                       Navigator.of(context)
//                                           .push(MaterialPageRoute(
//                                         builder: (context) => QuizScreen(
//                                           totalTime: totalTime,
//                                           questions: questions,
//                                         ),
//                                       ));
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue[300],
//                                       foregroundColor: Colors.black,
//                                       elevation: 18,
//                                     ),
//                                     child: Text(
//                                       "Start Quiz",
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 25,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: height * 0.02),
//                                 Text(
//                                   'Total Questions: ${questions.length}',
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 )
//                               ],
//                             );
//                           },
//                         );
//                       },
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

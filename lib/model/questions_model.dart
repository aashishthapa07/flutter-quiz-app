import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Question {
  final String id;
  final String question;
  final List<String> answers;
  final String correctAnswer;

  Question({
    required this.id,
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  Question copyWith({
    String? id,
    String? question,
    List<String>? answers,
    String? correctAnswer,
  }) {
    return Question(
      id: id ?? this.id,
      question: question ?? this.question,
      answers: answers ?? this.answers,
      correctAnswer: correctAnswer ?? this.correctAnswer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answers': answers,
      'correctAnswer': correctAnswer,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      question: map['question'],
      answers: List<String>.from(map['answers']),
      correctAnswer: map['correctAnswer'],
    );
  }

  factory Question.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final id = snapshot.id;
    data['id'] = id;
    return Question.fromMap(data);
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Question(id: $id, question: $question, answers: $answers, correctAnswer: $correctAnswer)';
  }

  @override
  bool operator ==(covariant Question other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.question == question &&
        listEquals(other.answers, answers) &&
        other.correctAnswer == correctAnswer;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        question.hashCode ^
        answers.hashCode ^
        correctAnswer.hashCode;
  }
}

// List<Question> questions = [
//   Question(
//     id: 1,
//     question: 'What is the full form of PSO?',
//     answers: [
//       'Payment Service Provider',
//       'Payment System Operator',
//       'Payment Security Operator',
//       'Payment Security Provider'
//     ],
//     correctAnswer: 'Payment System Operator',
//   ),
//   Question(
//     id: 2,
//     question: 'City Wallet is categorized as what type of service provider?',
//     answers: [
//       'Payment Service Provider',
//       'Payment System Operator',
//       'Payment Security Operator',
//       'Payment Security Provider'
//     ],
//     correctAnswer: 'Payment Service Provider',
//   ),
//   Question(
//     id: 3,
//     question:
//         'What is the per-day transaction limit from a bank account to a customer wallet?',
//     answers: ['Rs 25,000', 'Rs 50,000', 'Rs 1,00,000', 'Rs 2,00,000'],
//     correctAnswer: 'Rs 2,00,000',
//   ),
//   Question(
//     id: 4,
//     question:
//         'What is the per month transaction limit from a customer wallet to bank account?',
//     answers: ['Rs 1,00,000', 'Rs 2,00,000', 'Rs 5,00,000', 'Rs 10,00,000'],
//     correctAnswer: 'Rs 10,00,000',
//   ),
//   Question(
//     id: 5,
//     question:
//         'What is the maximum service charge for interbank fund transfer in Nepal?',
//     answers: [
//       'Rs 5 per transaction',
//       'Rs 10 per transaction',
//       'Rs 20 per transaction',
//       'No limit'
//     ],
//     correctAnswer: 'Rs 10 per transaction',
//   ),
//   Question(
//     id: 6,
//     question:
//         'PSPs licensed to issue prepaid cards can do so only in which currency?',
//     answers: ['USD', 'EUR', 'Domestic currency', 'Any foreign currency'],
//     correctAnswer: 'Domestic currency',
//   ),
//   Question(
//     id: 7,
//     question:
//         'What is the maximum overnight balance a wallet can hold in Nepal?',
//     answers: ['Rs 10,000', 'Rs 25,000', 'Rs 50,000', 'Rs 1,00,000'],
//     correctAnswer: 'Rs 50,000',
//   ),
//   Question(
//     id: 8,
//     question:
//         'How many times can funds be deposited into a natural person wallet in one day?',
//     answers: ['1 Time', '5 Times', '10 Times', 'No limit'],
//     correctAnswer: '10 Times',
//   ),
//   Question(
//     id: 9,
//     question:
//         'Is there a limit on transferring funds from a wallet to the wallet user\'s own linked bank account?',
//     answers: [
//       'Yes Rs 1,00,000 per day',
//       'Yes Rs 25,000 per day',
//       'Yes Rs 50,000 per day',
//       'No there is no limit'
//     ],
//     correctAnswer: 'No there is no limit',
//   ),
//   Question(
//     id: 10,
//     question:
//         'What is the settlement time limit for a transaction if the issuer and acquirer are different companies in Nepal?',
//     answers: ['T+1', 'T+2', 'T+3', 'T+4'],
//     correctAnswer: 'T+1',
//   ),
// ];

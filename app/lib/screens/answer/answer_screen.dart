import 'package:flutter/material.dart';
import 'package:gaia/components/presentational/ghost.dart';
import 'package:gaia/models/models.dart';
import 'package:gaia/screens/answer/answer_type_layouts.dart';

class AnswerScreen extends StatefulWidget {
//  final String surveyUuid;

  final Survey survey;

  const AnswerScreen({
    Key key,
    this.survey,
  }) : super(key: key);

  @override
  _AnswerScreenState createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  final answers = <String, dynamic>{};

  int currentIndex = 0;

  SurveyQuestion get currentQuestion => widget.survey.questions[currentIndex];

  void onAnswerChanged(dynamic answer) {
    setState(() {
      answers[currentQuestion.uuid] = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.survey.title),
      ),
      bottomNavigationBar: Material(
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(width: 4),
            Expanded(
              child: Ghost(
                show: currentIndex != 0,
                child: FlatButton(
                  child: Text('VOLTAR'),
                  textColor: theme.primaryColor,
                  onPressed: () {},
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                child: Text('AVANÇAR'),
                textColor: theme.primaryColor,
                onPressed: () {},
              ),
            ),
            SizedBox(width: 4),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              QuestionHeader(question: currentQuestion),
              SizedBox(height: 16),
              buildTypeSpecific(currentQuestion),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTypeSpecific(SurveyQuestion question) {
    final answer = answers[currentQuestion.uuid];

    switch (question.type) {
      case QuestionType.single:
        return AnswerSingleChoiceQuestion(
          question: question,
          answer: answer as String,
          onAnswerChanged: onAnswerChanged,
        );

      case QuestionType.multiple:
        return AnswerMultipleChoiceQuestion(
          question: question,
          answer: answer as List<String>,
          onAnswerChanged: onAnswerChanged,
        );

      case QuestionType.number:
        return AnswerNumberQuestion(
          question: question,
          answer: answer as double,
          onAnswerChanged: onAnswerChanged,
        );

      case QuestionType.text:
        return AnswerTextQuestion(
          question: question,
          answer: answer as String,
          onAnswerChanged: onAnswerChanged,
        );
    }

    throw ArgumentError();
  }
}

class QuestionHeader extends StatelessWidget {
  final SurveyQuestion question;

  const QuestionHeader({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 24),
        Text(
          question.title,
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          question.description,
          style: TextStyle(fontSize: 16, color: Color(0xFF606060)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
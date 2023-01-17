import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quizbrain.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:async/async.dart';

QuizBrain quizBrain = QuizBrain();
void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int amountOfTrue = 0;
  int amountOfFalse = 0;
  String getResult(){
    if(amountOfTrue > amountOfFalse){
      return ("GOOD JOB!");
    }else if(amountOfTrue == amountOfFalse){
      return ("NOT BAD!");
    }else{
      return ("AWFUL :(");
    }

  }
  void checkAnswer(bool answer) {
    if (quizBrain.isFinished()) {
      Alert(
        style: AlertStyle(
          animationType: AnimationType.grow,
          animationDuration: Duration(milliseconds: 1000),
          backgroundColor: Colors.white,
        ),
        context: context,
        title: "GAME OVER",
        desc: getResult(),
        buttons: [
          DialogButton(
            color: Colors.pink.shade500,
            child: Text(
              "Play Again!",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              setState(() {
                quizBrain.reset();
                amountOfTrue = 0;
                amountOfFalse = 0;
              });
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      bool correctAnswer = quizBrain.getAnswer();
      if (correctAnswer == answer) {
        amountOfTrue++;
      } else {
        amountOfFalse++;
      }
      setState(() {
        quizBrain.nextQuestion();
      });
    }
  }

  int time = 10;
  void initState(){
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(time > 0){
        setState(() {
          time--;
        });
      }else{
        setState(() {
          time=10;
          quizBrain.nextQuestion();
          if(quizBrain.isFinished()){

          }else
            amountOfFalse++;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 60,
                  ),
                  Text(
                    '$amountOfTrue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 40.0,
                        lineWidth: 7.0,
                        percent: (10-time)/10,
                        center: new Text("$time",style: TextStyle(color: Colors.white,fontSize: 20),),
                        progressColor: Colors.deepPurple.shade600,
                        backgroundColor: Colors.deepPurple.shade200,
                      ),
                    ],
                ),
              ),
              Column(
                children: [
                  Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 60,
                  ),
                  Text(
                    '$amountOfFalse',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                quizBrain.getText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                checkAnswer(true);
                time = 10;
              },
              child: Text('True'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                checkAnswer(false);
                time = 10;
              },
              child: Text('False'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
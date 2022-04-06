import 'package:flutter/material.dart';
// imported a package to display SVG images
import 'package:flutter_svg/flutter_svg.dart';
//imported a package to provide alert/popup dialogs
import 'package:rflutter_alert/rflutter_alert.dart';

import 'quizBrain.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue.shade900,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('QUIZZLER'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // created a list scorekeeper to keep the answers of the questions
  List<Icon> scorekeeper = [];

  //it is function that checks the user given to answer to the correct answer and updates the scorekeeper
  void checkanswer(bool userpickedanswer) {
    bool correctanswer = quizBrain.getquestionanswer();
    setState(() {
      //if the question number becomes greater than the length of question bank then reset the question number and the scorekeeper
      if (quizBrain.isFinished() == true) {
        //it resets the question number
        quizBrain.reset();

        //it resets the scorekeeper
        scorekeeper = [];
      }
      // question number is less than the length of question number , so check the answer and provide the next question
      else {
        //checks the answer
        if (userpickedanswer == correctanswer) {
          scorekeeper.add(Icon(
            Icons.check,
            color: Colors.green,
          ));
        } else {
          scorekeeper.add(Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
        // provides the next question present in the question bank
        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildQuestionsPage();
  }

  // Created a function which shows the questions on starting of app and it shows a screen to start over when the quiz is completed.
  Column buildQuestionsPage() {
    if (quizBrain.isFinished() == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //this provides the svg image and text at end of quiz
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset('assets/highfive.svg', width: 500.0),
                    Text(
                      'You have successfully completed the quiz',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // provides a start over button which ends the quiz and provides a dialog button at last page to restart the app
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  textColor: Colors.white,
                  color: Colors.blue.shade500,
                  child: Text(
                    'Start Over',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  onPressed: () {
                    setState(() {
                      Alert(
                        context: context,
                        title: 'Finished!',
                        desc: 'Restart the Quiz',
                        buttons: [
                          DialogButton(
                            child: Text(
                              "RESTART",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();
                      scorekeeper = [];

                      quizBrain.reset();
                    });
                  }),
            ),
          ),
          // displays the scorekeeper on the screen after the question are finished
          SafeArea(
            child: Row(
              children: scorekeeper,
            ),
          )
        ],
      );
    }
    // displays the questions and the true and false buttons on screen
    else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // displays the questions on screen
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  quizBrain.getquestiontext(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // displays the true button on screen and checks the answer
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: MaterialButton(
                textColor: Colors.white,
                color: Colors.green,
                child: Text(
                  'True',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  checkanswer(true);
                  //The user picked true.
                },
              ),
            ),
          ),
          // // displays the false button on screen and checks the answer
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: MaterialButton(
                color: Colors.red,
                child: Text(
                  'False',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  //The user picked false.
                  checkanswer(false);
                },
              ),
            ),
          ),
          // displays the scorekeeper on screen where question are displayed
          SafeArea(
            child: Row(
              children: scorekeeper,
            ),
          )
        ],
      );
    }
  }
}

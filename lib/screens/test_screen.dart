import 'package:flutter/material.dart';
import 'package:my_datebase/home_screen.dart';
import 'package:path/path.dart';

enum TestStatus { BEFORE_START, SHOW_QUESTION, SHOW_ANSWER, FINISHED }

class TestScreen extends StatefulWidget {
  final bool isIncludeMemorizedWord;

  TestScreen({required this.isIncludeMemorizedWord});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _numberOfQuestion = 0;

  String _txtQuestion = "テスト";

  String _txtAnswer = "解答";

  bool _isMemorized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("確認テスト"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("Fab"), //TODO
        child: Icon(Icons.skip_next),
        tooltip: "次に進む",
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          _numberOfQuestionPart(),
          SizedBox(
            height: 50.0,
          ),
          _questionPart(),
          SizedBox(
            height: 20.0,
          ),
          _answerPart(),
          _isMemorizedCheck(),
        ],
      ),
    );
  }

//TODO 残り問題を表示
  Widget _numberOfQuestionPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "残り問題数!!",
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          _numberOfQuestion.toString(),
          style: TextStyle(fontSize: 14.0),
        )
      ],
    );
  }

//TODO　問題カードを表示
  Widget _questionPart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset("assets/images/image_flash_question.png"),
        Text(
          _txtQuestion,
          style: TextStyle(color: Colors.cyan, fontSize: 20.0),
        )
      ],
    );
  }

//TODO　答えカードを表示
  Widget _answerPart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset("assets/images/image_flash_answer.png"),
        Text(
          _txtAnswer,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        )
      ],
    );
  }

//TODO　チェクボックスを表示
  Widget _isMemorizedCheck() {
    return CheckboxListTile(
        title: Text(
          "暗記済みの場合はチェックを入れてください",
          style: TextStyle(fontSize: 15.0),
        ),
        value: _isMemorized,
        onChanged: (value) {
          setState(() {
            _isMemorized = value!;
          });
        });
  }
}

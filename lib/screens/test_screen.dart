import 'package:flutter/material.dart';
import 'package:my_datebase/db/database.dart';
import 'package:my_datebase/main.dart';
import 'package:flutter/cupertino.dart';

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

  bool _isQuestionCardVisible = false;
  bool _isAnswerCardVisible = false;
  bool _isCheckboxVisible = false;
  bool _isFabVisible = false;
  List<Word> _testWordList = [];

  TestStatus _testStatus = TestStatus.BEFORE_START;
  int _index = 0;//今何問目
  late Word _currentWord;

  @override
  void initState() {
    super.initState();
    _getTestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("確認テスト"),
        centerTitle: true,
      ),
      floatingActionButton: _isFabVisible ? FloatingActionButton(
        onPressed: () => _goNextStatus(), //TODO
        child: Icon(Icons.skip_next),
        tooltip: "次に進む",
      ) : null,
      body: Stack(
        children: [
          Column(
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
          _endMessage(),
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
          "残り問題数",
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          _numberOfQuestion.toString(),
          style: TextStyle(fontSize: 14.0),
        ),
      ],
    );
  }

//TODO　問題カードを表示
  Widget _questionPart() {
    if (_isQuestionCardVisible) {
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
    } else
      return Container();
  }

//TODO　答えカードを表示
  Widget _answerPart() {
    if (_isAnswerCardVisible) {
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
    } else
      return Container();
  }

//TODO　チェクボックスを表示
  Widget _isMemorizedCheck() {
    if (_isCheckboxVisible) {
      return CheckboxListTile(
          title: Text(
            "暗記済みの場合はチェックを入れてください",
            style: TextStyle(fontSize: 15.0),
          ),
          value: _isMemorized,
          onChanged: (value) {
            setState(() {
              _isMemorized = value!;
            }
            );
          });
    } else
      return Container();
  }

  void _getTestData() async {
    if (widget.isIncludeMemorizedWord) {
      _testWordList = await database.allWords;
    } else {
      _testWordList = await database.allWordsUnderstanded;
    }
    _testWordList.shuffle();
    _testStatus = TestStatus.BEFORE_START;
    _index =0;
    print(_testWordList.toString());

    setState(() {
      _isQuestionCardVisible = false;
      _isAnswerCardVisible = false;
      _isCheckboxVisible = false;
      _isFabVisible = true;
      _numberOfQuestion = _testWordList.length;
    });
  }

  _goNextStatus() async {
    switch (_testStatus) {
      case TestStatus.BEFORE_START:
        _testStatus = TestStatus.SHOW_QUESTION;
        _showQuestion();
        break;
      case TestStatus.SHOW_QUESTION:
        _testStatus = TestStatus.SHOW_ANSWER;
        _showAnswer();
        break;
      case TestStatus.SHOW_ANSWER:
        await _updateMemorizedFlag();
        if (_numberOfQuestion <= 0) {
          setState(() {
            _isFabVisible=false;
            _testStatus = TestStatus.FINISHED;
          });
        } else {
          _testStatus = TestStatus.SHOW_QUESTION;
          _showQuestion();
        }
        break;
      case TestStatus.FINISHED:
        break;
    }
  }

  void _showQuestion() {
    _currentWord = _testWordList[_index];
    setState(() {
      _isQuestionCardVisible = true;
      _isAnswerCardVisible = false;
      _isCheckboxVisible = false;
      _isFabVisible = true;
      _txtQuestion = _currentWord.strQuestion;
    });
    _numberOfQuestion -= 1;
    _index += 1;
  }

  void _showAnswer() {
    setState(() {
      _isQuestionCardVisible = true;
      _isAnswerCardVisible = true;
      _isCheckboxVisible = true;
      _isFabVisible = true;
      _txtAnswer = _currentWord.strAnswer;
      _isMemorized = _currentWord.isMemorized;
    });
  }

  Future<void> _updateMemorizedFlag() async {
    var _updateWord = Word(strQuestion: _currentWord.strQuestion,
        strAnswer: _currentWord.strAnswer,
        isMemorized: _isMemorized);
    await database.updateWord(_updateWord);
  }

  Widget _endMessage() {
    if (_testStatus == TestStatus.FINISHED) {
      return
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text("テスト終了", style: TextStyle(fontSize: 50,color: Colors.pink),
          )
          ),
        );
    } else {
      return Container();
    }
  }
}
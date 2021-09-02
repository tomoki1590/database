import 'package:flutter/material.dart';
import 'package:my_datebase/db/database.dart';
import 'package:my_datebase/main.dart';
import 'package:my_datebase/screens/wordlist_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqlite3/src/api/exception.dart';

enum EditStatus { ADD, EDIT }

class EditScreen extends StatefulWidget {
  final EditStatus status;

  final Word? word;

  EditScreen({required this.status, this.word});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController questionInputPart = TextEditingController();
  TextEditingController answerInputPart = TextEditingController();

  String _titleText = "";

  bool _isQuestionEnabled = true;

  @override
  void initState() {
    super.initState();
    if (widget.status == EditStatus.ADD) {
      _isQuestionEnabled = true;
      _titleText = "新しい単語の追加";
      questionInputPart.text = "";
      answerInputPart.text = "";
    } else {
      _isQuestionEnabled = false;
      _titleText = "単語の修正";
      questionInputPart.text = widget.word!.strQuestion;
      answerInputPart.text = widget.word!.strAnswer;
    }
  }
    @override
    Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: () => _backToWordlist(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text(_titleText),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.done),
                tooltip: ("登録"),
                onPressed: () => _onWordResisterd(),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "新しく追加する単語を入力してね",
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                //　問題入力
                SizedBox(
                  height: 20,
                ),
                _inputQuestion(),
                //　解答入力
                SizedBox(height: 20),
                _inputAnswer(),
              ],
            ),
          ),
        ),
      );
    }

    Widget _inputQuestion() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Text(
              "問題",
              style: TextStyle(fontSize: 30),
            ),
            TextField(
              enabled: _isQuestionEnabled,
              controller: questionInputPart,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 30),
            )
          ],
        ),
      );
    }

    Widget _inputAnswer() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Text(
              "答え",
              style: TextStyle(fontSize: 30),
            ),
            TextField(
              controller: answerInputPart,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      );
    }

    Future<bool> _backToWordlist(BuildContext context) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WordListScreen()));
      return Future.value(false);
    }

    _onWordResisterd() {
      if (widget.status == EditStatus.ADD) {
        _insertWord();
      } else {
        _updateWord();
      }
    }

    _insertWord() async {
      if (questionInputPart.text == "" || answerInputPart.text == "") {
        Fluttertoast.showToast(
          msg: "両方入れないと無理〜",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
        );
        return;
      }


      showDialog(context: context, builder: (_) =>
          AlertDialog(
            title: Text("登録"),
            content: Text("登録していいですか"),
            actions: [
              TextButton(
                  child: Text("はい"),
                  onPressed: () async {
                    var word = Word(
                        strQuestion: questionInputPart.text,
                        strAnswer: answerInputPart.text,
                        isMemorized: false);

                    try {
                      await database.addWord(word);
                      print("ok");
                      questionInputPart.clear();
                      answerInputPart.clear();
                      Fluttertoast.showToast(
                          msg: "登録完了",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER_LEFT
                      );
                    } on SqliteException catch (e) {
                      Fluttertoast.showToast(msg: "登録されてるよー");
                    } finally {
                      Navigator.pop(context);
                    }
                  }

              ),

              TextButton(
                child: Text("いいえ"), onPressed: () => Navigator.pop(context),

              )
            ],
          ));
    }

    void _updateWord() async {
      if (questionInputPart.text == "" || answerInputPart.text == "") {
        Fluttertoast.showToast(
          msg: "両方入れないと無理〜",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
        );
        return;
      }
      showDialog(context: context, builder: (_) =>
          AlertDialog(
            title: Text("${questionInputPart.text}の変更"),
            content: Text("変更してもいいですか"),
            actions: <Widget>[
              TextButton(child: Text("はい"), onPressed: () async {
                var word = Word(
                    strQuestion: questionInputPart.text,
                    strAnswer: answerInputPart.text,
                    isMemorized: false);
                try {
                  await database.updateWord(word);
                  _backToWordlist(context);
                  Fluttertoast.showToast(msg: "変更完了しました");
                } on SqliteException catch (e) {
                  Fluttertoast.showToast(
                      msg: "エラーにより処理不能", toastLength: Toast.LENGTH_SHORT);
                } finally {}
                Navigator.pop(context);
              },
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text("いいえ")
              ),
            ],
          ),
      );
    }
  }



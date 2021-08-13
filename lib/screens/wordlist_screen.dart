import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_datebase/db/database.dart';
import 'package:my_datebase/main.dart';
import 'package:path/path.dart';
import 'edit_screen.dart';

class WordListScreen extends StatefulWidget {
  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> _wordList = [];

  @override
  void initState() {
    super.initState();
    _getAllWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("一覧画面"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewWord(context),
        child: Icon(Icons.add_box),
        tooltip: ('編集画面へ飛ぶよー'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _wordListWidget(),
      ),
    );
  }

  _addNewWord(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EditScreen(
                  status: EditStatus.ADD,
                )));
  }

  void _getAllWords() async {
    _wordList = await database.allWords;
    setState(() {});
  }

  Widget _wordListWidget() {
    return ListView.builder(
        itemCount: _wordList.length,
        itemBuilder: (context, int position) => _wordItem(position));
  }

  Widget _wordItem(int position) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.cyan,
      child: ListTile(
        title: Text("${_wordList[position].strQuestion}"),
        subtitle: Text("${_wordList[position].strAnswer}",
            style: TextStyle(fontFamily: "rough")),
        onTap: () => _editWord(_wordList[position]),
        onLongPress: () => _deleteWord(_wordList[position]),
      ),
    );
  }

  _deleteWord(Word selectedWord) async {
    await database.deleteWord(selectedWord);
    Fluttertoast.showToast(
      msg: "削除完了",
      toastLength: Toast.LENGTH_LONG,
    );
    _getAllWords();
  }

  _editWord(Word selectedWord) {
    Navigator.pushReplacement(
        this.context,
        MaterialPageRoute(
            builder: (context) =>
                EditScreen(status: EditStatus.EDIT, word: selectedWord)));
  }
}

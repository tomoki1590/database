import 'package:flutter/material.dart';
import 'package:my_datebase/parts/button_with_icon.dart';
import 'package:my_datebase/screens/test_screen.dart';
import 'package:my_datebase/screens/wordlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool isIncludeMemorizedWord = false;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(child: Image.asset("assets/images/image_title.png")),
            _titleText(),
            Divider(
              height: 100,
              indent: 10,
              endIndent: 10,
              color: Colors.white,
            ),

            //テストボタン,
            ButtonWithIcon(
              onPressed: () => _StartTestScreen(context),
              icon: Icon(Icons.play_arrow),
              label: ("テストをする"),
              color: Colors.red,
            ),

            //Todo　ラジオボタン,
            //_radioButton(),
            Widget_switch(),
            //　単語一覧ボタン,
            ButtonWithIcon(
                onPressed: () => _startWordListScreen(context),
                icon: Icon(Icons.list),
                label: ("単語一覧"),
                color: Colors.brown),
            Text(
              "powered by Tom",
              style: TextStyle(fontSize: 20.0, fontFamily: "rough"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleText() {
    return Column(
      children: [
        Text(
          "私の単語帳",
          style: TextStyle(fontSize: 20),
        ),
        Text(
          "MyVocabulary",
          style: TextStyle(fontSize: 50),
        ),
      ],
    );
  }

  Widget _radioButton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: RadioListTile(
            title: Text(
              "暗記済は除外する",
              style: TextStyle(fontSize: 20),
            ),
            value: false,
            groupValue: isIncludeMemorizedWord,
            onChanged: (value) => _onClickbutton(value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: RadioListTile(
            title: Text(
              "暗記済も含む",
              style: TextStyle(fontSize: 20),
            ),
            value: true,
            groupValue: isIncludeMemorizedWord,
            onChanged: (value) => _onClickbutton(value),
          ),
        ),
      ],
    );
  }

  _onClickbutton(value) {
    setState(() {
      isIncludeMemorizedWord = value;
      print("$valueが選択された");
    });
  }

  _startWordListScreen(BuildContext context) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => WordListScreen()));
  }

  _StartTestScreen(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) =>TestScreen(isIncludeMemorizedWord: isIncludeMemorizedWord,)));
  }

  Widget_switch() {
    return SwitchListTile(
      title: Text("暗記済の単語を含む"),
      value: isIncludeMemorizedWord,
      onChanged: (value){
        setState(() {
          isIncludeMemorizedWord =value;
        });
      }

    );
  }
}

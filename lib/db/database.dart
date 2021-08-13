import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:moor/ffi.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';


class Words extends Table {
  TextColumn get strQuestion => text()();

  TextColumn get strAnswer => text()();

  BoolColumn get isMemorized =>boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {strQuestion};
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Words])
class MyDatabase extends _$MyDatabase {
  MyDatabase() :super (_openConnection());

  @override
  int get schemaVersion => 2;

//統合処理
  MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) {
  return m.createAll();
  },
  onUpgrade: (Migrator m, int from, int to) async {
    if (from == 1) {
      // we added the dueDate property in the change from version 1
      await m.addColumn(words, words.isMemorized);
    }
  }
  );
  //create
  Future addWord(Word word) => into(words).insert(word);

  //read
  Future <List<Word>> get allWords => select(words).get();

//Update
  Future updateWord(Word word) => update(words).replace(word);

//Delete
  Future deleteWord(Word word) =>
      (delete(words)
        ..where((t) => t.strQuestion.equals(word.strQuestion))).go();
}

import 'package:drift/drift.dart';

class DiaryWithTag extends Table {
  IntColumn get diaryId => integer().customConstraint('REFERENCES diary(id)')();

  IntColumn get tagId => integer().customConstraint('REFERENCES tag(id)')();

  @override
  List<String> get customConstraints => ['UNIQUE (diary_id, tag_id)'];
}

class Tag extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 20)(); // 내용

  @override
  List<String> get customConstraints => ['UNIQUE (name)'];
}

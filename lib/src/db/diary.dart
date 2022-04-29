import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';

import 'db.dart';
import 'tag.dart';

part 'diary.g.dart';

class DiaryWithTagModel {
  final DiaryData diaryData;
  final List<TagData> tagData;

  DiaryWithTagModel({
    required this.tagData,
    required this.diaryData,
  });
}

class Diary extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 32)(); // 제목

  TextColumn get content => text().named('body')(); // 내용

  DateTimeColumn get datetime =>
      dateTime().withDefault(Constant(DateTime.now()))(); // 작성날짜
}

@DriftAccessor(tables: [Diary, Tag, DiaryWithTag])
class DiaryDao extends DatabaseAccessor<Database> with _$DiaryDaoMixin {
  DiaryDao(Database db) : super(db);

  // 리스트 조회
  Stream<List<DiaryData>> diaryFindAll() => select(diary).watch();

  Stream<List<DiaryWithTagModel>> diaryWithTagFindAll() {
    final diaryStream = select(diary).watch();

    return diaryStream.switchMap((diaries) {
      final idToDiary = {for (var diary in diaries) diary.id: diary};

      final diaryIds = idToDiary.keys;

      final tagQuery = select(diaryWithTag).join([
        innerJoin(tag, tag.id.equalsExp(diaryWithTag.tagId)),
      ])
        ..where(diaryWithTag.diaryId.isIn(diaryIds));

      return tagQuery.watch().map((rows) {
        final idToTags = <int, List<TagData>>{};

        for (var row in rows) {
          final tags = row.readTable(tag);
          final id = row.readTable(diaryWithTag).diaryId;

          idToTags.putIfAbsent(id, () => []).add(tags);
        }

        return [
          for (var id in diaryIds)
            DiaryWithTagModel(diaryData: idToDiary[id]!, tagData: idToTags[id]!)
        ];
      });
    });
  }

  // 1개씩 조회
  Future<void> diaryFindId(DiaryCompanion entity) async {
    await (select(diary)..where((t) => t.id.equals(entity.id.value)))
        .getSingle();
  }

  // 생성
  Future diaryInsert(DiaryCompanion entity, String diaryTags) {
    // await into(diary).insert(entity);
    return transaction(() async {
      final tags =
          diaryTags.split(',').isNotEmpty ? diaryTags.split(',') : [diaryTags];

      final tagIds = [];

      for (var diaryTag in tags) {
        final tagCompanion = TagCompanion(name: Value(diaryTag));
        await into(tag).insert(
          tagCompanion,
          mode: InsertMode.insertOrIgnore,
        );
        final tagInst = await (select(tag)
              ..where((t) => t.name.equals(diaryTag)))
            .getSingle();
        tagIds.add(tagInst.id);
      }

      final diaryId = await into(diary).insert(entity);

      for (var tagId in tagIds) {
        await into(diaryWithTag).insert(
          DiaryWithTagCompanion(
            diaryId: Value(diaryId),
            tagId: Value(tagId),
          ),
        );
      }
    });
  }

  // 수정
  Future<void> diaryUpdate(DiaryCompanion entity) async {
    await update(diary).replace(entity);
  }

  Future<void> tagUpdate(TagCompanion entity) async {
    await update(tag).replace(entity);
  }

  // 삭제
  Future<void> diaryDelete(DiaryCompanion entity) async {
    await (delete(diary)..where((t) => t.id.equals(entity.id.value))).go();
  }
}

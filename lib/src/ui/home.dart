import 'package:drift_ex/src/db/db.dart';
import 'package:drift_ex/src/db/diary.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'page_diary_add.dart';
import 'page_diary_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    if (!GetIt.instance.isRegistered<DiaryDao>()) {
      final db = Database();

      GetIt.instance.registerSingleton<DiaryDao>(DiaryDao(db));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dao = GetIt.instance<DiaryDao>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('drift 예제'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DiaryAddPage(),
              ),
            ),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
        child: StreamBuilder<List<DiaryWithTagModel>>(
          stream: dao.diaryWithTagFindAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;

              return ListView.separated(
                itemBuilder: (_, index) {
                  final diary = data[index].diaryData;
                  final tag = data[index].tagData;
                  return DiaryCard(
                    title: diary.title,
                    content: diary.content,
                    createdAt: diary.datetime,
                    tags: tag.map((e) => e.name).toList(),
                  );
                },
                separatorBuilder: (_, index) {
                  return const Divider();
                },
                itemCount: data.length,
              );
            } else {
              return const Center(child: Text('일기장'));
            }
          },
        ),
      ),
    );
  }
}

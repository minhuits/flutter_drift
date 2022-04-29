import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:drift_ex/src/db/db.dart';
import 'package:drift_ex/src/db/diary.dart';

class DiaryAddPage extends StatefulWidget {
  const DiaryAddPage({Key? key}) : super(key: key);

  @override
  State<DiaryAddPage> createState() => _DiaryAddPageState();
}

class _DiaryAddPageState extends State<DiaryAddPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  String? title;
  String? content;
  String? tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('일기장 추가')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: renderTextFields(),
          ),
        ),
      ),
    );
  }

  renderTextFields() {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: '제목',
            ),
            onSaved: (val) {
              title = val;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: '내용',
            ),
            maxLines: 10,
            onSaved: (val) {
              content = val;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: '태그',
            ),
            onSaved: (val) {
              tag = val;
            },
          ),
          const SizedBox(height: 16),
          renderButton(),
        ],
      ),
    );
  }

  renderButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
      ),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();

          if (content != null && title != null) {
            final dao = GetIt.instance<DiaryDao>();

            await dao.diaryInsert(
              DiaryCompanion(
                title: Value(title!),
                content: Value(content!),
              ),
              tag!,
            );

            Navigator.of(context).pop();
          }
        }
      },
      child: const Text(
        '저장하기',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

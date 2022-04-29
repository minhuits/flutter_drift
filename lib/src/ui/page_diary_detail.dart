import 'package:flutter/material.dart';

class DiaryDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final List<String> tags;
  final DateTime createdAt;

  const DiaryDetailPage({
    Key? key,
    required this.title,
    required this.content,
    required this.tags,
    required this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateStr = '${createdAt.year}-${createdAt.month}-${createdAt.day}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('일기장 상세페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 32),
                ),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              content,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            renderTags(),
          ],
        ),
      ),
    );
  }

  renderTags() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: tags
          .map(
            (e) => Container(
              color: Colors.green,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: Text(
                  e,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

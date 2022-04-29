import 'package:flutter/material.dart';

import 'page_diary_detail.dart';

class DiaryCard extends StatefulWidget {
  final String title;
  final String content;
  final List<String> tags;
  final DateTime createdAt;

  const DiaryCard({
    Key? key,
    required this.title,
    required this.content,
    required this.tags,
    required this.createdAt,
  }) : super(key: key);

  @override
  State<DiaryCard> createState() => _DiaryCardState();
}

class _DiaryCardState extends State<DiaryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DiaryDetailPage(
                title: widget.title,
                content: widget.content,
                tags: widget.tags,
                createdAt: widget.createdAt,
              ),
            ),
          );
        },
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            renderBody(),
            const SizedBox(height: 16),
            renderTags(),
            const SizedBox(height: 16),
            renderDate(),
            const SizedBox(height: 12),
          ],
        ),
        // leading:
        // trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  renderBody() {
    return Text(
      widget.content,
      style: const TextStyle(fontSize: 18),
    );
  }

  renderDate() {
    final ca = widget.createdAt;
    final dateStr = '${ca.year}-${ca.month}-${ca.day}';

    return Text(
      '작성일 : ' + dateStr,
      style: const TextStyle(color: Colors.grey, fontSize: 18),
    );
  }

  renderTags() {
    return Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: widget.tags
            .map(
              (e) => Container(
                color: Colors.blueAccent.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 4.0,
                  ),
                  // padding: const EdgeInsets.all(4),
                  child: Text('# $e', style: const TextStyle(fontSize: 18)),
                ),
              ),
            )
            .toList());
  }
}

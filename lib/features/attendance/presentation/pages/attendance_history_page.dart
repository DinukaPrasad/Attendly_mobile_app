import 'package:flutter/material.dart';

class AttendanceHistoryPage extends StatelessWidget {
  const AttendanceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance History')),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (_, index) => ListTile(
          title: Text('Attendance #${index + 1}'),
          subtitle: const Text('Details placeholder'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';

class ConfirmAttendancePage extends StatelessWidget {
  const ConfirmAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Attendance')),
      body: Center(
        child: AppButton(
          label: 'Confirm',
          onPressed: () {
            // TODO: handle confirmation.
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

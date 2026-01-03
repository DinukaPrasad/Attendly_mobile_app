import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_textfield.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppTextField(hint: 'Email'),
            const SizedBox(height: 12),
            const AppTextField(hint: 'Password'),
            const SizedBox(height: 24),
            AppButton(
              label: 'Register',
              onPressed: () {
                // TODO: implement registration.
                context.go(RouteNames.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}

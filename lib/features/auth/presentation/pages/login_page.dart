import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/bloc/app_bloc.dart';
import '../../../../app/bloc/app_event.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
              label: 'Login',
              onPressed: () => context
                  .read<AppBloc>()
                  .add(const AppEventLoginRequested()),
            ),
            TextButton(
              onPressed: () => context.go(RouteNames.register),
              child: const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}

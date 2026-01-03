import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/bloc/app_bloc.dart';
import '../../../../app/bloc/app_event.dart';
import '../../../../app/bloc/app_state.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';

class ScanQrPage extends StatelessWidget {
  const ScanQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appBloc = context.watch<AppBloc>();

    if (appBloc.state is! AppStateAuthenticated) {
      return const Scaffold(body: AppLoader());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR'),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<AppBloc>().add(const AppEventLogoutRequested()),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Camera preview placeholder'),
            const SizedBox(height: 24),
            AppButton(
              label: 'Confirm Attendance',
              onPressed: () => context.go(RouteNames.confirm),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'View History',
              onPressed: () => context.go(RouteNames.history),
            ),
          ],
        ),
      ),
    );
  }
}

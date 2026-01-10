import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/scan_bloc.dart';
import '../bloc/scan_event.dart';
import '../bloc/scan_state.dart';
import 'confirm_screen.dart';

/// Screen for scanning QR codes to mark attendance.
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ScanBloc>()..add(const LoadActiveSessionsEvent()),
      child: const _ScanScreenContent(),
    );
  }
}

class _ScanScreenContent extends StatefulWidget {
  const _ScanScreenContent();

  @override
  State<_ScanScreenContent> createState() => _ScanScreenContentState();
}

class _ScanScreenContentState extends State<_ScanScreenContent> {
  final _qrController = TextEditingController();

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Attendance'), centerTitle: true),
      body: BlocConsumer<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state is QrValidated) {
            // Navigate to confirm screen with session data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<ScanBloc>(),
                  child: ConfirmScreen(session: state.session),
                ),
              ),
            );
          } else if (state is ScanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // QR Code visual placeholder
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'QR Scanner',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Text(
                          '(Camera integration pending)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Manual QR code input
                TextField(
                  controller: _qrController,
                  decoration: InputDecoration(
                    labelText: 'Enter QR Code Manually',
                    hintText: 'Paste or type QR code value',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.qr_code),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _qrController.clear(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Submit button
                ElevatedButton(
                  onPressed: state is ScanLoading
                      ? null
                      : () {
                          final qrCode = _qrController.text.trim();
                          if (qrCode.isNotEmpty) {
                            context.read<ScanBloc>().add(
                              ScanQrCodeEvent(qrCode: qrCode),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a QR code'),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: state is ScanLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Validate QR Code',
                          style: TextStyle(fontSize: 16),
                        ),
                ),

                const SizedBox(height: 24),

                // Active sessions info
                if (state is ActiveSessionsLoaded) ...[
                  Text(
                    'Active Sessions: ${state.sessions.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.sessions.length,
                      itemBuilder: (context, index) {
                        final session = state.sessions[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.event_available),
                            title: Text(session.name),
                            subtitle: Text('Course: ${session.courseId}'),
                            trailing: session.isActive
                                ? const Chip(
                                    label: Text('Active'),
                                    backgroundColor: Colors.green,
                                    labelStyle: TextStyle(color: Colors.white),
                                  )
                                : const Chip(
                                    label: Text('Inactive'),
                                    backgroundColor: Colors.grey,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

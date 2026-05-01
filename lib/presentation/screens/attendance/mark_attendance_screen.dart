import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/services/location_service.dart';
import '../../../data/datasources/attendance_remote_datasource.dart';
import '../../../data/repositories/attendance_repository_impl.dart';
import '../../../domain/usecases/mark_attendance_usecase.dart';
import '../../widgets/custom_button.dart';

class MarkAttendanceScreen extends StatefulWidget {
  final String token;
  final int userId;
  final int programmeId;

  const MarkAttendanceScreen({
    super.key,
    required this.token,
    required this.userId,
    required this.programmeId,
  });

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  late final MarkAttendanceUseCase _markAttendanceUseCase =
      MarkAttendanceUseCase(
        AttendanceRepositoryImpl(AttendanceRemoteDataSource()),
      );

  bool _isLoading = false;
  String? _currentStep;
  String? _errorMessage;

  Future<void> _onMarkAttendance() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Step 1: Verify biometric
      setState(() => _currentStep = 'Verifying identity...');
      final authenticated = await BiometricService.authenticate();
      if (!authenticated) {
        throw Exception('Biometric verification failed');
      }

      // Step 2: Get location
      setState(() => _currentStep = 'Getting location...');
      final position = await LocationService.getCurrentLocation();
      if (position == null) {
        throw Exception('Could not get location');
      }

      // Step 3: Mark attendance with location
      setState(() => _currentStep = 'Marking attendance...');
      await _markAttendanceUseCase(
        userId: widget.userId,
        programmeId: widget.programmeId,
        time: DateTime.now().toIso8601String(),
        status: 'PRESENT',
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) return;

      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentStep = null;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 28),
            SizedBox(width: 12),
            Text('Success'),
          ],
        ),
        content: const Text('Attendance marked successfully!'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Pop screen
            },
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Mark Attendance'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildInfoCard(),
            const SizedBox(height: 32),
            if (_errorMessage != null) ...[
              _buildErrorBanner(),
              const SizedBox(height: 24),
            ],
            if (_isLoading) ...[
              _buildStepIndicator(),
              const SizedBox(height: 32),
            ],
            const Spacer(),
            CustomButton(
              label: _isLoading
                  ? _currentStep ?? 'Processing...'
                  : 'Mark Attendance',
              onPressed: _isLoading ? null : _onMarkAttendance,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('User ID', widget.userId.toString()),
            const SizedBox(height: 12),
            _buildDetailRow('Programme ID', widget.programmeId.toString()),
            const SizedBox(height: 12),
            _buildDetailRow('Time', DateTime.now().toString().split('.')[0]),
            const SizedBox(height: 12),
            _buildDetailRow('Status', 'PRESENT'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 14, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Column(
      children: [
        _buildStep(
          'Verifying identity...',
          _currentStep == 'Verifying identity...',
        ),
        const SizedBox(height: 16),
        _buildStep(
          'Getting location...',
          _currentStep == 'Getting location...',
        ),
        const SizedBox(height: 16),
        _buildStep(
          'Marking attendance...',
          _currentStep == 'Marking attendance...',
        ),
      ],
    );
  }

  Widget _buildStep(String label, bool isActive) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : AppColors.inputBorder,
          ),
          child: isActive
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

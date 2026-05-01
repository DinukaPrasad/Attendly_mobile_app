import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/session_remote_datasource.dart';
import '../../../data/repositories/session_repository_impl.dart';
import '../../../domain/usecases/create_session_usecase.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class StartSessionScreen extends StatefulWidget {
  final String token;
  final int userId;

  const StartSessionScreen({
    super.key,
    required this.token,
    required this.userId,
  });

  @override
  State<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends State<StartSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _moduleController = TextEditingController();
  final _lecturerController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _codeController = TextEditingController();
  final _programmeIdController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _currentStep;

  late final CreateSessionUseCase _createSessionUseCase = CreateSessionUseCase(
    SessionRepositoryImpl(SessionRemoteDataSource()),
  );

  @override
  void dispose() {
    _moduleController.dispose();
    _lecturerController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _codeController.dispose();
    _programmeIdController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      if (!mounted) return;
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        final DateTime fullDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        controller.text = fullDateTime.toIso8601String();
      }
    }
  }

  Future<void> _onStartSession() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      setState(() => _currentStep = 'Starting session...');
      final sessionData = {
        'module': _moduleController.text.trim(),
        'lecturer': _lecturerController.text.trim(),
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'venue': _venueController.text.trim(),
        'code': _codeController.text.trim(),
        'programmeId': int.parse(_programmeIdController.text.trim()),
        'startTime': _startTimeController.text,
        'endTime': _endTimeController.text,
        'sessionStatus': 'ONGOING',
      };

      await _createSessionUseCase(sessionData);

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
        content: const Text('Session started successfully!'),
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
        title: const Text('Start Session'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              if (_errorMessage != null) ...[
                _buildErrorBanner(),
                const SizedBox(height: 16),
              ],
              CustomTextField(
                label: 'Module',
                controller: _moduleController,
                prefixIcon: const Icon(
                  Icons.school_outlined,
                  color: AppColors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Module is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Lecturer',
                controller: _lecturerController,
                prefixIcon: const Icon(
                  Icons.person_outlined,
                  color: AppColors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lecturer is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Title',
                controller: _titleController,
                prefixIcon: const Icon(
                  Icons.title,
                  color: AppColors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Description',
                controller: _descriptionController,
                prefixIcon: const Icon(
                  Icons.description_outlined,
                  color: AppColors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Venue',
                controller: _venueController,
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Venue is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Session Code',
                controller: _codeController,
                prefixIcon: const Icon(
                  Icons.tag,
                  color: AppColors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Session code is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Programme ID',
                controller: _programmeIdController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(
                  Icons.numbers,
                  color: AppColors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Programme ID is required';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Programme ID must be a number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDateTime(_startTimeController),
                child: CustomTextField(
                  label: 'Start Time',
                  controller: _startTimeController,
                  keyboardType: TextInputType.none,
                  prefixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textSecondary,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Start time is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDateTime(_endTimeController),
                child: CustomTextField(
                  label: 'End Time',
                  controller: _endTimeController,
                  keyboardType: TextInputType.none,
                  prefixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textSecondary,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'End time is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 28),
              if (_isLoading) ...[
                _buildStepIndicator(),
                const SizedBox(height: 24),
              ],
              CustomButton(
                label: _isLoading
                    ? _currentStep ?? 'Processing...'
                    : 'Start Session',
                onPressed: _isLoading ? null : _onStartSession,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
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
    return _buildStep('Starting session...', true);
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

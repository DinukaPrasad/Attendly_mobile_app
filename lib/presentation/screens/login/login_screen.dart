import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/validators.dart';
import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../home/home_screen.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  late final LoginUseCase _loginUseCase = LoginUseCase(
    AuthRepositoryImpl(AuthRemoteDataSource()),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final User user = await _loginUseCase(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      // Save token and user data for persistent login
      if (user.token != null) {
        await StorageService.saveToken(user.token!);
      }
      final userJson =
          '{"id":"${user.id}","name":"${user.name}","email":"${user.email}","token":"${user.token}","role":"${user.role ?? ''}"}';
      await StorageService.saveUser(userJson);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildHeader(),
                const SizedBox(height: 40),
                if (_errorMessage != null) ...[
                  _buildErrorBanner(),
                  const SizedBox(height: 16),
                ],
                CustomTextField(
                  label: AppStrings.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.textSecondary,
                  ),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.password,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: 28),
                CustomButton(
                  label: AppStrings.login,
                  onPressed: _onLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
                _buildRegisterRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.event_available,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.loginTitle,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.loginSubtitle,
          style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.noAccount,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterScreen()),
          ),
          child: const Text(
            AppStrings.signUp,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../injection.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';

/// Registration screen using BLoC pattern
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthDI.registerBloc,
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          // Handle navigation on success
          if (state.status == RegisterStatus.success) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.scan, (_) => false);
          }

          // Handle navigate to login
          if (state.status == RegisterStatus.navigateToLogin) {
            Navigator.of(context).pop();
          }

          // Show error snackbar on failure
          if (state.status == RegisterStatus.failure &&
              state.errorMessage != null) {
            AppSnackbar.showError(
              context,
              title: 'Registration Failed',
              message: state.errorMessage!,
            );
          }
        },
        child: _RegisterScreenContent(
          formKey: _formKey,
          emailController: _emailController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
        ),
      ),
    );
  }
}

/// Extracted content widget to access BLoC context properly
class _RegisterScreenContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _RegisterScreenContent({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  void _register(BuildContext context) {
    context.read<RegisterBloc>().add(
      RegisterEmailPressed(
        email: emailController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      ),
    );
  }

  void _signUpWithGoogle(BuildContext context) {
    context.read<RegisterBloc>().add(const RegisterGooglePressed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Join Attendly',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Create your account to get started',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Email text field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Password text field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Confirm password text field
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Register button
              BlocBuilder<RegisterBloc, RegisterState>(
                buildWhen: (previous, current) =>
                    previous.isLoading != current.isLoading,
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () => _register(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(fontSize: 16),
                          ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // OR divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),

              // Google sign-up button
              BlocBuilder<RegisterBloc, RegisterState>(
                buildWhen: (previous, current) =>
                    previous.isLoading != current.isLoading,
                builder: (context, state) {
                  return OutlinedButton.icon(
                    onPressed: state.isLoading
                        ? null
                        : () => _signUpWithGoogle(context),
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    label: const Text('Sign up with Google'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

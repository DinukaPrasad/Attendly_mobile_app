import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../injection.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

/// Login screen using BLoC pattern
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthDI.loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          // AuthGate will handle navigation on success via auth state stream
          // Just show success feedback
          if (state.status == LoginStatus.success) {
            // AuthGate will automatically redirect - no manual navigation needed
            // The auth state stream will emit the new user and AuthGate will show ScanScreen
          }

          // Handle phone login navigation
          if (state.status == LoginStatus.navigateToPhone) {
            AppSnackbar.showInfo(
              context,
              title: 'Coming Soon',
              message: 'Phone sign-in coming soon',
            );
          }

          // Show error snackbar on failure
          if (state.status == LoginStatus.failure &&
              state.errorMessage != null) {
            AppSnackbar.showError(
              context,
              title: 'Login Failed',
              message: state.errorMessage!,
            );
          }
        },
        child: _LoginScreenContent(
          emailController: _emailController,
          passwordController: _passwordController,
        ),
      ),
    );
  }
}

/// Extracted content widget to access BLoC context properly
class _LoginScreenContent extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _LoginScreenContent({
    required this.emailController,
    required this.passwordController,
  });

  void _login(BuildContext context) {
    context.read<LoginBloc>().add(
      LoginEmailPressed(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }

  void _signInWithGoogle(BuildContext context) {
    context.read<LoginBloc>().add(const LoginGooglePressed());
  }

  void _signInWithPhone(BuildContext context) {
    context.read<LoginBloc>().add(const LoginPhonePressed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gap(40.h),
            Text(
              'Welcome to Attendly',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Gap(32.h),

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
            Gap(16.h),

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
            Gap(24.h),

            // Login button - uses BlocBuilder for loading state
            BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
                  previous.isLoading != current.isLoading,
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.isLoading ? null : () => _login(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: state.isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text('Login', style: TextStyle(fontSize: 16.sp)),
                );
              },
            ),
            Gap(16.h),

            // Register link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.register),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Gap(32.h),

            // OR divider
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
            Gap(24.h),

            // Google sign-in button - uses BlocBuilder for loading state
            BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
                  previous.isLoading != current.isLoading,
              builder: (context, state) {
                return OutlinedButton.icon(
                  onPressed: state.isLoading
                      ? null
                      : () => _signInWithGoogle(context),
                  icon: Icon(Icons.g_mobiledata, size: 24.sp),
                  label: const Text('Sign in with Google'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                );
              },
            ),
            Gap(12.h),

            // Phone sign-in button - uses BlocBuilder for loading state
            BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
                  previous.isLoading != current.isLoading,
              builder: (context, state) {
                return OutlinedButton.icon(
                  onPressed: state.isLoading
                      ? null
                      : () => _signInWithPhone(context),
                  icon: Icon(Icons.phone_outlined, size: 20.sp),
                  label: const Text('Sign in with Phone'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

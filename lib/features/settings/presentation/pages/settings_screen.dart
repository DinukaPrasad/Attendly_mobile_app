import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/app_settings.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

/// Screen for managing application settings.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>()..add(const LoadSettingsEvent()),
      child: const _SettingsScreenContent(),
    );
  }
}

class _SettingsScreenContent extends StatelessWidget {
  const _SettingsScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is SettingsCleared) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Settings cleared'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            SettingsInitial() || SettingsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            SettingsLoaded(:final settings) => _buildSettingsList(
              context,
              settings,
            ),
            SettingsSaving(:final currentSettings) => _buildSettingsList(
              context,
              currentSettings,
              isSaving: true,
            ),
            SettingsError(:final previousSettings)
                when previousSettings != null =>
              _buildSettingsList(context, previousSettings),
            SettingsError() => _buildErrorState(context),
            SettingsCleared() => const Center(
              child: CircularProgressIndicator(),
            ),
          };
        },
      ),
    );
  }

  Widget _buildSettingsList(
    BuildContext context,
    AppSettings settings, {
    bool isSaving = false,
  }) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Appearance Section
            _SectionHeader(title: 'Appearance'),
            _ThemeModeCard(
              currentMode: settings.themeMode,
              onChanged: (mode) => context.read<SettingsBloc>().add(
                UpdateThemeModeEvent(themeMode: mode),
              ),
            ),
            const SizedBox(height: 24),

            // Privacy & Security Section
            _SectionHeader(title: 'Privacy & Security'),
            _SettingsTile(
              icon: Icons.fingerprint,
              title: 'Biometric Authentication',
              subtitle: 'Use fingerprint or face ID to sign in',
              trailing: Switch(
                value: settings.biometricEnabled,
                onChanged: (value) => context.read<SettingsBloc>().add(
                  ToggleBiometricEvent(enabled: value),
                ),
              ),
            ),
            _SettingsTile(
              icon: Icons.location_on,
              title: 'Location Tracking',
              subtitle: 'Allow app to access your location',
              trailing: Switch(
                value: settings.locationTrackingEnabled,
                onChanged: (value) => context.read<SettingsBloc>().add(
                  ToggleLocationTrackingEvent(enabled: value),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Notifications Section
            _SectionHeader(title: 'Notifications'),
            _SettingsTile(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive attendance reminders',
              trailing: Switch(
                value: settings.notificationsEnabled,
                onChanged: (value) => context.read<SettingsBloc>().add(
                  ToggleNotificationsEvent(enabled: value),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // About Section
            _SectionHeader(title: 'About'),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'App Version',
              subtitle: '1.0.0',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () {
                // TODO: Navigate to terms
              },
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                // TODO: Navigate to privacy policy
              },
            ),
            const SizedBox(height: 24),

            // Danger Zone
            _SectionHeader(title: 'Danger Zone', isDestructive: true),
            _SettingsTile(
              icon: Icons.delete_outline,
              title: 'Reset Settings',
              subtitle: 'Clear all settings and restore defaults',
              iconColor: Colors.red,
              onTap: () => _showClearSettingsDialog(context),
            ),
          ],
        ),

        // Loading overlay
        if (isSaving)
          Container(
            color: Colors.black26,
            child: const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Failed to load settings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<SettingsBloc>().add(const LoadSettingsEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showClearSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset Settings?'),
        content: const Text(
          'This will clear all your settings and restore defaults. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SettingsBloc>().add(const ClearSettingsEvent());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDestructive;

  const _SectionHeader({required this.title, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isDestructive ? Colors.red : Colors.grey,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing:
            trailing ??
            (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      ),
    );
  }
}

class _ThemeModeCard extends StatelessWidget {
  final AppThemeMode currentMode;
  final ValueChanged<AppThemeMode> onChanged;

  const _ThemeModeCard({required this.currentMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette_outlined),
                const SizedBox(width: 12),
                Text(
                  'Theme Mode',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<AppThemeMode>(
              segments: const [
                ButtonSegment(
                  value: AppThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.phone_android),
                ),
                ButtonSegment(
                  value: AppThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: AppThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode),
                ),
              ],
              selected: {currentMode},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  onChanged(selection.first);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

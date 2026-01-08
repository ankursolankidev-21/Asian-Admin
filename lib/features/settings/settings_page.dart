import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_event.dart';
import '../../bloc/theme/theme_state.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _AppearanceSection(),
          SizedBox(height: 24),
          _BusinessInfoSection(),
          SizedBox(height: 24),
          _AccountSection(),
        ],
      ),
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appearance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return DropdownButtonFormField<ThemeMode>(
                value: state.themeMode,
                decoration: const InputDecoration(
                  labelText: 'Theme Mode',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System Default'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark'),
                  ),
                ],
                onChanged: (mode) {
                  if (mode != null) {
                    context.read<ThemeBloc>().add(ChangeTheme(mode));
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}


class _BusinessInfoSection extends StatelessWidget {
  const _BusinessInfoSection();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          const AppTextField(
            label: 'Company Name',
            showRequiredMark: true,
          ),
          const SizedBox(height: 12),

          const AppTextField(
            label: 'Support Phone',
          ),
          const SizedBox(height: 12),

          const AppTextField(
            label: 'Support Email',
          ),
          const SizedBox(height: 12),

          const AppTextField(
            label: 'Office Address',
          ),

          const SizedBox(height: 20),

          AppButton(
            text: 'Save Business Info',
            onTap: () {
              // UI only for now
            },
          ),
        ],
      ),
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          const AppTextField(
            label: 'New Password',
            obscure: true,
          ),
          const SizedBox(height: 12),

          const AppTextField(
            label: 'Confirm Password',
            obscure: true,
          ),
          const SizedBox(height: 20),

          AppButton(
            text: 'Update Password',
            onTap: () {
              // Firebase later
            },
          ),
        ],
      ),
    );
  }
}

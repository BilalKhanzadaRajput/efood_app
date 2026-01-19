import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../business/bloc/theme/theme_cubit.dart';

class ThemeSettingsBottomSheet extends StatelessWidget {
  const ThemeSettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Material(
        color: scheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.settings, color: scheme.onSurface),
                  const SizedBox(width: 8),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) {
                  final isDark = mode == ThemeMode.dark;
                  return SwitchListTile(
                    value: isDark,
                    onChanged: (v) {
                      context.read<ThemeCubit>().setDarkMode(v);
                    },
                    secondary: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: AppColors.coralRed,
                    ),
                    title: Text(
                      'Dark mode',
                      style: TextStyle(color: scheme.onSurface),
                    ),
                    subtitle: Text(
                      isDark ? 'Enabled' : 'Disabled',
                      style:
                          TextStyle(color: scheme.onSurface.withOpacity(0.7)),
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


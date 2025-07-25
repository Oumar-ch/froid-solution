import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../constants/app_icons.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = AppColors.getNeonColor(isDark);
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      appBar: AppBar(
        title: Text('BIENVENUE', style: AppTextStyles.title(isDark)),
        backgroundColor: AppColors.getSurfaceColor(isDark),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: neon),
        actions: [
          IconButton(
            icon: Icon(AppIcons.reminders),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: Icon(AppIcons.settings),
            tooltip: 'Paramètres',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ac_unit, size: 64, color: neon),
            const SizedBox(height: 24),
            Text(
              'Bienvenue dans Froid Solutions\nApplication de gestion de maintenance',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(isDark).copyWith(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../i18n/app_localizations.dart';
import '../i18n/language_provider.dart';
import '../theme/app_theme.dart';
import 'health/health_screen.dart';
import 'home/home_screen.dart';
import 'machines/machines_screen.dart';
import 'progress/progress_screen.dart';
import 'routine/routine_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    MachinesScreen(),
    RoutineScreen(),
    ProgressScreen(),
    HealthScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Watch language changes so labels rebuild on language switch
    final NavStrings nav = context.watch<LanguageProvider>().strings.nav;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF2A2A2A)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) => setState(() => _currentIndex = index),
          backgroundColor: AppTheme.surfaceDark,
          selectedItemColor: AppTheme.primaryOrange,
          unselectedItemColor: const Color(0xFF666666),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: nav.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.fitness_center_rounded),
              label: nav.machines,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_rounded),
              label: nav.routine,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_rounded),
              label: nav.progress,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.watch_rounded),
              label: nav.watch,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../providers/pr_streak_provider.dart';
import '../../theme/app_theme.dart';
import 'widgets/collection_tab.dart';
import 'widgets/prs_tab.dart';
import 'widgets/streak_tab.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    unawaited(context.read<PrStreakProvider>().loadAll());
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AchievementsStrings s =
        context.watch<LanguageProvider>().strings.achievements;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.title),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppTheme.primaryOrange,
          labelColor: AppTheme.primaryOrange,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: <Widget>[
            Tab(text: s.tabPrs),
            Tab(text: s.tabStreak),
            Tab(text: s.tabAchievements),
          ],
        ),
      ),
      body: Consumer<PrStreakProvider>(
        builder: (BuildContext context, PrStreakProvider provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryOrange,
              ),
            );
          }
          return TabBarView(
            controller: _tab,
            children: <Widget>[
              PrTab(provider: provider),
              StreakTab(provider: provider),
              AchievementsTab(provider: provider),
            ],
          );
        },
      ),
    );
  }
}

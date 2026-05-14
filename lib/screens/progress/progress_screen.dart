import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../providers/workout_provider.dart';
import '../../theme/app_theme.dart';
import 'widgets/add_measurement_sheet.dart';
import 'widgets/history_tab.dart';
import 'widgets/measurements_tab.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(context.read<ProgressProvider>().loadProgress());
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressStrings s = context.watch<LanguageProvider>().strings.progress;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddMeasurementDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppTheme.primaryOrange,
          labelColor: AppTheme.primaryOrange,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: <Widget>[
            Tab(text: s.tabMeasurements),
            Tab(text: s.tabHistory),
          ],
        ),
      ),
      body: Consumer<ProgressProvider>(
        builder: (BuildContext context, ProgressProvider provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryOrange,
              ),
            );
          }
          return TabBarView(
            controller: _tabCtrl,
            children: <Widget>[
              MeasurementsTab(provider: provider),
              HistoryTab(provider: provider),
            ],
          );
        },
      ),
    );
  }

  void _showAddMeasurementDialog(BuildContext context) {
    unawaited(showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ChangeNotifierProvider<ProgressProvider>.value(
        value: context.read<ProgressProvider>(),
        child: const AddMeasurementSheet(),
      ),
    ),);
  }
}

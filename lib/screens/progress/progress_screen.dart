import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/ui/progress_model.dart';
import '../../theme/app_theme.dart';
import '../progress_tab/progress_presenter.dart';
import 'widgets/add_measurement_sheet.dart';
import 'widgets/history_tab.dart';
import 'widgets/measurements_tab.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin
    implements ProgressView {
  late ProgressPresenter _presenter;
  late TabController _tabCtrl;
  ProgressModel? _model;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _presenter = ProgressPresenter(view: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _presenter.getUI(context);
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _presenter.dispose();
    super.dispose();
  }

  @override
  void setUI(ProgressModel model) {
    if (mounted) {
      setState(() => _model = model);
    }
  }

  @override
  void showAddSheet() => _showAddMeasurementDialog(context);

  @override
  Widget build(BuildContext context) {
    if (_model == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryOrange),
        ),
      );
    }
    final ProgressModel m = _model!;
    return Scaffold(
      appBar: AppBar(
        title: Text(m.strings.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _presenter.onAddTap(),
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppTheme.primaryOrange,
          labelColor: AppTheme.primaryOrange,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: <Widget>[
            Tab(text: m.strings.tabMeasurements),
            Tab(text: m.strings.tabHistory),
          ],
        ),
      ),
      body: m.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryOrange),
            )
          : TabBarView(
              controller: _tabCtrl,
              children: <Widget>[
                MeasurementsTab(model: m, presenter: _presenter),
                HistoryTab(model: m, presenter: _presenter),
              ],
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
      builder: (_) => AddMeasurementSheet(presenter: _presenter),
    ),);
  }
}

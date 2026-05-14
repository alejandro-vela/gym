import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/body_measurement.dart';
import '../../models/routine_exercise.dart';
import '../../providers/workout_provider.dart';
import '../../theme/app_theme.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Progreso'),
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
          tabs: const <Widget>[
            Tab(text: 'Medidas'),
            Tab(text: 'Historial'),
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
              _MeasurementsTab(provider: provider),
              _HistoryTab(provider: provider),
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
        child: const _AddMeasurementSheet(),
      ),
    ),);
  }
}

class _MeasurementsTab extends StatelessWidget {
  const _MeasurementsTab({required this.provider});
  final ProgressProvider provider;

  @override
  Widget build(BuildContext context) {
    final List<BodyMeasurement> measurements = provider.measurements;
    final BodyMeasurement? latest = provider.latestMeasurement;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        // Stats row
        Row(
          children: <Widget>[
            _StatBox(
              label: 'Entrenos',
              value: '${provider.totalWorkouts}',
              icon: Icons.fitness_center_rounded,
              color: AppTheme.primaryOrange,
            ),
            const SizedBox(width: 12),
            _StatBox(
              label: 'Minutos totales',
              value: '${provider.totalMinutes}',
              icon: Icons.timer_rounded,
              color: AppTheme.info,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Weight chart
        if (measurements.length >= 2) ...<Widget>[
          const _SectionTitle('Evolución del peso'),
          const SizedBox(height: 8),
          _WeightChart(measurements: measurements),
          const SizedBox(height: 20),
        ],

        // Latest measurements
        if (latest != null) ...<Widget>[
          const _SectionTitle('Última medición'),
          const SizedBox(height: 8),
          Text(
            DateFormat('d MMM yyyy').format(latest.date),
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          _MeasurementGrid(measurement: latest),
          const SizedBox(height: 20),
        ],

        // History list
        const _SectionTitle('Historial de mediciones'),
        const SizedBox(height: 8),
        if (measurements.isEmpty)
          const _EmptyMeasurements()
        else
          ...measurements.map(
            (BodyMeasurement m) => _MeasurementHistoryCard(
              measurement: m,
              onDelete: () => unawaited(
                provider.deleteMeasurement(m.id!),
              ),
            ),
          ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _WeightChart extends StatelessWidget {
  const _WeightChart({required this.measurements});
  final List<BodyMeasurement> measurements;

  @override
  Widget build(BuildContext context) {
    final List<BodyMeasurement> weightsWithDate = measurements
        .where((BodyMeasurement m) => m.weight != null)
        .toList()
        .reversed
        .toList();

    if (weightsWithDate.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<FlSpot> spots = weightsWithDate
        .asMap()
        .entries
        .map(
          (MapEntry<int, BodyMeasurement> e) =>
              FlSpot(e.key.toDouble(), e.value.weight!),
        )
        .toList();

    final double minW = spots
            .map((FlSpot s) => s.y)
            .reduce((double a, double b) => a < b ? a : b) -
        2;
    final double maxW = spots
            .map((FlSpot s) => s.y)
            .reduce((double a, double b) => a > b ? a : b) +
        2;

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            getDrawingHorizontalLine: (_) => const FlLine(
              color: Color(0xFF2A2A2A),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (_) =>
                const FlLine(color: Colors.transparent),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (double v, _) => Text(
                  '${v.toInt()}kg',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            bottomTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          minY: minW,
          maxY: maxW,
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppTheme.primaryOrange,
              barWidth: 2.5,
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              ),
              dotData: FlDotData(
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 3,
                  color: AppTheme.primaryOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementGrid extends StatelessWidget {
  const _MeasurementGrid({required this.measurement});
  final BodyMeasurement measurement;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = <Map<String, dynamic>>[
      if (measurement.weight != null)
        <String, dynamic>{
          'label': 'Peso',
          'value': '${measurement.weight!.toStringAsFixed(1)}kg',
          'color': AppTheme.primaryOrange,
        },
      if (measurement.bodyFatPercent != null)
        <String, dynamic>{
          'label': 'Grasa corporal',
          'value': '${measurement.bodyFatPercent!.toStringAsFixed(1)}%',
          'color': AppTheme.warning,
        },
      if (measurement.chest != null)
        <String, dynamic>{
          'label': 'Pecho',
          'value': '${measurement.chest}cm',
          'color': AppTheme.info,
        },
      if (measurement.waist != null)
        <String, dynamic>{
          'label': 'Cintura',
          'value': '${measurement.waist}cm',
          'color': AppTheme.success,
        },
      if (measurement.leftArm != null)
        <String, dynamic>{
          'label': 'Brazo izq.',
          'value': '${measurement.leftArm}cm',
          'color': AppTheme.info,
        },
      if (measurement.rightArm != null)
        <String, dynamic>{
          'label': 'Brazo der.',
          'value': '${measurement.rightArm}cm',
          'color': AppTheme.info,
        },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.4,
      ),
      itemCount: items.length,
      itemBuilder: (_, int i) {
        final Map<String, dynamic> item = items[i];
        final Color color = item['color'] as Color;
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                item['value'] as String,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item['label'] as String,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MeasurementHistoryCard extends StatelessWidget {
  const _MeasurementHistoryCard({
    required this.measurement,
    required this.onDelete,
  });
  final BodyMeasurement measurement;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('meas_${measurement.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.danger.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_rounded, color: AppTheme.danger),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.monitor_weight_rounded,
              color: AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DateFormat('d MMMM yyyy').format(measurement.date),
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (measurement.weight != null)
                    Text(
                      'Peso: ${measurement.weight!.toStringAsFixed(1)}kg'
                      '${measurement.waist != null ? ' · Cintura: ${measurement.waist}cm' : ''}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.provider});
  final ProgressProvider provider;

  @override
  Widget build(BuildContext context) {
    final List<WorkoutSession> sessions = provider.sessions;

    if (sessions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.history_rounded,
              color: AppTheme.textSecondary,
              size: 50,
            ),
            SizedBox(height: 12),
            Text(
              'Sin historial de entrenos',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 17),
            ),
            Text(
              'Completa tu primer entreno para\nver tu historial aquí',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: sessions.length,
      itemBuilder: (_, int i) {
        final WorkoutSession s = sessions[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: AppTheme.primaryOrange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat('EEEE d MMM yyyy').format(s.date),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      s.durationMinutes != null
                          ? '⏱ ${s.durationMinutes} minutos'
                          : 'Entreno completado',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '✓',
                  style: TextStyle(
                    color: AppTheme.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _EmptyMeasurements extends StatelessWidget {
  const _EmptyMeasurements();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        children: <Widget>[
          Icon(
            Icons.monitor_weight_rounded,
            color: AppTheme.textSecondary,
            size: 40,
          ),
          SizedBox(height: 8),
          Text(
            'Sin mediciones registradas',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            'Presiona + para agregar tu primera medición',
            style: TextStyle(color: Color(0xFF555555), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Add Measurement Sheet ─────────────────────────────────────
class _AddMeasurementSheet extends StatefulWidget {
  const _AddMeasurementSheet();

  @override
  State<_AddMeasurementSheet> createState() => _AddMeasurementSheetState();
}

class _AddMeasurementSheetState extends State<_AddMeasurementSheet> {
  final Map<String, TextEditingController> _controllers =
      <String, TextEditingController>{
    'weight': TextEditingController(),
    'bodyFat': TextEditingController(),
    'chest': TextEditingController(),
    'waist': TextEditingController(),
    'hips': TextEditingController(),
    'leftArm': TextEditingController(),
    'rightArm': TextEditingController(),
    'leftThigh': TextEditingController(),
    'rightThigh': TextEditingController(),
    'notes': TextEditingController(),
  };
  bool _isSaving = false;

  double? _parse(String key) {
    final String t = _controllers[key]!.text.trim();
    return t.isEmpty ? null : double.tryParse(t);
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final BodyMeasurement measurement = BodyMeasurement(
      date: DateTime.now(),
      weight: _parse('weight'),
      bodyFatPercent: _parse('bodyFat'),
      chest: _parse('chest'),
      waist: _parse('waist'),
      hips: _parse('hips'),
      leftArm: _parse('leftArm'),
      rightArm: _parse('rightArm'),
      leftThigh: _parse('leftThigh'),
      rightThigh: _parse('rightThigh'),
      notes: _controllers['notes']!.text.trim(),
    );
    await context.read<ProgressProvider>().addMeasurement(measurement);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    for (final TextEditingController c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.92,
        minChildSize: 0.5,
        builder: (_, ScrollController scrollController) => Column(
          children: <Widget>[
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF444444),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Row(
                children: <Widget>[
                  const Text(
                    'Nueva medición',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primaryOrange,
                            ),
                          )
                        : const Text(
                            'Guardar',
                            style: TextStyle(
                              color: AppTheme.primaryOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: <Widget>[
                  _MeasField(
                    ctrl: _controllers['weight']!,
                    label: 'Peso (kg)',
                    icon: Icons.monitor_weight_rounded,
                  ),
                  _MeasField(
                    ctrl: _controllers['bodyFat']!,
                    label: '% Grasa corporal',
                    icon: Icons.percent_rounded,
                  ),
                  const Divider(height: 20),
                  _MeasField(
                    ctrl: _controllers['chest']!,
                    label: 'Pecho (cm)',
                    icon: Icons.straighten_rounded,
                  ),
                  _MeasField(
                    ctrl: _controllers['waist']!,
                    label: 'Cintura (cm)',
                    icon: Icons.straighten_rounded,
                  ),
                  _MeasField(
                    ctrl: _controllers['hips']!,
                    label: 'Cadera (cm)',
                    icon: Icons.straighten_rounded,
                  ),
                  _MeasField(
                    ctrl: _controllers['leftArm']!,
                    label: 'Brazo izquierdo (cm)',
                    icon: Icons.straighten_rounded,
                  ),
                  _MeasField(
                    ctrl: _controllers['rightArm']!,
                    label: 'Brazo derecho (cm)',
                    icon: Icons.straighten_rounded,
                  ),
                  _MeasField(
                    ctrl: _controllers['leftThigh']!,
                    label: 'Muslo izquierdo (cm)',
                    icon: Icons.straighten_rounded,
                  ),
                  _MeasField(
                    ctrl: _controllers['rightThigh']!,
                    label: 'Muslo derecho (cm)',
                    icon: Icons.straighten_rounded,
                  ),
                  const Divider(height: 20),
                  TextField(
                    controller: _controllers['notes'],
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notas opcionales',
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasField extends StatelessWidget {
  const _MeasField({
    required this.ctrl,
    required this.label,
    required this.icon,
  });
  final TextEditingController ctrl;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 18),
        ),
        style: const TextStyle(color: AppTheme.textPrimary),
      ),
    );
  }
}

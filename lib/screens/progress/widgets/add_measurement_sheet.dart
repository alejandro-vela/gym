import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../models/body_measurement.dart';
import '../../../theme/app_theme.dart';
import '../../progress_tab/progress_presenter.dart';

class AddMeasurementSheet extends StatefulWidget {
  const AddMeasurementSheet({super.key, required this.presenter});

  final ProgressPresenter presenter;

  @override
  State<AddMeasurementSheet> createState() => _AddMeasurementSheetState();
}

class _AddMeasurementSheetState extends State<AddMeasurementSheet> {
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
    await widget.presenter.addMeasurement(context, measurement);
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
    final AppLocalizations loc = context.read<LanguageProvider>().strings;
    final ProgressStrings ps = loc.progress;
    final CommonStrings cs = loc.common;

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    ps.addMeasurement,
                    style: const TextStyle(
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
                        : Text(
                            cs.save,
                            style: const TextStyle(
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
                  MeasField(
                    ctrl: _controllers['weight']!,
                    label: ps.fieldWeight,
                    icon: Icons.monitor_weight_rounded,
                  ),
                  MeasField(
                    ctrl: _controllers['bodyFat']!,
                    label: ps.fieldBodyFat,
                    icon: Icons.percent_rounded,
                  ),
                  const Divider(height: 20),
                  MeasField(
                    ctrl: _controllers['chest']!,
                    label: ps.fieldChest,
                    icon: Icons.straighten_rounded,
                  ),
                  MeasField(
                    ctrl: _controllers['waist']!,
                    label: ps.fieldWaist,
                    icon: Icons.straighten_rounded,
                  ),
                  MeasField(
                    ctrl: _controllers['hips']!,
                    label: ps.fieldHips,
                    icon: Icons.straighten_rounded,
                  ),
                  MeasField(
                    ctrl: _controllers['leftArm']!,
                    label: ps.fieldLeftArm,
                    icon: Icons.straighten_rounded,
                  ),
                  MeasField(
                    ctrl: _controllers['rightArm']!,
                    label: ps.fieldRightArm,
                    icon: Icons.straighten_rounded,
                  ),
                  MeasField(
                    ctrl: _controllers['leftThigh']!,
                    label: ps.fieldLeftThigh,
                    icon: Icons.straighten_rounded,
                  ),
                  MeasField(
                    ctrl: _controllers['rightThigh']!,
                    label: ps.fieldRightThigh,
                    icon: Icons.straighten_rounded,
                  ),
                  const Divider(height: 20),
                  TextField(
                    controller: _controllers['notes'],
                    maxLines: 2,
                    decoration: InputDecoration(labelText: cs.optionalNotes),
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

class MeasField extends StatelessWidget {
  const MeasField({
    super.key,
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

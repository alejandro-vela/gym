import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/machine.dart';
import '../../models/routine_exercise.dart';
import '../../providers/machines_provider.dart';
import '../../providers/routine_provider.dart';
import '../../theme/app_theme.dart';
import 'widgets/exercise_day_banner.dart';
import 'widgets/weight_input_row.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({
    super.key,
    required this.dayOfWeek,
    this.exercise,
  });
  final int dayOfWeek;
  final RoutineExercise? exercise;

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _notesCtrl;

  int _sets = 3;
  int _reps = 10;
  double _weight = 0;
  Machine? _selectedMachine;
  bool _isSaving = false;

  bool get _isEditing => widget.exercise != null;

  @override
  void initState() {
    super.initState();
    final RoutineExercise? e = widget.exercise;
    _nameCtrl = TextEditingController(text: e?.exerciseName ?? '');
    _notesCtrl = TextEditingController(text: e?.notes ?? '');
    _sets = e?.targetSets ?? 3;
    _reps = e?.targetReps ?? 10;
    _weight = e?.targetWeight ?? 0;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isSaving = true);

    final List<RoutineExercise> exercises =
        context.read<RoutineProvider>().exercisesForDay(widget.dayOfWeek);
    final RoutineExercise exercise = RoutineExercise(
      id: widget.exercise?.id,
      dayOfWeek: widget.dayOfWeek,
      machineId: _selectedMachine?.id,
      exerciseName: _nameCtrl.text.trim(),
      targetSets: _sets,
      targetReps: _reps,
      targetWeight: _weight,
      notes: _notesCtrl.text.trim(),
      orderIndex:
          _isEditing ? (widget.exercise?.orderIndex ?? 0) : exercises.length,
    );

    final RoutineProvider provider = context.read<RoutineProvider>();
    if (_isEditing) {
      await provider.updateExercise(exercise);
    } else {
      await provider.addExercise(exercise);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = context.read<LanguageProvider>().strings;
    final AddExerciseStrings s = loc.addExercise;
    final RoutineStrings rs = loc.routine;
    final CommonStrings cs = loc.common;
    final List<Machine> machines = context.read<MachinesProvider>().machines;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? s.titleEdit : s.titleNew),
        actions: <Widget>[
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            ExerciseDayBanner(
              strings: rs,
              dayOfWeek: widget.dayOfWeek,
            ),
            const SizedBox(height: 20),

            if (machines.isNotEmpty) ...<Widget>[
              Text(
                s.linkMachineLabel,
                style: const TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Machine?>(
                initialValue: _selectedMachine,
                dropdownColor: AppTheme.cardDark,
                decoration: InputDecoration(
                  labelText: s.linkMachineLabel,
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
                items: <DropdownMenuItem<Machine?>>[
                  DropdownMenuItem<Machine?>(
                    child: Text(
                      s.noMachine,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                  ...machines.map(
                    (Machine m) => DropdownMenuItem<Machine?>(
                      value: m,
                      child: Text(
                        m.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: (Machine? m) {
                  setState(() {
                    _selectedMachine = m;
                    if (m != null && _nameCtrl.text.isEmpty) {
                      _nameCtrl.text = m.name;
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
            ],

            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: s.fieldName,
              ),
              style: const TextStyle(color: AppTheme.textPrimary),
              validator: (String? v) =>
                  v == null || v.isEmpty ? cs.requiredField : null,
            ),
            const SizedBox(height: 20),

            Text(
              s.sectionParams,
              style: const TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: NumberInput(
                    label: s.fieldSets,
                    value: _sets,
                    min: 1,
                    max: 20,
                    onChanged: (int v) => setState(() => _sets = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NumberInput(
                    label: s.fieldReps,
                    value: _reps,
                    min: 1,
                    max: 100,
                    onChanged: (int v) => setState(() => _reps = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            WeightInputRow(
              label: s.fieldWeight,
              helperText: s.weightHelper,
              value: _weight,
              onChanged: (double v) => setState(() => _weight = v),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _notesCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: s.fieldNotes,
                hintText: s.notesHint,
              ),
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

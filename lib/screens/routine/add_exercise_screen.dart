import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/machine.dart';
import '../../models/routine_exercise.dart';
import '../../providers/machines_provider.dart';
import '../../providers/routine_provider.dart';
import '../../theme/app_theme.dart';

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
    final List<Machine> machines = context.read<MachinesProvider>().machines;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar ejercicio' : 'Nuevo ejercicio'),
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            // Day indicator
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.today_rounded,
                    color: AppTheme.primaryOrange,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    kDayNames[widget.dayOfWeek],
                    style: const TextStyle(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Link to machine (optional)
            if (machines.isNotEmpty) ...<Widget>[
              const Text(
                'Vincular a máquina (opcional)',
                style: TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Machine?>(
                initialValue: _selectedMachine,
                dropdownColor: AppTheme.cardDark,
                decoration: const InputDecoration(
                  labelText: 'Seleccionar máquina',
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
                items: <DropdownMenuItem<Machine?>>[
                  const DropdownMenuItem<Machine?>(
                    child: Text(
                      'Sin máquina',
                      style: TextStyle(color: AppTheme.textSecondary),
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

            // Exercise name
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre del ejercicio *',
              ),
              style: const TextStyle(color: AppTheme.textPrimary),
              validator: (String? v) =>
                  v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 20),

            // Sets, Reps, Weight
            const Text(
              'Parámetros',
              style: TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: _NumberInput(
                    label: 'Series',
                    value: _sets,
                    min: 1,
                    max: 20,
                    onChanged: (int v) => setState(() => _sets = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NumberInput(
                    label: 'Reps',
                    value: _reps,
                    min: 1,
                    max: 100,
                    onChanged: (int v) => setState(() => _reps = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _WeightInput(
              value: _weight,
              onChanged: (double v) => setState(() => _weight = v),
            ),
            const SizedBox(height: 20),

            // Notes
            TextFormField(
              controller: _notesCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                hintText: 'Ej: Foco en contracción muscular...',
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

class _NumberInput extends StatelessWidget {
  const _NumberInput({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: value > min ? () => onChanged(value - 1) : null,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: value > min
                        ? AppTheme.primaryOrange.withValues(alpha: 0.2)
                        : AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.remove_rounded,
                    size: 16,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ),
              Text(
                '$value',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: value < max ? () => onChanged(value + 1) : null,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 16,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeightInput extends StatelessWidget {
  const _WeightInput({required this.value, required this.onChanged});
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Peso (kg)',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: value >= 2.5
                    ? () => onChanged((value - 2.5).clamp(0, 999))
                    : null,
                child: const _WeightBtn(icon: Icons.remove_rounded),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: value >= 5
                    ? () => onChanged((value - 5).clamp(0, 999))
                    : null,
                child: const _WeightBtn(
                  icon: Icons.keyboard_double_arrow_left_rounded,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      '${value.toStringAsFixed(1)} kg',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onChanged((value + 5).clamp(0, 999)),
                child: const _WeightBtn(
                  icon: Icons.keyboard_double_arrow_right_rounded,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => onChanged((value + 2.5).clamp(0, 999)),
                child: const _WeightBtn(icon: Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              '-5 · -2.5        +2.5 · +5',
              style: TextStyle(
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightBtn extends StatelessWidget {
  const _WeightBtn({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.primaryOrange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 18, color: AppTheme.primaryOrange),
    );
  }
}

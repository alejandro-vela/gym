import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/machine.dart';
import '../../providers/machines_provider.dart';
import '../../theme/app_theme.dart';
import 'widgets/difficulty_selector.dart';
import 'widgets/machine_photo_picker.dart';
import 'widgets/muscle_group_selector.dart';
import 'widgets/precautions_section.dart';

class AddEditMachineScreen extends StatefulWidget {
  const AddEditMachineScreen({super.key, this.machine});
  final Machine? machine;

  @override
  State<AddEditMachineScreen> createState() => _AddEditMachineScreenState();
}

class _AddEditMachineScreenState extends State<AddEditMachineScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _howToUseCtrl;
  late final TextEditingController _precautionCtrl;

  String? _photoPath;
  String? _precautionPhotoPath;
  List<String> _selectedMuscles = <String>[];
  List<String> _precautions = <String>[];
  int _difficulty = 1;
  String _category = kCategories.first;
  bool _isSaving = false;

  bool get _isEditing => widget.machine != null;

  @override
  void initState() {
    super.initState();
    final Machine? m = widget.machine;
    _nameCtrl = TextEditingController(text: m?.name ?? '');
    _descCtrl = TextEditingController(text: m?.description ?? '');
    _howToUseCtrl = TextEditingController(text: m?.howToUse ?? '');
    _precautionCtrl = TextEditingController();
    _photoPath = m?.photoPath;
    _precautionPhotoPath = m?.precautionPhotoPath;
    _selectedMuscles = List<String>.from(m?.muscleGroups ?? <String>[]);
    _precautions = List<String>.from(m?.precautions ?? <String>[]);
    _difficulty = m?.difficulty ?? 1;
    _category = m?.category ?? kCategories.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _howToUseCtrl.dispose();
    _precautionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage({bool isPrecaution = false}) async {
    final ImageSource? source = await _showSourceDialog();
    if (source == null) {
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? xFile =
        await picker.pickImage(source: source, imageQuality: 85);
    if (xFile == null) {
      return;
    }

    setState(() {
      if (isPrecaution) {
        _precautionPhotoPath = xFile.path;
      } else {
        _photoPath = xFile.path;
      }
    });
  }

  Future<ImageSource?> _showSourceDialog() async {
    final AppLocalizations loc = context.read<LanguageProvider>().strings;
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF444444),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              loc.addMachine.sourceDialogTitle,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: SourceButton(
                    icon: Icons.camera_alt_rounded,
                    label: loc.common.camera,
                    onTap: () =>
                        Navigator.pop(context, ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SourceButton(
                    icon: Icons.photo_library_rounded,
                    label: loc.common.gallery,
                    onTap: () =>
                        Navigator.pop(context, ImageSource.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addPrecaution() {
    final String text = _precautionCtrl.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _precautions.add(text);
      _precautionCtrl.clear();
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedMuscles.isEmpty) {
      final AddMachineStrings s =
          context.read<LanguageProvider>().strings.addMachine;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.musclesRequiredError),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final Machine machine = Machine(
      id: widget.machine?.id,
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      howToUse: _howToUseCtrl.text.trim(),
      photoPath: _photoPath,
      muscleGroups: _selectedMuscles,
      difficulty: _difficulty,
      precautions: _precautions,
      precautionPhotoPath: _precautionPhotoPath,
      category: _category,
    );

    final MachinesProvider provider = context.read<MachinesProvider>();
    if (_isEditing) {
      await provider.updateMachine(machine);
    } else {
      await provider.addMachine(machine);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = context.read<LanguageProvider>().strings;
    final AddMachineStrings s = loc.addMachine;
    final MachinesStrings ms = loc.machines;
    final CommonStrings cs = loc.common;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? s.titleEdit : s.titleNew),
        actions: <Widget>[
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
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
                      fontSize: 16,
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
            MachinePhotoPicker(
              photoPath: _photoPath,
              label: s.photoLabel,
              tapToAddLabel: cs.tapToAddPhoto,
              icon: Icons.fitness_center_rounded,
              onTap: () => _pickImage(),
            ),
            const SizedBox(height: 20),

            _SectionLabel(s.sectionBasic),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: s.fieldName),
              style: const TextStyle(color: AppTheme.textPrimary),
              validator: (String? v) =>
                  v == null || v.isEmpty ? cs.requiredField : null,
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _category,
              dropdownColor: AppTheme.cardDark,
              decoration: InputDecoration(labelText: s.fieldCategory),
              style: const TextStyle(color: AppTheme.textPrimary),
              items: kCategories
                  .map(
                    (String c) => DropdownMenuItem<String>(
                      value: c,
                      child: Text(c),
                    ),
                  )
                  .toList(),
              onChanged: (String? v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 20),

            _SectionLabel(s.sectionDifficulty),
            const SizedBox(height: 8),
            DifficultySelector(
              difficulty: _difficulty,
              labels: <String>[
                ms.difficulty1,
                ms.difficulty2,
                ms.difficulty3,
              ],
              onSelect: (int d) => setState(() => _difficulty = d),
            ),
            const SizedBox(height: 20),

            _SectionLabel(s.sectionMuscles),
            const SizedBox(height: 8),
            MuscleGroupSelector(
              selectedMuscles: _selectedMuscles,
              onToggle: (String muscle) => setState(() {
                if (_selectedMuscles.contains(muscle)) {
                  _selectedMuscles.remove(muscle);
                } else {
                  _selectedMuscles.add(muscle);
                }
              }),
            ),
            const SizedBox(height: 20),

            _SectionLabel(s.sectionDescription),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: InputDecoration(labelText: s.fieldDescription),
              style: const TextStyle(color: AppTheme.textPrimary),
              validator: (String? v) =>
                  v == null || v.isEmpty ? cs.requiredField : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _howToUseCtrl,
              maxLines: 4,
              decoration: InputDecoration(labelText: s.fieldHowToUse),
              style: const TextStyle(color: AppTheme.textPrimary),
              validator: (String? v) =>
                  v == null || v.isEmpty ? cs.requiredField : null,
            ),
            const SizedBox(height: 24),

            _SectionLabel(s.sectionPrecautions),
            const SizedBox(height: 8),
            MachinePhotoPicker(
              photoPath: _precautionPhotoPath,
              label: s.precautionPhotoLabel,
              tapToAddLabel: cs.tapToAddPhoto,
              icon: Icons.warning_amber_rounded,
              color: AppTheme.warning,
              onTap: () => _pickImage(isPrecaution: true),
              height: 120,
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _precautionCtrl,
                    decoration: InputDecoration(
                      hintText: s.precautionPlaceholder,
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary),
                    onSubmitted: (_) => _addPrecaution(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addPrecaution,
                  icon: const Icon(
                    Icons.add_circle_rounded,
                    color: AppTheme.warning,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            PrecautionsList(
              precautions: _precautions,
              onDismiss: (int index) =>
                  setState(() => _precautions.removeAt(index)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppTheme.primaryOrange,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/machine.dart';
import '../../providers/machines_provider.dart';
import '../../theme/app_theme.dart';

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
            const Text(
              'Seleccionar foto',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: _SourceButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Cámara',
                    onTap: () =>
                        Navigator.pop(context, ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SourceButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Galería',
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos un grupo muscular'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar máquina' : 'Nueva máquina'),
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
                : const Text(
                    'Guardar',
                    style: TextStyle(
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
            // Main photo
            _PhotoPicker(
              photoPath: _photoPath,
              label: 'Foto de la máquina',
              icon: Icons.fitness_center_rounded,
              onTap: () => _pickImage(),
            ),
            const SizedBox(height: 20),

            // Name
            const _SectionLabel('Información básica'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre de la máquina *',
              ),
              style: const TextStyle(color: AppTheme.textPrimary),
              validator: (String? v) =>
                  v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),

            // Category
            DropdownButtonFormField<String>(
              initialValue: _category,
              dropdownColor: AppTheme.cardDark,
              decoration: const InputDecoration(labelText: 'Categoría'),
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

            // Difficulty
            const _SectionLabel('Dificultad'),
            const SizedBox(height: 8),
            Row(
              children: <int>[1, 2, 3].map((int d) {
                final List<String> labels = <String>[
                  'Principiante',
                  'Intermedio',
                  'Avanzado',
                ];
                final List<Color> colors = <Color>[
                  AppTheme.success,
                  AppTheme.warning,
                  AppTheme.danger,
                ];
                final bool isSelected = _difficulty == d;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: d < 3 ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _difficulty = d),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors[d - 1].withValues(alpha: 0.2)
                              : AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? colors[d - 1]
                                : const Color(0xFF333333),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          labels[d - 1],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? colors[d - 1]
                                : AppTheme.textSecondary,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Muscle groups
            const _SectionLabel('Músculos trabajados *'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: kMuscleGroups.map((String muscle) {
                final bool isSelected = _selectedMuscles.contains(muscle);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      _selectedMuscles.remove(muscle);
                    } else {
                      _selectedMuscles.add(muscle);
                    }
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryOrange.withValues(alpha: 0.2)
                          : AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryOrange
                            : const Color(0xFF333333),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      muscle,
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.primaryOrange
                            : AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Description
            const _SectionLabel('Descripción'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción del ejercicio *',
              ),
              style: const TextStyle(color: AppTheme.textPrimary),
              validator: (String? v) =>
                  v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _howToUseCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Cómo usar la máquina *',
              ),
              style: const TextStyle(color: AppTheme.textPrimary),
              validator: (String? v) =>
                  v == null || v.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 24),

            // Precautions
            const _SectionLabel('Precauciones'),
            const SizedBox(height: 8),
            _PhotoPicker(
              photoPath: _precautionPhotoPath,
              label: 'Foto de precaución (opcional)',
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
                    decoration: const InputDecoration(
                      hintText: 'Agregar precaución...',
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
            ..._precautions.asMap().entries.map(
                  (MapEntry<int, String> e) => Dismissible(
                    key: Key('prec_${e.key}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) =>
                        setState(() => _precautions.removeAt(e.key)),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      color: AppTheme.danger.withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.delete_rounded,
                        color: AppTheme.danger,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.warning.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.warning_rounded,
                            color: AppTheme.warning,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              e.value,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.photoPath,
    required this.label,
    required this.icon,
    this.color = AppTheme.primaryOrange,
    required this.onTap,
    this.height = 200,
  });
  final String? photoPath;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: photoPath != null && File(photoPath!).existsSync()
            ? Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(File(photoPath!), fit: BoxFit.cover),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, color: color.withValues(alpha: 0.5), size: 40),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Toca para agregar foto',
                    style: TextStyle(
                      color: color.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.primaryOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppTheme.primaryOrange.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, color: AppTheme.primaryOrange, size: 32),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

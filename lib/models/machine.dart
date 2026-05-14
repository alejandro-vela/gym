class Machine {

  Machine({
    this.id,
    required this.name,
    required this.description,
    required this.howToUse,
    this.photoPath,
    required this.muscleGroups,
    required this.difficulty,
    required this.precautions,
    this.precautionPhotoPath,
    required this.category,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Machine.fromMap(Map<String, dynamic> map) {
    return Machine(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      howToUse: map['how_to_use'] as String,
      photoPath: map['photo_path'] as String?,
      muscleGroups: (map['muscle_groups'] as String).isNotEmpty
          ? (map['muscle_groups'] as String).split('|')
          : <String>[],
      difficulty: map['difficulty'] as int,
      precautions: (map['precautions'] as String).isNotEmpty
          ? (map['precautions'] as String).split('|||')
          : <String>[],
      precautionPhotoPath: map['precaution_photo_path'] as String?,
      category: map['category'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }
  final int? id;
  final String name;
  final String description;
  final String howToUse;
  final String? photoPath;
  final List<String> muscleGroups;
  final int difficulty; // 1=Fácil, 2=Intermedio, 3=Avanzado
  final List<String> precautions;
  final String? precautionPhotoPath;
  final String category; // Cardio, Fuerza, Funcional, etc.
  final DateTime createdAt;

  String get difficultyLabel {
    switch (difficulty) {
      case 1:
        return 'Principiante';
      case 2:
        return 'Intermedio';
      case 3:
        return 'Avanzado';
      default:
        return 'Principiante';
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'how_to_use': howToUse,
      'photo_path': photoPath,
      'muscle_groups': muscleGroups.join('|'),
      'difficulty': difficulty,
      'precautions': precautions.join('|||'),
      'precaution_photo_path': precautionPhotoPath,
      'category': category,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  Machine copyWith({
    int? id,
    String? name,
    String? description,
    String? howToUse,
    String? photoPath,
    List<String>? muscleGroups,
    int? difficulty,
    List<String>? precautions,
    String? precautionPhotoPath,
    String? category,
    DateTime? createdAt,
  }) {
    return Machine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      howToUse: howToUse ?? this.howToUse,
      photoPath: photoPath ?? this.photoPath,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      difficulty: difficulty ?? this.difficulty,
      precautions: precautions ?? this.precautions,
      precautionPhotoPath: precautionPhotoPath ?? this.precautionPhotoPath,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

const List<String> kMuscleGroups = <String>[
  'Pecho',
  'Espalda',
  'Hombros',
  'Bíceps',
  'Tríceps',
  'Abdomen',
  'Cuádriceps',
  'Isquiotibiales',
  'Glúteos',
  'Pantorrillas',
  'Antebrazos',
  'Trapecio',
];

const List<String> kCategories = <String>[
  'Fuerza',
  'Cardio',
  'Funcional',
  'Máquina Guiada',
  'Peso Libre',
  'Cables',
  'Cuerpo Libre',
];

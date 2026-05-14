class BodyMeasurement {

  BodyMeasurement({
    this.id,
    required this.date,
    this.weight,
    this.bodyFatPercent,
    this.chest,
    this.waist,
    this.hips,
    this.leftArm,
    this.rightArm,
    this.leftThigh,
    this.rightThigh,
    this.notes = '',
  });

  factory BodyMeasurement.fromMap(Map<String, dynamic> map) {
    return BodyMeasurement(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      weight: map['weight'] != null ? (map['weight'] as num).toDouble() : null,
      bodyFatPercent: map['body_fat_percent'] != null
          ? (map['body_fat_percent'] as num).toDouble()
          : null,
      chest: map['chest'] != null ? (map['chest'] as num).toDouble() : null,
      waist: map['waist'] != null ? (map['waist'] as num).toDouble() : null,
      hips: map['hips'] != null ? (map['hips'] as num).toDouble() : null,
      leftArm:
          map['left_arm'] != null ? (map['left_arm'] as num).toDouble() : null,
      rightArm: map['right_arm'] != null
          ? (map['right_arm'] as num).toDouble()
          : null,
      leftThigh: map['left_thigh'] != null
          ? (map['left_thigh'] as num).toDouble()
          : null,
      rightThigh: map['right_thigh'] != null
          ? (map['right_thigh'] as num).toDouble()
          : null,
      notes: map['notes'] as String? ?? '',
    );
  }
  final int? id;
  final DateTime date;
  final double? weight;
  final double? bodyFatPercent;
  final double? chest;
  final double? waist;
  final double? hips;
  final double? leftArm;
  final double? rightArm;
  final double? leftThigh;
  final double? rightThigh;
  final String notes;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.toIso8601String().split('T')[0],
      'weight': weight,
      'body_fat_percent': bodyFatPercent,
      'chest': chest,
      'waist': waist,
      'hips': hips,
      'left_arm': leftArm,
      'right_arm': rightArm,
      'left_thigh': leftThigh,
      'right_thigh': rightThigh,
      'notes': notes,
    };
  }
}

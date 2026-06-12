/// Subject profile used as analysis input. No account/login is required —
/// these values are entered by the user and persisted locally.
class UserProfile {
  final String name;
  final String gender; // 'M' or 'F'
  final int age; // years
  final double heightM; // meters
  final double weightKg; // kilograms

  const UserProfile({
    this.name = '',
    this.gender = 'M',
    this.age = 0,
    this.heightM = 0.0,
    this.weightKg = 0.0,
  });

  /// Body mass index (kg/m²). Returns 0 when height is not set.
  double get bmi {
    if (heightM <= 0) return 0;
    return weightKg / (heightM * heightM);
  }

  /// Whether the minimum required fields have been filled in.
  bool get isComplete =>
      age > 0 && heightM > 0 && weightKg > 0 && gender.isNotEmpty;

  UserProfile copyWith({
    String? name,
    String? gender,
    int? age,
    double? heightM,
    double? weightKg,
  }) {
    return UserProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightM: heightM ?? this.heightM,
      weightKg: weightKg ?? this.weightKg,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'gender': gender,
        'age': age,
        'heightM': heightM,
        'weightKg': weightKg,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: (json['name'] as String?) ?? '',
        gender: (json['gender'] as String?) ?? 'M',
        age: (json['age'] as num?)?.toInt() ?? 0,
        heightM: (json['heightM'] as num?)?.toDouble() ?? 0.0,
        weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0.0,
      );
}

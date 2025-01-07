class EducationLevel {
  final String id;
  final String name;

  static var values;

  EducationLevel({required this.id, required this.name});

  static List<EducationLevel> get levels => [
        EducationLevel(id: 'high_school', name: 'High School'),
        EducationLevel(id: 'diploma', name: 'Diploma'),
        EducationLevel(id: 'associate', name: 'Associate Degree'),
        EducationLevel(id: 'bachelors', name: 'Bachelor\'s Degree'),
        EducationLevel(id: 'masters', name: 'Master\'s Degree'),
        EducationLevel(id: 'doctorate', name: 'Doctorate'),
        
      ];
       @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationLevel && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
  
}



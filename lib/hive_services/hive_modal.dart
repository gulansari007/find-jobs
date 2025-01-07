import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class BasicDetailsModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final DateTime? dateOfBirth;

  @HiveField(4)
  final String? gender;

  BasicDetailsModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
  });
}

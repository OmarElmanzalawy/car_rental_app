import 'package:car_rental_app/core/constants/enums.dart';

class UserModel {
  final String id;
  final String name;
  final String? email;
  final String password;
  final String? phoneNumber;
  final String? profileImagePath;
  final UserType role;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.password,
    required this.role,
    required this.createdAt,
    this.email,
    this.phoneNumber,
    this.profileImagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': name,
      'email': email,
      'role': role.name,
      'created_at': createdAt.toUtc().toIso8601String(),
      'phone': phoneNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['full_name'],
      email: map['email'],
      password: map['password'],
      role: UserType.values[map['role']],
      createdAt: DateTime.parse(map['created_at']),
      phoneNumber: map['phone'],
    );
  }
}

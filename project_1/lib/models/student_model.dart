import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String website;

  const Student({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'website': website,
    };
  }

  Student copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? website,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, website];
}
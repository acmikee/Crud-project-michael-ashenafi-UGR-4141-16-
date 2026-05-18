import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  final List<String> _ethiopianNames = [
    'Abebe Girma', 'Tigist Haile', 'Yonas Bekele', 'Selam Tesfaye',
    'Dawit Alemu', 'Hana Tadesse', 'Bereket Mekonnen', 'Meron Worku',
    'Kaleb Desta', 'Lidiya Assefa',
  ];

  final List<String> _ethiopianPhones = [
    '+251911234567', '+251922345678', '+251933456789', '+251944567890',
    '+251955678901', '+251966789012', '+251977890123', '+251988901234',
    '+251999012345', '+251900123456',
  ];

  final List<String> _ethiopianEmails = [
    'abebe.girma@gmail.com', 'tigist.haile@gmail.com',
    'yonas.bekele@gmail.com', 'selam.tesfaye@gmail.com',
    'dawit.alemu@gmail.com', 'hana.tadesse@gmail.com',
    'bereket.mekonnen@gmail.com', 'meron.worku@gmail.com',
    'kaleb.desta@gmail.com', 'lidiya.assefa@gmail.com',
  ];

  // READ - Get all students
  Future<List<Student>> getStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      final students = data.map((json) => Student.fromJson(json)).toList();
      return students.asMap().entries.map((entry) {
        final i = entry.key;
        final student = entry.value;
        return student.copyWith(
          name: i < _ethiopianNames.length ? _ethiopianNames[i] : student.name,
          phone: i < _ethiopianPhones.length ? _ethiopianPhones[i] : student.phone,
          email: i < _ethiopianEmails.length ? _ethiopianEmails[i] : student.email,
        );
      }).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  // CREATE - Add new student
  Future<Student> createStudent(Student student) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
    if (response.statusCode == 201) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create student');
    }
  }

  // UPDATE - Update student
  Future<Student> updateStudent(Student student) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/${student.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
    if (response.statusCode == 200) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update student');
    }
  }

  // DELETE - Delete student
  Future<void> deleteStudent(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete student');
    }
  }
}
import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../repository/student_repository.dart';

enum StudentStatus { initial, loading, loaded, error }

class StudentProvider extends ChangeNotifier {
  final StudentRepository _repository;

  StudentProvider({StudentRepository? repository})
      : _repository = repository ?? StudentRepository();

  List<Student> _students = [];
  StudentStatus _status = StudentStatus.initial;
  String _errorMessage = '';
  String _successMessage = '';

  List<Student> get students => _students;
  StudentStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;

  // Clear messages
  void clearSuccessMessage() {
    _successMessage = '';
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = '';
    notifyListeners();
  }

  // READ
  Future<void> loadStudents() async {
    _status = StudentStatus.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      _students = await _repository.fetchStudents();
      _status = StudentStatus.loaded;
    } catch (e) {
      _status = StudentStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // CREATE
  Future<void> addStudent(Student student) async {
    _status = StudentStatus.loading;
    notifyListeners();
    try {
      final newStudent = await _repository.addStudent(student);
      _students = [newStudent, ..._students];
      _status = StudentStatus.loaded;
      _successMessage = 'Student added successfully!';
    } catch (e) {
      _status = StudentStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // UPDATE
  Future<void> updateStudent(Student student) async {
    _status = StudentStatus.loading;
    notifyListeners();
    try {
      final updated = await _repository.editStudent(student);
      _students = _students.map((s) => s.id == updated.id ? updated : s).toList();
      _status = StudentStatus.loaded;
      _successMessage = 'Student updated successfully!';
    } catch (e) {
      _status = StudentStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // DELETE
  Future<void> deleteStudent(int id) async {
    _status = StudentStatus.loading;
    notifyListeners();
    try {
      await _repository.removeStudent(id);
      _students = _students.where((s) => s.id != id).toList();
      _status = StudentStatus.loaded;
      _successMessage = 'Student deleted successfully!';
    } catch (e) {
      _status = StudentStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
import '../models/student_model.dart';
import '../services/api_service.dart';

class StudentRepository {
  final ApiService _apiService;

  StudentRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<Student>> fetchStudents() => _apiService.getStudents();

  Future<Student> fetchStudent(int id) => _apiService.getStudent(id);

  Future<Student> addStudent(Student student) =>
      _apiService.createStudent(student);

  Future<Student> editStudent(Student student) =>
      _apiService.updateStudent(student);

  Future<void> removeStudent(int id) => _apiService.deleteStudent(id);
}
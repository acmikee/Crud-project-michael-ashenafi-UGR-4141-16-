import 'package:dio/dio.dart';
import '../models/student_model.dart';

class ApiService {
  final Dio _dio;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  final List<String> _ethiopianNames = [
    'Abebe Girma',
    'Tigist Haile',
    'Yonas Bekele',
    'Selam Tesfaye',
    'Dawit Alemu',
    'Hana Tadesse',
    'Bereket Mekonnen',
    'Meron Worku',
    'Kaleb Desta',
    'Lidiya Assefa',
  ];

  final List<String> _ethiopianPhones = [
    '+251911234567',
    '+251922345678',
    '+251933456789',
    '+251944567890',
    '+251955678901',
    '+251966789012',
    '+251977890123',
    '+251988901234',
    '+251999012345',
    '+251900123456',
  ];

  final List<String> _ethiopianEmails = [
    'abebe.girma@gmail.com',
    'tigist.haile@gmail.com',
    'yonas.bekele@gmail.com',
    'selam.tesfaye@gmail.com',
    'dawit.alemu@gmail.com',
    'hana.tadesse@gmail.com',
    'bereket.mekonnen@gmail.com',
    'meron.worku@gmail.com',
    'kaleb.desta@gmail.com',
    'lidiya.assefa@gmail.com',
  ];

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  )) {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // READ - Get all students (users)
  Future<List<Student>> getStudents() async {
    try {
      final response = await _dio.get('/users');
      final students = (response.data as List)
          .map((json) => Student.fromJson(json))
          .toList();
      return students.asMap().entries.map((entry) {
        final i = entry.key;
        final student = entry.value;
        return student.copyWith(
          name: i < _ethiopianNames.length ? _ethiopianNames[i] : student.name,
          phone: i < _ethiopianPhones.length ? _ethiopianPhones[i] : student.phone,
          email: i < _ethiopianEmails.length ? _ethiopianEmails[i] : student.email,
        );
      }).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // READ - Get single student
  Future<Student> getStudent(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      return Student.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // CREATE - Add new student
  Future<Student> createStudent(Student student) async {
    try {
      final response = await _dio.post('/users', data: student.toJson());
      return Student.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // UPDATE - Update student
  Future<Student> updateStudent(Student student) async {
    try {
      final response = await _dio.put(
        '/users/${student.id}',
        data: student.toJson(),
      );
      return Student.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE - Delete student
  Future<void> deleteStudent(int id) async {
    try {
      await _dio.delete('/users/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet.';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
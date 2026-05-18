import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/student_repository.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository _repository;

  StudentBloc({required StudentRepository repository})
      : _repository = repository,
        super(StudentInitial()) {
    on<LoadStudents>(_onLoadStudents);
    on<AddStudent>(_onAddStudent);
    on<UpdateStudent>(_onUpdateStudent);
    on<DeleteStudent>(_onDeleteStudent);
  }

  Future<void> _onLoadStudents(
    LoadStudents event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      final students = await _repository.fetchStudents();
      emit(StudentLoaded(students));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onAddStudent(
    AddStudent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      final newStudent = await _repository.addStudent(event.student);
      // JSONPlaceholder returns id=11 for all POSTs, so we simulate local add
      final currentStudents = await _repository.fetchStudents();
      final updatedList = [newStudent, ...currentStudents];
      emit(StudentOperationSuccess('Student added successfully!', updatedList));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onUpdateStudent(
    UpdateStudent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      final updated = await _repository.editStudent(event.student);
      final currentStudents = await _repository.fetchStudents();
      final updatedList = currentStudents.map((s) {
        return s.id == updated.id ? updated : s;
      }).toList();
      emit(StudentOperationSuccess('Student updated successfully!', updatedList));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onDeleteStudent(
    DeleteStudent event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      await _repository.removeStudent(event.id);
      final currentStudents = await _repository.fetchStudents();
      final updatedList =
          currentStudents.where((s) => s.id != event.id).toList();
      emit(StudentOperationSuccess('Student deleted successfully!', updatedList));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }
}
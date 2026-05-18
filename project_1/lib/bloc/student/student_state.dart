import 'package:equatable/equatable.dart';
import '../../models/student_model.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> students;
  const StudentLoaded(this.students);

  @override
  List<Object?> get props => [students];
}

class StudentOperationSuccess extends StudentState {
  final String message;
  final List<Student> students;
  const StudentOperationSuccess(this.message, this.students);

  @override
  List<Object?> get props => [message, students];
}

class StudentError extends StudentState {
  final String message;
  const StudentError(this.message);

  @override
  List<Object?> get props => [message];
}

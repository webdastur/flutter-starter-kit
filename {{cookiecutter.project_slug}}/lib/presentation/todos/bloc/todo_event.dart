import 'package:equatable/equatable.dart';

import '../../../domain/entities/todo_entity.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodoEvent {
  final int? limit;
  final int? skip;

  const LoadTodosEvent({this.limit, this.skip});

  @override
  List<Object?> get props => [limit, skip];
}

class LoadTodoEvent extends TodoEvent {
  final int id;

  const LoadTodoEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddTodoEvent extends TodoEvent {
  final TodoEntity todo;

  const AddTodoEvent(this.todo);

  @override
  List<Object> get props => [todo];
}

class UpdateTodoEvent extends TodoEvent {
  final TodoEntity todo;

  const UpdateTodoEvent(this.todo);

  @override
  List<Object> get props => [todo];
}

class DeleteTodoEvent extends TodoEvent {
  final int id;

  const DeleteTodoEvent(this.id);

  @override
  List<Object> get props => [id];
}

class LoadTodosByUserEvent extends TodoEvent {
  final int userId;

  const LoadTodosByUserEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class ToggleTodoEvent extends TodoEvent {
  final TodoEntity todo;

  const ToggleTodoEvent(this.todo);

  @override
  List<Object> get props => [todo];
}

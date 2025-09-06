import 'package:equatable/equatable.dart';

import '../../../domain/entities/todo_entity.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<TodoEntity> todos;
  final bool hasReachedMax;

  const TodosLoaded({required this.todos, this.hasReachedMax = false});

  TodosLoaded copyWith({List<TodoEntity>? todos, bool? hasReachedMax}) {
    return TodosLoaded(
      todos: todos ?? this.todos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [todos, hasReachedMax];
}

class TodoLoaded extends TodoState {
  final TodoEntity todo;

  const TodoLoaded(this.todo);

  @override
  List<Object> get props => [todo];
}

class TodoOperationSuccess extends TodoState {
  final String message;
  final TodoEntity? todo;

  const TodoOperationSuccess({required this.message, this.todo});

  @override
  List<Object?> get props => [message, todo];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object> get props => [message];
}

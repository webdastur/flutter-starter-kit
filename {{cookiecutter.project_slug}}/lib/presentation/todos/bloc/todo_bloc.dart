import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;

  TodoBloc(this._todoRepository) : super(TodoInitial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<LoadTodoEvent>(_onLoadTodo);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<LoadTodosByUserEvent>(_onLoadTodosByUser);
    on<ToggleTodoEvent>(_onToggleTodo);
  }

  Future<void> _onLoadTodos(
    LoadTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());

    final result = await _todoRepository.getTodos(
      limit: event.limit,
      skip: event.skip,
    );

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (todos) => emit(TodosLoaded(todos: todos)),
    );
  }

  Future<void> _onLoadTodo(LoadTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final result = await _todoRepository.getTodo(event.id);

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (todo) => emit(TodoLoaded(todo)),
    );
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final result = await _todoRepository.addTodo(event.todo);

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (todo) => emit(
        TodoOperationSuccess(message: 'Todo added successfully', todo: todo),
      ),
    );
  }

  Future<void> _onUpdateTodo(
    UpdateTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());

    final result = await _todoRepository.updateTodo(event.todo);

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (todo) => emit(
        TodoOperationSuccess(message: 'Todo updated successfully', todo: todo),
      ),
    );
  }

  Future<void> _onDeleteTodo(
    DeleteTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());

    final result = await _todoRepository.deleteTodo(event.id);

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) => emit(
        const TodoOperationSuccess(message: 'Todo deleted successfully'),
      ),
    );
  }

  Future<void> _onLoadTodosByUser(
    LoadTodosByUserEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());

    final result = await _todoRepository.getTodosByUser(event.userId);

    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (todos) => emit(TodosLoaded(todos: todos)),
    );
  }

  Future<void> _onToggleTodo(
    ToggleTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final updatedTodo = event.todo.copyWith(completed: !event.todo.completed);
    add(UpdateTodoEvent(updatedTodo));
  }
}

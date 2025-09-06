import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/todo_entity.dart';
import \'../../presentation/todos/bloc/todo_bloc.dart';
import \'../../presentation/todos/bloc/todo_event.dart';
import \'../../presentation/todos/bloc/todo_state.dart';
import '../validation/todo_validation.dart';

/// Custom hook for todo form management
class TodoFormController {
  final TextEditingController todoController;
  final bool isCompleted;
  final void Function(bool) setCompleted;
  final bool isValid;
  final void Function() dispose;

  TodoFormController({
    required this.todoController,
    required this.isCompleted,
    required this.setCompleted,
    required this.isValid,
    required this.dispose,
  });
}

/// Hook for managing todo form state
TodoFormController useTodoForm({TodoEntity? initialTodo}) {
  final todoController = useTextEditingController(
    text: initialTodo?.todo ?? '',
  );
  final isCompleted = useState(initialTodo?.completed ?? false);
  final isValid = useState(false);

  // Validate form whenever text changes
  useEffect(() {
    void validateForm() {
      isValid.value = todoController.text.trim().isNotEmpty;
    }

    todoController.addListener(validateForm);
    validateForm(); // Initial validation

    return () => todoController.removeListener(validateForm);
  }, [todoController]);

  // Cleanup function
  void dispose() {
    todoController.dispose();
  }

  return TodoFormController(
    todoController: todoController,
    isCompleted: isCompleted.value,
    setCompleted: (value) => isCompleted.value = value,
    isValid: isValid.value,
    dispose: dispose,
  );
}

/// Hook for todo operations with BLoC
class TodoOperations {
  final void Function(TodoEntity) addTodo;
  final void Function(TodoEntity) updateTodo;
  final void Function(int) deleteTodo;
  final void Function(TodoEntity) toggleTodo;
  final void Function() loadTodos;
  final bool isLoading;

  TodoOperations({
    required this.addTodo,
    required this.updateTodo,
    required this.deleteTodo,
    required this.toggleTodo,
    required this.loadTodos,
    required this.isLoading,
  });
}

/// Hook for todo BLoC operations
TodoOperations useTodoOperations() {
  final context = useContext();
  final todoBloc = context.read<TodoBloc>();
  final isLoading = useState(false);

  // Listen to BLoC state changes to update loading state
  useEffect(() {
    void listener(TodoState state) {
      isLoading.value = state is TodoLoading;
    }

    final subscription = todoBloc.stream.listen(listener);
    return subscription.cancel;
  }, [todoBloc]);

  return TodoOperations(
    addTodo: (todo) => todoBloc.add(AddTodoEvent(todo)),
    updateTodo: (todo) => todoBloc.add(UpdateTodoEvent(todo)),
    deleteTodo: (id) => todoBloc.add(DeleteTodoEvent(id)),
    toggleTodo: (todo) => todoBloc.add(ToggleTodoEvent(todo)),
    loadTodos: () => todoBloc.add(const LoadTodosEvent()),
    isLoading: isLoading.value,
  );
}

/// Hook for navigation operations
class AppNavigation {
  final void Function() goToAddTodo;
  final void Function(TodoEntity) goToEditTodo;
  final void Function() goBack;
  final void Function() goHome;

  AppNavigation({
    required this.goToAddTodo,
    required this.goToEditTodo,
    required this.goBack,
    required this.goHome,
  });
}

/// Hook for app navigation
AppNavigation useAppNavigation() {
  final context = useContext();

  return AppNavigation(
    goToAddTodo: () => context.pushNamed('add-todo'),
    goToEditTodo: (todo) => context.pushNamed('edit-todo', extra: todo),
    goBack: () => context.pop(),
    goHome: () => context.go('/'),
  );
}

/// Hook for managing async operations with loading states
class AsyncOperation<T> {
  final bool isLoading;
  final T? data;
  final String? error;
  final Future<void> Function() execute;
  final void Function() reset;

  AsyncOperation({
    required this.isLoading,
    this.data,
    this.error,
    required this.execute,
    required this.reset,
  });
}

/// Hook for async operations
AsyncOperation<T> useAsyncOperation<T>(
  Future<T> Function() operation, {
  List<Object?> keys = const [],
}) {
  final isLoading = useState(false);
  final data = useState<T?>(null);
  final error = useState<String?>(null);

  Future<void> execute() async {
    isLoading.value = true;
    error.value = null;

    try {
      final result = await operation();
      data.value = result;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    isLoading.value = false;
    data.value = null;
    error.value = null;
  }

  return AsyncOperation<T>(
    isLoading: isLoading.value,
    data: data.value,
    error: error.value,
    execute: execute,
    reset: reset,
  );
}

/// Hook for debounced values (useful for search)
T useDebounced<T>(T value, Duration delay) {
  final debouncedValue = useState(value);

  useEffect(() {
    final timer = Timer(delay, () {
      debouncedValue.value = value;
    });

    return timer.cancel;
  }, [value]);

  return debouncedValue.value;
}

/// Hook for managing search functionality
class SearchController {
  final TextEditingController controller;
  final String query;
  final String debouncedQuery;
  final void Function() clear;

  SearchController({
    required this.controller,
    required this.query,
    required this.debouncedQuery,
    required this.clear,
  });
}

/// Hook for search functionality with debouncing
SearchController useSearch({
  Duration debounceDelay = const Duration(milliseconds: 500),
}) {
  final controller = useTextEditingController();
  final query = useState('');
  final debouncedQuery = useDebounced(query.value, debounceDelay);

  useEffect(() {
    void listener() {
      query.value = controller.text;
    }

    controller.addListener(listener);
    return () => controller.removeListener(listener);
  }, [controller]);

  void clear() {
    controller.clear();
    query.value = '';
  }

  return SearchController(
    controller: controller,
    query: query.value,
    debouncedQuery: debouncedQuery,
    clear: clear,
  );
}

/// Formz-powered todo form controller
class TodoFormzController {
  final TextEditingController todoController;
  final TextEditingController userIdController;
  final TodoFormState formState;
  final void Function(String) onTodoChanged;
  final void Function(String) onUserIdChanged;
  final void Function(bool) onCompletedChanged;
  final void Function() onSubmit;
  final void Function() reset;
  final void Function() dispose;

  TodoFormzController({
    required this.todoController,
    required this.userIdController,
    required this.formState,
    required this.onTodoChanged,
    required this.onUserIdChanged,
    required this.onCompletedChanged,
    required this.onSubmit,
    required this.reset,
    required this.dispose,
  });
}

/// Hook for formz-powered todo form management
TodoFormzController useTodoFormz({TodoEntity? initialTodo}) {
  final todoController = useTextEditingController(
    text: initialTodo?.todo ?? '',
  );
  final userIdController = useTextEditingController(
    text: initialTodo?.userId.toString() ?? '1',
  );

  final formState = useState(
    TodoFormState(
      todoText: initialTodo != null
          ? TodoTextInput.dirty(initialTodo.todo)
          : const TodoTextInput.pure(),
      userId: initialTodo != null
          ? UserIdInput.dirty(initialTodo.userId)
          : const UserIdInput.pure(),
      isCompleted: initialTodo?.completed ?? false,
    ),
  );

  // Handle todo text changes
  void onTodoChanged(String value) {
    final todoInput = TodoTextInput.dirty(value);
    formState.value = formState.value.copyWith(todoText: todoInput);
  }

  // Handle user ID changes
  void onUserIdChanged(String value) {
    final userId = int.tryParse(value) ?? 1;
    final userIdInput = UserIdInput.dirty(userId);
    formState.value = formState.value.copyWith(userId: userIdInput);
  }

  // Handle completion status changes
  void onCompletedChanged(bool value) {
    formState.value = formState.value.copyWith(isCompleted: value);
  }

  // Handle form submission
  void onSubmit() {
    if (!formState.value.isValid) return;

    formState.value = formState.value.copyWith(
      status: TodoFormStatus.submissionInProgress,
    );
  }

  // Reset form
  void reset() {
    todoController.clear();
    userIdController.text = '1';
    formState.value = const TodoFormState();
  }

  // Dispose controllers
  void dispose() {
    todoController.dispose();
    userIdController.dispose();
  }

  // Sync controllers with form state changes
  useEffect(() {
    void todoListener() {
      if (todoController.text != formState.value.todoText.value) {
        onTodoChanged(todoController.text);
      }
    }

    void userIdListener() {
      final userId = int.tryParse(userIdController.text) ?? 1;
      if (userId != formState.value.userId.value) {
        onUserIdChanged(userIdController.text);
      }
    }

    todoController.addListener(todoListener);
    userIdController.addListener(userIdListener);

    return () {
      todoController.removeListener(todoListener);
      userIdController.removeListener(userIdListener);
    };
  }, [todoController, userIdController]);

  return TodoFormzController(
    todoController: todoController,
    userIdController: userIdController,
    formState: formState.value,
    onTodoChanged: onTodoChanged,
    onUserIdChanged: onUserIdChanged,
    onCompletedChanged: onCompletedChanged,
    onSubmit: onSubmit,
    reset: reset,
    dispose: dispose,
  );
}

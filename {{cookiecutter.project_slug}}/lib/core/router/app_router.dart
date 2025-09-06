import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../di/injection.dart';
import '../../domain/entities/todo_entity.dart';
import '../../presentation/todos/todos.dart';

class AppRouter {
  static const String todos = '/';
  static const String addTodo = '/add-todo';
  static const String editTodo = '/edit-todo';

  static final GoRouter router = GoRouter(
    initialLocation: todos,
    routes: [
      GoRoute(
        path: todos,
        name: 'todos',
        builder: (context, state) => const TodosPage(),
      ),
      GoRoute(
        path: addTodo,
        name: 'add-todo',
        builder: (context, state) => const AddTodoPage(),
      ),
      GoRoute(
        path: editTodo,
        name: 'edit-todo',
        builder: (context, state) {
          final todo = state.extra as TodoEntity?;
          return AddTodoPage(todo: todo);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(todos),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

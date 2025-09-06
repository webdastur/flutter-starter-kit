import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/todo_entity.dart';
import '../../presentation/todos/pages/add_todo_page_hooks.dart';
import '../../presentation/todos/pages/todos_page_hooks.dart';

class AppRouterHooks {
  static const String todos = '/';
  static const String addTodo = '/add-todo';
  static const String editTodo = '/edit-todo';

  static final GoRouter router = GoRouter(
    initialLocation: todos,
    routes: [
      GoRoute(
        path: todos,
        name: 'todos',
        builder: (context, state) => const TodosPageHooks(),
      ),
      GoRoute(
        path: addTodo,
        name: 'add-todo',
        builder: (context, state) => const AddTodoPageHooks(),
      ),
      GoRoute(
        path: editTodo,
        name: 'edit-todo',
        builder: (context, state) {
          final todo = state.extra as TodoEntity?;
          return AddTodoPageHooks(todo: todo);
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../core/hooks/app_hooks.dart';
import '../../../domain/entities/todo_entity.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_state.dart';
import '../widgets/todo_item_widget.dart';

class TodosPageHooks extends HookWidget {
  const TodosPageHooks({super.key});

  @override
  Widget build(BuildContext context) {
    // Use custom hooks
    final todoOperations = useTodoOperations();
    final navigation = useAppNavigation();
    final searchController = useSearch();

    // Load todos on mount
    useEffect(() {
      todoOperations.loadTodos();
      return null;
    }, []);

    // Handle refresh
    Future<void> onRefresh() async {
      todoOperations.loadTodos();
      // Wait a bit to show the refresh indicator
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Show delete confirmation dialog
    void showDeleteDialog(TodoEntity todo) {
      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('todos.delete'.tr()),
            content: Text('Are you sure you want to delete "${todo.todo}"?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('todos.cancel'.tr()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  todoOperations.deleteTodo(todo.id);
                },
                child: Text(
                  'todos.delete'.tr(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('todos.title'.tr()),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController.controller,
              decoration: InputDecoration(
                hintText: 'Search todos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: searchController.clear,
                      )
                    : null,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading && searchController.query.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodosLoaded) {
            // Filter todos based on search query
            final filteredTodos = searchController.debouncedQuery.isEmpty
                ? state.todos
                : state.todos
                      .where(
                        (todo) => todo.todo.toLowerCase().contains(
                          searchController.debouncedQuery.toLowerCase(),
                        ),
                      )
                      .toList();

            if (filteredTodos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      searchController.query.isNotEmpty
                          ? Icons.search_off
                          : Icons.task_alt,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      searchController.query.isNotEmpty
                          ? 'No todos found for "${searchController.query}"'
                          : 'todos.empty'.tr(),
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    if (searchController.query.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: searchController.clear,
                        child: const Text('Clear Search'),
                      ),
                    ],
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = filteredTodos[index];
                  return TodoItemWidget(
                    todo: todo,
                    onToggle: todoOperations.toggleTodo,
                    onDelete: showDeleteDialog,
                    onEdit: navigation.goToEditTodo,
                  );
                },
              ),
            );
          } else if (state is TodoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.red[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: todoOperations.loadTodos,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigation.goToAddTodo,
        tooltip: 'todos.add_todo'.tr(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

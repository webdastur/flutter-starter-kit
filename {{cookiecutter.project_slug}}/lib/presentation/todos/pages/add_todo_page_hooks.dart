import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../core/hooks/app_hooks.dart';
import '../../../domain/entities/todo_entity.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_state.dart';

class AddTodoPageHooks extends HookWidget {
  final TodoEntity? todo;

  const AddTodoPageHooks({super.key, this.todo});

  @override
  Widget build(BuildContext context) {
    final isEditing = todo != null;

    // Use custom hooks for form management
    final formController = useTodoForm(initialTodo: todo);
    final todoOperations = useTodoOperations();
    final navigation = useAppNavigation();

    // Handle save todo operation
    void saveTodo() {
      if (!formController.isValid) return;

      final todoEntity = TodoEntity(
        id: todo?.id ?? DateTime.now().millisecondsSinceEpoch,
        todo: formController.todoController.text.trim(),
        completed: formController.isCompleted,
        userId: todo?.userId ?? 1,
      );

      if (isEditing) {
        todoOperations.updateTodo(todoEntity);
      } else {
        todoOperations.addTodo(todoEntity);
      }
    }

    // Listen to BLoC state changes for navigation and feedback
    useEffect(() {
      void blocListener(TodoState state) {
        if (!context.mounted) return;

        if (state is TodoOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          navigation.goBack();
        } else if (state is TodoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      }

      final subscription = context.read<TodoBloc>().stream.listen(blocListener);
      return subscription.cancel;
    }, []);

    // Cleanup on dispose
    useEffect(() {
      return formController.dispose;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'todos.edit'.tr() : 'todos.add'.tr()),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: formController.todoController,
                decoration: InputDecoration(
                  labelText: 'todos.todo_hint'.tr(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.task),
                  errorText: formController.isValid
                      ? null
                      : 'errors.validation'.tr(),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => saveTodo(),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text('todos.completed'.tr()),
                subtitle: Text(
                  formController.isCompleted
                      ? 'todos.completed'.tr()
                      : 'todos.pending'.tr(),
                ),
                value: formController.isCompleted,
                onChanged: formController.setCompleted,
                secondary: Icon(
                  formController.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: formController.isCompleted
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: todoOperations.isLoading
                          ? null
                          : navigation.goBack,
                      child: Text('todos.cancel'.tr()),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          (todoOperations.isLoading || !formController.isValid)
                          ? null
                          : saveTodo,
                      child: todoOperations.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('todos.save'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

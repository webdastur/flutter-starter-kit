import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/hooks/app_hooks.dart';
import '../../../domain/entities/todo_entity.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_state.dart';

class AddTodoPageFormz extends HookWidget {
  final TodoEntity? todo;

  const AddTodoPageFormz({super.key, this.todo});

  @override
  Widget build(BuildContext context) {
    final isEditing = todo != null;

    // Use formz-powered hook for advanced form validation
    final formController = useTodoFormz(initialTodo: todo);
    final todoOperations = useTodoOperations();
    final navigation = useAppNavigation();

    // Handle save todo operation
    void saveTodo() {
      if (!formController.formState.isValid) {
        // Mark all fields as dirty to show validation errors
        formController.onTodoChanged(formController.todoController.text);
        formController.onUserIdChanged(formController.userIdController.text);
        return;
      }

      final todoEntity = TodoEntity(
        id: todo?.id ?? DateTime.now().millisecondsSinceEpoch,
        todo: formController.formState.todoText.value.trim(),
        completed: formController.formState.isCompleted,
        userId: formController.formState.userId.value,
      );

      formController.onSubmit(); // Set form to submitting state

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
        actions: [
          if (formController.formState.status.isPure)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: formController.reset,
              tooltip: 'Reset Form',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Todo text field with formz validation
              TextFormField(
                controller: formController.todoController,
                decoration: InputDecoration(
                  labelText: 'todos.todo_hint'.tr(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.task),
                  errorText: formController.formState.todoText.errorMessage,
                  helperText: formController.formState.todoText.isPure
                      ? 'Enter your todo item'
                      : null,
                  suffixIcon: formController.formState.todoText.isValid
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : formController.formState.todoText.isNotValid
                      ? const Icon(Icons.error, color: Colors.red)
                      : null,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                onChanged: formController.onTodoChanged,
              ),

              const SizedBox(height: 16),

              // User ID field (usually hidden in real apps, but good for demo)
              TextFormField(
                controller: formController.userIdController,
                decoration: InputDecoration(
                  labelText: 'User ID',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                  errorText: formController.formState.userId.errorMessage,
                  helperText: 'User ID (1-1000)',
                  suffixIcon: formController.formState.userId.isValid
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : formController.formState.userId.isNotValid
                      ? const Icon(Icons.error, color: Colors.red)
                      : null,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: formController.onUserIdChanged,
                onFieldSubmitted: (_) => saveTodo(),
              ),

              const SizedBox(height: 16),

              // Completion status toggle
              Card(
                child: SwitchListTile(
                  title: Text('todos.completed'.tr()),
                  subtitle: Text(
                    formController.formState.isCompleted
                        ? 'todos.completed'.tr()
                        : 'todos.pending'.tr(),
                  ),
                  value: formController.formState.isCompleted,
                  onChanged: formController.onCompletedChanged,
                  secondary: Icon(
                    formController.formState.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: formController.formState.isCompleted
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Form status indicator
              if (formController.formState.status.isSubmissionInProgress)
                const Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(width: 16),
                        Text(
                          'Submitting...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              else if (formController.formState.status.isSubmissionFailure)
                const Card(
                  color: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.white),
                        SizedBox(width: 16),
                        Text(
                          'Submission failed. Please try again.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              else if (formController.formState.status.isValid)
                Card(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 16),
                        Text(
                          'Form is valid and ready to submit!',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: formController.formState.isSubmitting
                          ? null
                          : navigation.goBack,
                      child: Text('todos.cancel'.tr()),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: formController.formState.isSubmitting
                          ? null
                          : saveTodo,
                      child: formController.formState.isSubmitting
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

              const SizedBox(height: 32),

              // Debug info (remove in production)
              if (kDebugMode)
                Card(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debug Info:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Text('Form Status: ${formController.formState.status}'),
                        Text(
                          'Todo Valid: ${formController.formState.todoText.isValid}',
                        ),
                        Text(
                          'User ID Valid: ${formController.formState.userId.isValid}',
                        ),
                        Text(
                          'Overall Valid: ${formController.formState.isValid}',
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

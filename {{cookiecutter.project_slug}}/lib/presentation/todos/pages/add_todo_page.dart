import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/todo_entity.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

class AddTodoPage extends StatelessWidget {
  final TodoEntity? todo;

  const AddTodoPage({super.key, this.todo});

  @override
  Widget build(BuildContext context) {
    return AddTodoView(todo: todo);
  }
}

class AddTodoView extends StatefulWidget {
  final TodoEntity? todo;

  const AddTodoView({super.key, this.todo});

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  final _formKey = GlobalKey<FormState>();
  final _todoController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _todoController.text = widget.todo!.todo;
      _isCompleted = widget.todo!.completed;
    }
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'todos.edit'.tr() : 'todos.add'.tr()),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (!mounted) return; // Check if widget is still mounted

          if (state is TodoOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            if (mounted) {
              context.pop();
            }
          } else if (state is TodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is TodoLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      labelText: 'todos.todo_hint'.tr(),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.task),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'errors.validation'.tr();
                      }
                      return null;
                    },
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('todos.completed'.tr()),
                    subtitle: Text(
                      _isCompleted
                          ? 'todos.completed'.tr()
                          : 'todos.pending'.tr(),
                    ),
                    value: _isCompleted,
                    onChanged: (bool value) {
                      setState(() {
                        _isCompleted = value;
                      });
                    },
                    secondary: Icon(
                      _isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _isCompleted ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading ? null : () => context.pop(),
                          child: Text('todos.cancel'.tr()),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _saveTodo,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text('todos.save'.tr()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveTodo() {
    if (!mounted) return; // Check if widget is still mounted

    if (_formKey.currentState!.validate()) {
      final isEditing = widget.todo != null;
      final todo = TodoEntity(
        id: widget.todo?.id ?? DateTime.now().millisecondsSinceEpoch,
        todo: _todoController.text.trim(),
        completed: _isCompleted,
        userId: widget.todo?.userId ?? 1, // Default user ID
      );

      try {
        if (isEditing) {
          context.read<TodoBloc>().add(UpdateTodoEvent(todo));
        } else {
          context.read<TodoBloc>().add(AddTodoEvent(todo));
        }
      } catch (e) {
        // Handle case where BLoC might be closed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

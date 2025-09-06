import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/hooks/app_hooks.dart';
import '../../../core/validation/todo_validation.dart';

/// Demo page showing formz validation examples
class FormzDemoPage extends HookWidget {
  const FormzDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Basic formz input examples
    final todoText = useState(const TodoTextInput.pure());
    final userId = useState(const UserIdInput.pure());
    final isCompleted = useState(false);

    // Combined form status
    final formStatus = useMemoized(
      () => TodoFormStatus.fromInputs([todoText.value, userId.value]),
      [todoText.value, userId.value],
    );

    // Custom formz hook example
    final formzController = useTodoFormz();

    // Async operation for demo
    final submitOperation = useAsyncOperation(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (formStatus.isValid) {
        return 'Form submitted successfully!';
      } else {
        throw Exception('Form is invalid');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formz Validation Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Basic Formz Inputs Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Formz Inputs',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),

                    // Todo text input
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Todo Text',
                        border: const OutlineInputBorder(),
                        errorText: todoText.value.errorMessage,
                        suffixIcon: todoText.value.isValid
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : todoText.value.isNotValid
                            ? const Icon(Icons.error, color: Colors.red)
                            : null,
                      ),
                      onChanged: (value) {
                        todoText.value = TodoTextInput.dirty(value);
                      },
                    ),

                    const SizedBox(height: 16),

                    // User ID input
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'User ID (1-1000)',
                        border: const OutlineInputBorder(),
                        errorText: userId.value.errorMessage,
                        suffixIcon: userId.value.isValid
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : userId.value.isNotValid
                            ? const Icon(Icons.error, color: Colors.red)
                            : null,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final id = int.tryParse(value) ?? 0;
                        userId.value = UserIdInput.dirty(id);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Completion toggle
                    SwitchListTile(
                      title: const Text('Completed'),
                      value: isCompleted.value,
                      onChanged: (value) => isCompleted.value = value,
                    ),

                    const SizedBox(height: 16),

                    // Form status indicator
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: formStatus.isValid
                            ? Colors.green.withValues(alpha: 0.1)
                            : formStatus.isInvalid
                            ? Colors.red.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        border: Border.all(
                          color: formStatus.isValid
                              ? Colors.green
                              : formStatus.isInvalid
                              ? Colors.red
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            formStatus.isValid
                                ? Icons.check_circle
                                : formStatus.isInvalid
                                ? Icons.error
                                : Icons.info,
                            color: formStatus.isValid
                                ? Colors.green
                                : formStatus.isInvalid
                                ? Colors.red
                                : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formStatus.isValid
                                ? 'Form is valid ✅'
                                : formStatus.isInvalid
                                ? 'Form has errors ❌'
                                : 'Form is pristine',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Submit button
                    ElevatedButton(
                      onPressed:
                          formStatus.isValid && !submitOperation.isLoading
                          ? submitOperation.execute
                          : null,
                      child: submitOperation.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Submit Basic Form'),
                    ),

                    if (submitOperation.data != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          submitOperation.data!,
                          style: const TextStyle(color: Colors.green),
                        ),
                      )
                    else if (submitOperation.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          submitOperation.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Custom Hook Form Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Hook Form (useTodoFormz)',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),

                    // Todo text field
                    TextFormField(
                      controller: formzController.todoController,
                      decoration: InputDecoration(
                        labelText: 'Todo Text (Hook)',
                        border: const OutlineInputBorder(),
                        errorText:
                            formzController.formState.todoText.errorMessage,
                        suffixIcon: formzController.formState.todoText.isValid
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : formzController.formState.todoText.isNotValid
                            ? const Icon(Icons.error, color: Colors.red)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // User ID field
                    TextFormField(
                      controller: formzController.userIdController,
                      decoration: InputDecoration(
                        labelText: 'User ID (Hook)',
                        border: const OutlineInputBorder(),
                        errorText:
                            formzController.formState.userId.errorMessage,
                        suffixIcon: formzController.formState.userId.isValid
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : formzController.formState.userId.isNotValid
                            ? const Icon(Icons.error, color: Colors.red)
                            : null,
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    // Completion toggle
                    SwitchListTile(
                      title: const Text('Completed (Hook)'),
                      value: formzController.formState.isCompleted,
                      onChanged: formzController.onCompletedChanged,
                    ),

                    const SizedBox(height: 16),

                    // Form status
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: formzController.formState.isValid
                            ? Colors.green.withValues(alpha: 0.1)
                            : formzController.formState.status.isInvalid
                            ? Colors.red.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        border: Border.all(
                          color: formzController.formState.isValid
                              ? Colors.green
                              : formzController.formState.status.isInvalid
                              ? Colors.red
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                formzController.formState.isValid
                                    ? Icons.check_circle
                                    : formzController.formState.status.isInvalid
                                    ? Icons.error
                                    : Icons.info,
                                color: formzController.formState.isValid
                                    ? Colors.green
                                    : formzController.formState.status.isInvalid
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formzController.formState.isValid
                                    ? 'Hook Form is valid ✅'
                                    : formzController.formState.status.isInvalid
                                    ? 'Hook Form has errors ❌'
                                    : 'Hook Form is pristine',
                              ),
                            ],
                          ),
                          if (formzController.formState.isSubmitting)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Submitting...'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: formzController.reset,
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: formzController.formState.isValid
                                ? formzController.onSubmit
                                : null,
                            child: const Text('Submit Hook Form'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Debug Information (only in debug mode)
            if (kDebugMode)
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Debug Information',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),

                      Text('Basic Form:'),
                      Text(
                        '  Todo Text: ${todoText.value.value} (${todoText.value.isValid ? "✅" : "❌"})',
                      ),
                      Text(
                        '  User ID: ${userId.value.value} (${userId.value.isValid ? "✅" : "❌"})',
                      ),
                      Text('  Status: $formStatus'),

                      const SizedBox(height: 8),

                      Text('Hook Form:'),
                      Text(
                        '  Todo Text: ${formzController.formState.todoText.value} (${formzController.formState.todoText.isValid ? "✅" : "❌"})',
                      ),
                      Text(
                        '  User ID: ${formzController.formState.userId.value} (${formzController.formState.userId.isValid ? "✅" : "❌"})',
                      ),
                      Text('  Status: ${formzController.formState.status}'),
                      Text('  Is Valid: ${formzController.formState.isValid}'),
                      Text(
                        '  Is Submitting: ${formzController.formState.isSubmitting}',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

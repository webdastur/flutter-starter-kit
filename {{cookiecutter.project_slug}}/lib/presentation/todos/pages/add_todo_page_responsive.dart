import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/hooks/app_hooks.dart';
import '../../../domain/entities/todo_entity.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_state.dart';

class AddTodoPageResponsive extends HookWidget {
  final TodoEntity? todo;

  const AddTodoPageResponsive({super.key, this.todo});

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
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(AppDimensions.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
          );
          navigation.goBack();
        } else if (state is TodoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(AppDimensions.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
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
        title: Text(
          isEditing ? 'todos.edit'.tr() : 'todos.add'.tr(),
          style: TextStyle(
            fontSize: AppTypography.titleLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (formController.formState.status.isPure)
            IconButton(
              icon: Icon(Icons.refresh, size: AppDimensions.iconMd),
              onPressed: formController.reset,
              tooltip: 'Reset Form',
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Mobile-focused layout optimization
          final isLargePhone = AppDimensions.isLargePhone;

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: double.infinity, // Full width for mobile
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AppDimensions.spacingMd),

                    // Hero section with icon and description
                    Card(
                      elevation: AppDimensions.cardElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.cardRadius,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.cardPadding),
                        child: Column(
                          children: [
                            Icon(
                              isEditing ? Icons.edit_note : Icons.add_task,
                              size: AppDimensions.iconXl,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(height: AppDimensions.spacingSm),
                            Text(
                              isEditing
                                  ? 'Update your todo item'
                                  : 'Create a new todo item',
                              style: TextStyle(
                                fontSize: AppTypography.bodyLarge,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppDimensions.spacingLg),

                    // Form section
                    Card(
                      elevation: AppDimensions.cardElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.cardRadius,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.cardPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Todo text field with formz validation
                            TextFormField(
                              controller: formController.todoController,
                              decoration: InputDecoration(
                                labelText: 'todos.todo_hint'.tr(),
                                labelStyle: TextStyle(
                                  fontSize: AppTypography.bodyMedium,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.inputRadius,
                                  ),
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(AppDimensions.sm),
                                  child: Icon(
                                    Icons.task,
                                    size: AppDimensions.iconMd,
                                  ),
                                ),
                                errorText: formController
                                    .formState
                                    .todoText
                                    .errorMessage,
                                helperText:
                                    formController.formState.todoText.isPure
                                    ? 'Enter your todo item'
                                    : null,
                                helperStyle: TextStyle(
                                  fontSize: AppTypography.labelSmall,
                                ),
                                suffixIcon:
                                    formController.formState.todoText.isValid
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: AppDimensions.iconSm,
                                      )
                                    : formController
                                          .formState
                                          .todoText
                                          .isNotValid
                                    ? Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: AppDimensions.iconSm,
                                      )
                                    : null,
                              ),
                              maxLines: AppDimensions.isCompactPhone ? 2 : 3,
                              style: TextStyle(
                                fontSize: AppTypography.bodyLarge,
                              ),
                              textInputAction: TextInputAction.next,
                              onChanged: formController.onTodoChanged,
                            ),

                            SizedBox(height: AppDimensions.spacingMd),

                            // Mobile-optimized field layout (always vertical)
                            _buildUserIdField(formController),
                            SizedBox(height: AppDimensions.spacingMd),
                            _buildCompletionToggle(formController),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppDimensions.spacingLg),

                    // Form status indicator
                    _buildFormStatusIndicator(formController),

                    SizedBox(height: AppDimensions.spacingLg),

                    // Action buttons
                    _buildActionButtons(
                      formController,
                      navigation,
                      saveTodo,
                      isLargePhone,
                    ),

                    if (kDebugMode) ...[
                      SizedBox(height: AppDimensions.spacingXl),
                      _buildDebugInfo(formController),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserIdField(TodoFormzController formController) {
    return TextFormField(
      controller: formController.userIdController,
      decoration: InputDecoration(
        labelText: 'User ID',
        labelStyle: TextStyle(fontSize: AppTypography.bodyMedium),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(AppDimensions.sm),
          child: Icon(Icons.person, size: AppDimensions.iconMd),
        ),
        errorText: formController.formState.userId.errorMessage,
        helperText: 'User ID (1-1000)',
        helperStyle: TextStyle(fontSize: AppTypography.labelSmall),
        suffixIcon: formController.formState.userId.isValid
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
                size: AppDimensions.iconSm,
              )
            : formController.formState.userId.isNotValid
            ? Icon(Icons.error, color: Colors.red, size: AppDimensions.iconSm)
            : null,
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: AppTypography.bodyLarge),
      textInputAction: TextInputAction.done,
      onChanged: formController.onUserIdChanged,
    );
  }

  Widget _buildCompletionToggle(TodoFormzController formController) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: SwitchListTile(
        title: Text(
          'todos.completed'.tr(),
          style: TextStyle(fontSize: AppTypography.bodyMedium),
        ),
        subtitle: Text(
          formController.formState.isCompleted
              ? 'todos.completed'.tr()
              : 'todos.pending'.tr(),
          style: TextStyle(fontSize: AppTypography.labelMedium),
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
          size: AppDimensions.iconMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
      ),
    );
  }

  Widget _buildFormStatusIndicator(TodoFormzController formController) {
    if (formController.formState.status.isPure) return const SizedBox.shrink();

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (formController.formState.status.isSubmissionInProgress) {
      statusColor = Colors.blue;
      statusIcon = Icons.hourglass_empty;
      statusText = 'Submitting...';
    } else if (formController.formState.status.isSubmissionFailure) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
      statusText = 'Submission failed. Please try again.';
    } else if (formController.formState.status.isValid) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Form is valid and ready to submit!';
    } else {
      return const SizedBox.shrink();
    }

    return Card(
      color: statusColor,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.md),
        child: Row(
          children: [
            if (formController.formState.status.isSubmissionInProgress)
              SizedBox(
                width: AppDimensions.iconMd,
                height: AppDimensions.iconMd,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              Icon(statusIcon, color: Colors.white, size: AppDimensions.iconMd),
            SizedBox(width: AppDimensions.md),
            Expanded(
              child: Text(
                statusText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTypography.bodyMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    TodoFormzController formController,
    AppNavigation navigation,
    VoidCallback saveTodo,
    bool isLargePhone,
  ) {
    // For mobile, always use vertical button layout for better thumb reach
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeightMobile,
          child: ElevatedButton(
            onPressed: formController.formState.isSubmitting ? null : saveTodo,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            child: formController.formState.isSubmitting
                ? SizedBox(
                    height: AppDimensions.iconSm,
                    width: AppDimensions.iconSm,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'todos.save'.tr(),
                    style: TextStyle(fontSize: AppTypography.bodyMedium),
                  ),
          ),
        ),
        SizedBox(height: AppDimensions.spacingSm),
        SizedBox(
          width: double.infinity,
          height: AppDimensions.isCompactPhone
              ? 40.h
              : AppDimensions.buttonHeightSmall,
          child: OutlinedButton(
            onPressed: formController.formState.isSubmitting
                ? null
                : navigation.goBack,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            child: Text(
              'todos.cancel'.tr(),
              style: TextStyle(fontSize: AppTypography.bodyMedium),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDebugInfo(TodoFormzController formController) {
    return Card(
      color: Colors.grey[100],
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Debug Info:',
              style: TextStyle(
                fontSize: AppTypography.titleSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Screen: ${1.sw.toInt()}x${1.sh.toInt()}',
              style: TextStyle(fontSize: AppTypography.bodySmall),
            ),
            Text(
              'Phone Type: ${AppDimensions.phoneType}',
              style: TextStyle(fontSize: AppTypography.bodySmall),
            ),
            Text(
              'Form Status: ${formController.formState.status}',
              style: TextStyle(fontSize: AppTypography.bodySmall),
            ),
            Text(
              'Todo Valid: ${formController.formState.todoText.isValid}',
              style: TextStyle(fontSize: AppTypography.bodySmall),
            ),
            Text(
              'User ID Valid: ${formController.formState.userId.isValid}',
              style: TextStyle(fontSize: AppTypography.bodySmall),
            ),
            Text(
              'Overall Valid: ${formController.formState.isValid}',
              style: TextStyle(fontSize: AppTypography.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}

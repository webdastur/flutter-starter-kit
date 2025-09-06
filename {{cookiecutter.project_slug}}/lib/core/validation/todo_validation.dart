import 'package:formz/formz.dart';

/// Validation error for todo text input
enum TodoTextValidationError { empty, tooShort, tooLong }

/// Formz input for todo text validation
class TodoTextInput extends FormzInput<String, TodoTextValidationError> {
  const TodoTextInput.pure() : super.pure('');
  const TodoTextInput.dirty([super.value = '']) : super.dirty();

  static const int minLength = 1;
  static const int maxLength = 500;

  @override
  TodoTextValidationError? validator(String value) {
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      return TodoTextValidationError.empty;
    }

    if (trimmedValue.length < minLength) {
      return TodoTextValidationError.tooShort;
    }

    if (trimmedValue.length > maxLength) {
      return TodoTextValidationError.tooLong;
    }

    return null;
  }

  /// Get error message for the validation error
  String? get errorMessage {
    switch (displayError) {
      case TodoTextValidationError.empty:
        return 'Todo text cannot be empty';
      case TodoTextValidationError.tooShort:
        return 'Todo text must be at least $minLength character';
      case TodoTextValidationError.tooLong:
        return 'Todo text cannot exceed $maxLength characters';
      case null:
        return null;
    }
  }
}

/// Validation error for user ID input
enum UserIdValidationError { invalid, outOfRange }

/// Formz input for user ID validation
class UserIdInput extends FormzInput<int, UserIdValidationError> {
  const UserIdInput.pure() : super.pure(1);
  const UserIdInput.dirty([super.value = 1]) : super.dirty();

  static const int minUserId = 1;
  static const int maxUserId = 1000;

  @override
  UserIdValidationError? validator(int value) {
    if (value < minUserId || value > maxUserId) {
      return UserIdValidationError.outOfRange;
    }

    return null;
  }

  /// Get error message for the validation error
  String? get errorMessage {
    switch (displayError) {
      case UserIdValidationError.invalid:
        return 'Invalid user ID';
      case UserIdValidationError.outOfRange:
        return 'User ID must be between $minUserId and $maxUserId';
      case null:
        return null;
    }
  }
}

/// Combined form status for todo form
enum TodoFormStatus {
  pure,
  invalid,
  valid,
  submissionInProgress,
  submissionSuccess,
  submissionFailure;

  /// Create status from formz inputs
  static TodoFormStatus fromInputs(List<FormzInput> inputs) {
    if (inputs.any((input) => input.isPure)) {
      return TodoFormStatus.pure;
    }

    if (inputs.any((input) => input.isNotValid)) {
      return TodoFormStatus.invalid;
    }

    return TodoFormStatus.valid;
  }

  /// Check if form is pure (not touched)
  bool get isPure => this == TodoFormStatus.pure;

  /// Check if form is valid
  bool get isValid => this == TodoFormStatus.valid;

  /// Check if form is invalid
  bool get isInvalid => this == TodoFormStatus.invalid;

  /// Check if form is being submitted
  bool get isSubmissionInProgress =>
      this == TodoFormStatus.submissionInProgress;

  /// Check if submission was successful
  bool get isSubmissionSuccess => this == TodoFormStatus.submissionSuccess;

  /// Check if submission failed
  bool get isSubmissionFailure => this == TodoFormStatus.submissionFailure;
}

/// Todo form state that combines all inputs
class TodoFormState {
  final TodoTextInput todoText;
  final UserIdInput userId;
  final bool isCompleted;
  final TodoFormStatus status;

  const TodoFormState({
    this.todoText = const TodoTextInput.pure(),
    this.userId = const UserIdInput.pure(),
    this.isCompleted = false,
    this.status = TodoFormStatus.pure,
  });

  /// Create a copy with updated values
  TodoFormState copyWith({
    TodoTextInput? todoText,
    UserIdInput? userId,
    bool? isCompleted,
    TodoFormStatus? status,
  }) {
    final newTodoText = todoText ?? this.todoText;
    final newUserId = userId ?? this.userId;

    return TodoFormState(
      todoText: newTodoText,
      userId: newUserId,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? TodoFormStatus.fromInputs([newTodoText, newUserId]),
    );
  }

  /// Check if form is valid and ready to submit
  bool get isValid => status.isValid;

  /// Check if form is being submitted
  bool get isSubmitting => status.isSubmissionInProgress;

  /// Check if submission was successful
  bool get isSubmissionSuccess => status.isSubmissionSuccess;

  /// Check if submission failed
  bool get isSubmissionFailure => status.isSubmissionFailure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoFormState &&
          runtimeType == other.runtimeType &&
          todoText == other.todoText &&
          userId == other.userId &&
          isCompleted == other.isCompleted &&
          status == other.status;

  @override
  int get hashCode =>
      todoText.hashCode ^
      userId.hashCode ^
      isCompleted.hashCode ^
      status.hashCode;

  @override
  String toString() {
    return 'TodoFormState{todoText: $todoText, userId: $userId, isCompleted: $isCompleted, status: $status}';
  }
}

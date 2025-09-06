import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const TodoEntity({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  TodoEntity copyWith({int? id, String? todo, bool? completed, int? userId}) {
    return TodoEntity(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object> get props => [id, todo, completed, userId];

  @override
  String toString() {
    return 'TodoEntity(id: $id, todo: $todo, completed: $completed, userId: $userId)';
  }
}

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/todo_entity.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class TodoModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String todo;

  @HiveField(2)
  final bool completed;

  @HiveField(3)
  final int userId;

  TodoModel({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  factory TodoModel.fromEntity(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      todo: entity.todo,
      completed: entity.completed,
      userId: entity.userId,
    );
  }

  TodoEntity toEntity() {
    return TodoEntity(id: id, todo: todo, completed: completed, userId: userId);
  }

  TodoModel copyWith({int? id, String? todo, bool? completed, int? userId}) {
    return TodoModel(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'TodoModel(id: $id, todo: $todo, completed: $completed, userId: $userId)';
  }
}

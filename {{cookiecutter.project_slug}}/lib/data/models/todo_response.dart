import 'package:json_annotation/json_annotation.dart';

import 'todo_model.dart';

part 'todo_response.g.dart';

@JsonSerializable()
class TodoResponse {
  final List<TodoModel> todos;
  final int total;
  final int skip;
  final int limit;

  const TodoResponse({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory TodoResponse.fromJson(Map<String, dynamic> json) =>
      _$TodoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TodoResponseToJson(this);
}

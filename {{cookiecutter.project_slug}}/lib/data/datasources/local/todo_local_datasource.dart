import 'package:hive/hive.dart';

import '../../models/todo_model.dart';

class TodoLocalDataSource {
  final Box<TodoModel> _todoBox;

  TodoLocalDataSource(this._todoBox);

  Future<List<TodoModel>> getTodos() async {
    return _todoBox.values.toList();
  }

  Future<TodoModel?> getTodo(int id) async {
    return _todoBox.values.firstWhere(
      (todo) => todo.id == id,
      orElse: () => throw Exception('Todo not found'),
    );
  }

  Future<void> cacheTodos(List<TodoModel> todos) async {
    await _todoBox.clear();
    for (final todo in todos) {
      await _todoBox.put(todo.id, todo);
    }
  }

  Future<void> cacheTodo(TodoModel todo) async {
    await _todoBox.put(todo.id, todo);
  }

  Future<void> deleteTodo(int id) async {
    await _todoBox.delete(id);
  }

  Future<void> clearCache() async {
    await _todoBox.clear();
  }

  bool get isEmpty => _todoBox.isEmpty;

  bool get isNotEmpty => _todoBox.isNotEmpty;
}

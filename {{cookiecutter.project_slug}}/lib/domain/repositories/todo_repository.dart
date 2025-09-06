import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoEntity>>> getTodos({int? limit, int? skip});
  Future<Either<Failure, TodoEntity>> getTodo(int id);
  Future<Either<Failure, TodoEntity>> addTodo(TodoEntity todo);
  Future<Either<Failure, TodoEntity>> updateTodo(TodoEntity todo);
  Future<Either<Failure, void>> deleteTodo(int id);
  Future<Either<Failure, List<TodoEntity>>> getTodosByUser(int userId);
}

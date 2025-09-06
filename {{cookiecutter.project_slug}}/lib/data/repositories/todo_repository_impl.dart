import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/local/todo_local_datasource.dart';
import '../datasources/remote/todo_remote_datasource.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource _remoteDataSource;
  final TodoLocalDataSource _localDataSource;

  TodoRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodos({
    int? limit,
    int? skip,
  }) async {
    try {
      final response = await _remoteDataSource.getTodos(
        limit: limit,
        skip: skip,
      );
      final todos = response.todos.map((model) => model.toEntity()).toList();

      // Cache the todos locally
      await _localDataSource.cacheTodos(response.todos);

      return Right(todos);
    } on DioException catch (e) {
      // Try to get cached data if network fails
      try {
        final cachedTodos = await _localDataSource.getTodos();
        if (cachedTodos.isNotEmpty) {
          final todos = cachedTodos.map((model) => model.toEntity()).toList();
          return Right(todos);
        }
      } catch (_) {}

      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> getTodo(int id) async {
    try {
      final todoModel = await _remoteDataSource.getTodo(id);
      final todo = todoModel.toEntity();

      // Cache the todo locally
      await _localDataSource.cacheTodo(todoModel);

      return Right(todo);
    } on DioException catch (e) {
      // Try to get cached data if network fails
      try {
        final cachedTodo = await _localDataSource.getTodo(id);
        if (cachedTodo != null) {
          return Right(cachedTodo.toEntity());
        }
      } catch (_) {}

      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> addTodo(TodoEntity todo) async {
    try {
      final todoData = {
        'todo': todo.todo,
        'completed': todo.completed,
        'userId': todo.userId,
      };

      final todoModel = await _remoteDataSource.addTodo(todoData);
      final newTodo = todoModel.toEntity();

      // Cache the new todo locally
      await _localDataSource.cacheTodo(todoModel);

      return Right(newTodo);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> updateTodo(TodoEntity todo) async {
    try {
      final todoData = {
        'todo': todo.todo,
        'completed': todo.completed,
        'userId': todo.userId,
      };

      final todoModel = await _remoteDataSource.updateTodo(todo.id, todoData);
      final updatedTodo = todoModel.toEntity();

      // Update cached todo locally
      await _localDataSource.cacheTodo(todoModel);

      return Right(updatedTodo);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(int id) async {
    try {
      await _remoteDataSource.deleteTodo(id);

      // Delete from local cache
      await _localDataSource.deleteTodo(id);

      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodosByUser(int userId) async {
    try {
      final response = await _remoteDataSource.getTodosByUser(userId);
      final todos = response.todos.map((model) => model.toEntity()).toList();

      return Right(todos);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Connection timeout');
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: 'No internet connection');
      case DioExceptionType.badResponse:
        return ServerFailure(
          message: e.response?.statusMessage ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      default:
        return NetworkFailure(message: e.message ?? 'Network error');
    }
  }
}

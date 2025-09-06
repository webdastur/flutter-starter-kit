import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/todo_model.dart';
import '../../models/todo_response.dart';

part 'todo_remote_datasource.g.dart';

@RestApi()
abstract class TodoRemoteDataSource {
  factory TodoRemoteDataSource(Dio dio) = _TodoRemoteDataSource;

  @GET('/todos')
  Future<TodoResponse> getTodos({
    @Query('limit') int? limit,
    @Query('skip') int? skip,
  });

  @GET('/todos/{id}')
  Future<TodoModel> getTodo(@Path('id') int id);

  @GET('/todos/user/{userId}')
  Future<TodoResponse> getTodosByUser(@Path('userId') int userId);

  @POST('/todos/add')
  Future<TodoModel> addTodo(@Body() Map<String, dynamic> todo);

  @PUT('/todos/{id}')
  Future<TodoModel> updateTodo(
    @Path('id') int id,
    @Body() Map<String, dynamic> todo,
  );

  @DELETE('/todos/{id}')
  Future<TodoModel> deleteTodo(@Path('id') int id);
}

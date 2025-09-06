import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../../data/datasources/local/todo_local_datasource.dart';
import '../../data/datasources/remote/todo_remote_datasource.dart';
import '../../data/models/todo_model.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../presentation/todos/todos.dart';
import '../utils/logger_config.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

@module
abstract class RegisterModule {
  @singleton
  Talker get talker => LoggerConfig.createTalker();

  @singleton
  Dio dio(Talker talker) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: false, // Reduce noise
          printResponseHeaders: false, // Reduce noise
          printRequestData: true,
          printResponseData: true,
          printResponseMessage: true,
          printErrorData: true,
          printErrorHeaders: false,
          printErrorMessage: true,
        ),
      ),
    );

    return dio;
  }

  @singleton
  @preResolve
  Future<Box<TodoModel>> get todoBox async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoModelAdapter());
    return await Hive.openBox<TodoModel>('todos');
  }
}

@module
abstract class DataSourceModule {
  @singleton
  TodoRemoteDataSource todoRemoteDataSource(Dio dio) =>
      TodoRemoteDataSource(dio);

  @singleton
  TodoLocalDataSource todoLocalDataSource(Box<TodoModel> box) =>
      TodoLocalDataSource(box);
}

@module
abstract class RepositoryModule {
  @singleton
  TodoRepository todoRepository(
    TodoRemoteDataSource remoteDataSource,
    TodoLocalDataSource localDataSource,
  ) => TodoRepositoryImpl(remoteDataSource, localDataSource);
}

@module
abstract class BlocModule {
  @singleton
  TodoBloc todoBloc(TodoRepository repository) => TodoBloc(repository);
}

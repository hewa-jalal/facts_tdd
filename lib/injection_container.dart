import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:facts_tdd/core/network/network_info.dart';
import 'package:facts_tdd/data/datasources/fact_local_data_source.dart';
import 'package:facts_tdd/data/repositories/fact_repository_impl.dart';
import 'package:facts_tdd/domain/repositories/fact_repository.dart';
import 'package:facts_tdd/domain/usecases/get_concrete_fact.dart';
import 'package:facts_tdd/presentation/bloc/fact_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/fact_remote_data_source.dart';
import 'domain/usecases/get_random_fact.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.I;

Future<void> init() async {
  // FEATURES
  sl.registerFactory(() => FactBloc(concrete: sl(), random: sl()));

  // usecases
  sl.registerLazySingleton(() => GetConcreteFact(sl()));
  sl.registerLazySingleton(() => GetRandomFact(sl()));
  // repository
  sl.registerLazySingleton<FactRepository>(
    () => FactRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // data sources
  sl.registerLazySingleton<FactLocalDataSource>(
      () => SharedPreferencesFactLocalDataSource(sl()));
  sl.registerLazySingleton<FactRemoteDataSource>(
      () => HttpFactRemoteDataSource(sl()));

  // Core

  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoDataConnectionChecker(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

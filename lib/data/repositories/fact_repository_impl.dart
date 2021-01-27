import 'package:facts_tdd/core/errors/exceptions.dart';
import 'package:facts_tdd/core/network/network_info.dart';
import 'package:facts_tdd/data/datasources/fact_local_data_source.dart';
import 'package:facts_tdd/data/datasources/fact_remote_data_source.dart';
import 'package:facts_tdd/domain/entities/fact.dart';
import 'package:facts_tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:facts_tdd/domain/repositories/fact_repository.dart';
import 'package:flutter/foundation.dart';

typedef Future<Fact> _ConcreteOrRandomChooser();

class FactRepositoryImpl implements FactRepository {
  final FactLocalDataSource localDataSource;
  final FactRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FactRepositoryImpl({
    @required this.localDataSource,
    @required this.remoteDataSource,
    @required this.networkInfo,
  });
  @override
  Future<Either<Failure, Fact>> getConcreteFact(String searchWord) async {
    return await _getFact(() => remoteDataSource.getConcreteFact(searchWord));
  }

  @override
  Future<Either<Failure, Fact>> getRandomFact() async {
    return await _getFact(() => remoteDataSource.getRandomFact());
  }

  Future<Either<Failure, Fact>> _getFact(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final fact = await getConcreteOrRandom();
        localDataSource.cacheFact(fact);
        return Right(fact);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localFact = await localDataSource.getLastFact();
        return Right(localFact);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

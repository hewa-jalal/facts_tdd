import 'package:dartz/dartz.dart';
import 'package:facts_tdd/core/errors/exceptions.dart';
import 'package:facts_tdd/core/errors/failures.dart';
import 'package:facts_tdd/core/network/network_info.dart';
import 'package:facts_tdd/data/datasources/fact_local_data_source.dart';
import 'package:facts_tdd/data/datasources/fact_remote_data_source.dart';
import 'package:facts_tdd/data/models/fact_model.dart';
import 'package:facts_tdd/data/repositories/fact_repository_impl.dart';
import 'package:facts_tdd/domain/entities/fact.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFactLocalDataSource extends Mock implements FactLocalDataSource {}

class MockFactRemoteDataSource extends Mock implements FactRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  FactRepositoryImpl repository;
  MockFactLocalDataSource mockLocalDataSource;
  MockFactRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockFactLocalDataSource();
    mockRemoteDataSource = MockFactRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = FactRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group(
    'getConcreteFact',
    () {
      final tSearchWord = 'trivia test';
      final tFactModel = FactModel(trivia: tSearchWord);
      final Fact tFact = tFactModel;

      test('should check if the device is online', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteFact(tSearchWord);
        // assert
        verify(mockNetworkInfo.isConnected);
      });

      runTestsOnline(() {
        test('should return remote data when call is successful', () async {
          // arrange
          when(mockRemoteDataSource.getConcreteFact(any))
              .thenAnswer((_) async => tFactModel);
          // act
          final result = await repository.getConcreteFact(tSearchWord);
          // assert
          verify(mockRemoteDataSource.getConcreteFact(tSearchWord));
          expect(result, equals(Right(tFact)));
        });

        test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getConcreteFact(any))
              .thenAnswer((_) async => tFactModel);
          // act
          await repository.getConcreteFact(tSearchWord);
          // assert
          verify(mockRemoteDataSource.getConcreteFact(tSearchWord));
          verify(mockLocalDataSource.cacheFact(tFactModel));
        });

        test(
            'should return ServerFailure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getConcreteFact(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteFact(tSearchWord);
          // assert
          verify(mockRemoteDataSource.getConcreteFact(tSearchWord));
          // there is nothing to cache
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        });
      });

      runTestsOffline(() {
        test('should return last cached fact when the cached data is present',
            () async {
          // arrange
          when(mockLocalDataSource.getLastFact())
              .thenAnswer((_) async => tFactModel);
          // act
          final result = await repository.getConcreteFact(tSearchWord);
          // assert

          // we shouldn't interact with remote data source as we are offline
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastFact());
          expect(result, equals(Right(tFact)));
        });

        test('should return CacheFailure when there is no cached data',
            () async {
          // arrange
          when(mockLocalDataSource.getLastFact()).thenThrow(CacheException());
          // act
          final result = await repository.getConcreteFact(tSearchWord);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastFact());
          expect(result, equals(Left(CacheFailure())));
        });
      });
    },
  );

  group(
    'getRandomFact',
    () {
      final tFactModel = FactModel(trivia: 'test');
      final Fact tFact = tFactModel;

      test('should check if the device is online', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getRandomFact();
        // assert
        verify(mockNetworkInfo.isConnected);
      });

      runTestsOnline(() {
        test('should return remote data when call is successful', () async {
          // arrange
          when(mockRemoteDataSource.getRandomFact())
              .thenAnswer((_) async => tFactModel);
          // act
          final result = await repository.getRandomFact();
          // assert
          verify(mockRemoteDataSource.getRandomFact());
          expect(result, equals(Right(tFact)));
        });

        test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getRandomFact())
              .thenAnswer((_) async => tFactModel);
          // act
          await repository.getRandomFact();
          // assert
          verify(mockRemoteDataSource.getRandomFact());
          verify(mockLocalDataSource.cacheFact(tFactModel));
        });

        test(
            'should return ServerFailure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getRandomFact())
              .thenThrow(ServerException());
          // act
          final result = await repository.getRandomFact();
          // assert
          verify(mockRemoteDataSource.getRandomFact());
          // there is nothing to cache
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        });
      });

      runTestsOffline(() {
        test('should return last cached fact when the cached data is present',
            () async {
          // arrange
          when(mockLocalDataSource.getLastFact())
              .thenAnswer((_) async => tFactModel);
          // act
          final result = await repository.getRandomFact();
          // assert

          // we shouldn't interact with remote data source as we are offline
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastFact());
          expect(result, equals(Right(tFact)));
        });

        test('should return CacheFailure when there is no cached data',
            () async {
          // arrange
          when(mockLocalDataSource.getLastFact()).thenThrow(CacheException());
          // act
          final result = await repository.getRandomFact();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastFact());
          expect(result, equals(Left(CacheFailure())));
        });
      });
    },
  );
}

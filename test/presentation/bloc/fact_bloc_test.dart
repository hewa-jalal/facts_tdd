import 'package:dartz/dartz.dart';
import 'package:facts_tdd/core/errors/failures.dart';
import 'package:facts_tdd/core/util/constants.dart';

import 'package:facts_tdd/domain/entities/fact.dart';
import 'package:facts_tdd/domain/usecases/get_concrete_fact.dart';
import 'package:facts_tdd/domain/usecases/get_random_fact.dart';
import 'package:facts_tdd/presentation/bloc/fact_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteFact extends Mock implements GetConcreteFact {}

class MockGetRandomFact extends Mock implements GetRandomFact {}

void main() {
  FactBloc bloc;
  MockGetConcreteFact mockGetConcreteFact;
  MockGetRandomFact mockGetRandomFact;

  setUp(() {
    mockGetConcreteFact = MockGetConcreteFact();
    mockGetRandomFact = MockGetRandomFact();

    bloc = FactBloc(
      concrete: mockGetConcreteFact,
      random: mockGetRandomFact,
    );

    test('initialState should be Empty', () {
      // assert
      expect(bloc.state, equals(FactEmpty()));
    });

    group('GetFactConcreteEvent', () {
      final tSearchWord = 'test';
      final tFact = Fact(trivia: tSearchWord);

      test('should get data from concrete use case', () async {
        // arrange
        when(mockGetConcreteFact(any)).thenAnswer((_) async => Right(tFact));
        // act
        bloc.add(GetConcreteFactEvent(tSearchWord));
        await untilCalled(mockGetConcreteFact(any));
        // assert
        verify(mockGetConcreteFact(Params(searchWord: tSearchWord)));
      });

      test('should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        // arrange
        when(mockGetConcreteFact(any)).thenAnswer((_) async => Right(tFact));

        // assert later
        final excepted = [
          FactLoading(),
          FactLoaded(tFact),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(excepted));
        // act
        bloc.add(GetConcreteFactEvent(tSearchWord));
      });
      test('should emit [Loading, Error] when data getting data fails',
          () async {
        // arrange
        when(mockGetConcreteFact(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final excepted = [
          FactLoading(),
          FactError(SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(excepted));
        // act
        bloc.add(GetConcreteFactEvent(tSearchWord));
      });

      test(
          'should emit [Loading, Error] when data getting data fails from cache',
          () async {
        // arrange
        when(mockGetConcreteFact(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final excepted = [
          FactLoading(),
          FactError(CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(excepted));
        // act
        bloc.add(GetConcreteFactEvent(tSearchWord));
      });
    });
  });
}

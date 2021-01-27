import 'package:facts_tdd/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:facts_tdd/core/usecases/use_case.dart';
import 'package:facts_tdd/domain/entities/fact.dart';
import 'package:facts_tdd/domain/repositories/fact_repository.dart';
import 'package:facts_tdd/domain/usecases/get_random_fact.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFactRepository extends Mock implements FactRepository {}

void main() {
  MockFactRepository mockFactRepository;
  GetRandomFact getRandomFact;

  setUp(() {
    mockFactRepository = MockFactRepository();
    getRandomFact = GetRandomFact(mockFactRepository);
  });

  final tFact = Fact(trivia: 'good');

  test('should get Fact from the repository', () async {
    // arrange
    when(mockFactRepository.getRandomFact())
        .thenAnswer((_) async => Right(tFact));
    // act
    final result = await getRandomFact(NoParams());
    // assert
    expect(result, Right(tFact));
    verify(mockFactRepository.getRandomFact());
    verifyNoMoreInteractions(mockFactRepository);
  });
}

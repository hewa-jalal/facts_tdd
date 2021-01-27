import 'package:dartz/dartz.dart';
import 'package:facts_tdd/domain/entities/fact.dart';
import 'package:facts_tdd/domain/repositories/fact_repository.dart';
import 'package:facts_tdd/domain/usecases/get_concrete_fact.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFactRepository extends Mock implements FactRepository {}

void main() {
  MockFactRepository mockFactRepository;
  GetConcreteFact getConcreteFact;

  setUp(() {
    mockFactRepository = MockFactRepository();
    getConcreteFact = GetConcreteFact(mockFactRepository);
  });

  final tSearchWord = 'hello';
  final tFact = Fact(trivia: 'good');

  test('should get concrete fact from repository', () async {
    // arrange
    when(mockFactRepository.getConcreteFact(any))
        .thenAnswer((_) async => Right(tFact));
    // act
    final result = await getConcreteFact(Params(searchWord: tSearchWord));
    // assert
    expect(result, Right(tFact));
    verify(mockFactRepository.getConcreteFact(tSearchWord));
    verifyNoMoreInteractions(mockFactRepository);
  });
}

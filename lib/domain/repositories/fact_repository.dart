import 'package:dartz/dartz.dart';
import 'package:facts_tdd/core/errors/failures.dart';
import 'package:facts_tdd/domain/entities/fact.dart';

abstract class FactRepository {
  Future<Either<Failure, Fact>> getConcreteFact(String searchWord);

  Future<Either<Failure, Fact>> getRandomFact();
}

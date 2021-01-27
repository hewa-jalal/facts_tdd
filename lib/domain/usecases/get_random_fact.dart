import 'package:dartz/dartz.dart';
import 'package:facts_tdd/core/errors/failures.dart';
import 'package:facts_tdd/core/usecases/use_case.dart';
import 'package:facts_tdd/domain/entities/fact.dart';
import 'package:facts_tdd/domain/repositories/fact_repository.dart';

class GetRandomFact extends UseCase<Fact, NoParams> {
  final FactRepository factRepository;

  GetRandomFact(this.factRepository);
  @override
  Future<Either<Failure, Fact>> call(NoParams params) async {
    return await factRepository.getRandomFact();
  }
}

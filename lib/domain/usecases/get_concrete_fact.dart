import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:facts_tdd/core/errors/failures.dart';
import 'package:facts_tdd/core/usecases/use_case.dart';
import 'package:facts_tdd/domain/entities/fact.dart';
import 'package:facts_tdd/domain/repositories/fact_repository.dart';
import 'package:flutter/foundation.dart';

class GetConcreteFact extends UseCase<Fact, Params> {
  final FactRepository factRepository;

  GetConcreteFact(this.factRepository);

  @override
  Future<Either<Failure, Fact>> call(Params params) async {
    return await factRepository.getConcreteFact(params.searchWord);
  }
}

class Params extends Equatable {
  final String searchWord;

  Params({@required this.searchWord});

  @override
  List<Object> get props => [searchWord];
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:facts_tdd/core/errors/failures.dart';
import 'package:facts_tdd/core/usecases/use_case.dart';
import 'package:facts_tdd/core/util/constants.dart';
import 'package:facts_tdd/domain/entities/fact.dart';
import 'package:facts_tdd/domain/usecases/get_concrete_fact.dart';
import 'package:facts_tdd/domain/usecases/get_random_fact.dart';
import 'package:flutter/foundation.dart';

part 'fact_event.dart';
part 'fact_state.dart';

class FactBloc extends Bloc<FactEvent, FactState> {
  final GetConcreteFact concrete;
  final GetRandomFact random;

  FactBloc({
    @required this.concrete,
    @required this.random,
  })  : assert(concrete != null),
        assert(random != null),
        super(FactEmpty());

  @override
  Stream<FactState> mapEventToState(
    FactEvent event,
  ) async* {
    if (event is GetConcreteFactEvent) {
      yield FactLoading();
      final failureOrFact =
          await concrete(Params(searchWord: event.searchWord));
      yield* _eitherLoadedOrErrorState(failureOrFact);
    } else if (event is GetRandomFactEvent) {
      yield FactLoading();
      final failureOrFact = await random(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrFact);
    }
  }

  Stream<FactState> _eitherLoadedOrErrorState(
    Either<Failure, Fact> either,
  ) async* {
    yield either.fold(
      (failure) => FactError(_mapFailureToMessage(failure)),
      (fact) => FactLoaded(fact),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'unexpected error';
    }
  }
}

part of 'fact_bloc.dart';

abstract class FactState extends Equatable {
  const FactState();

  @override
  List<Object> get props => [];
}

class FactEmpty extends FactState {}

class FactLoading extends FactState {}

class FactLoaded extends FactState {
  final Fact fact;

  FactLoaded(this.fact);

  @override
  List<Object> get props => [fact];
}

class FactError extends FactState {
  final String message;

  FactError(this.message);

  @override
  List<Object> get props => [message];
}

part of 'fact_bloc.dart';

abstract class FactEvent extends Equatable {
  const FactEvent();

  @override
  List<Object> get props => [];
}

class GetConcreteFactEvent extends FactEvent {
  final String searchWord;

  GetConcreteFactEvent(this.searchWord);
}

class GetRandomFactEvent extends FactEvent {}

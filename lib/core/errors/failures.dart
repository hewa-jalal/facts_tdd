import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures which exceptions will get converted to from repository impl
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

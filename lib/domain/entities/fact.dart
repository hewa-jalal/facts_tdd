import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Fact extends Equatable {
  final String trivia;

  Fact({@required this.trivia});

  @override
  List<Object> get props => [trivia];
}

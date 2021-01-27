import 'package:facts_tdd/domain/entities/fact.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class FactModel extends Fact {
  @HiveField(0)
  final String trivia;

  FactModel({@required this.trivia}) : super(trivia: trivia);

  factory FactModel.fromJson(Map<String, dynamic> json) {
    return FactModel(trivia: json['trivia'][0]);
  }

  Map<String, dynamic> toJson() {
    return {
      'trivia': ['test trivia']
    };
  }
}

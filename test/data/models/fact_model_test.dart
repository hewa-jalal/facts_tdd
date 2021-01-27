import 'dart:convert';

import 'package:facts_tdd/data/models/fact_model.dart';
import 'package:facts_tdd/domain/entities/fact.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tModel = FactModel(trivia: 'test trivia');

  test('should be a subclass of Fact entity', () async {
    // assert
    expect(tModel, isA<Fact>());
  });

  group('fromJson', () {
    test('should return a valid model fromJson', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('fact.json'));
      // act
      final result = FactModel.fromJson(jsonMap);
      // assert
      expect(result, tModel);
    });
  });

  group('toJson', () {
    test('should return a valid JSON from Model', () async {
      // act
      final result = tModel.toJson();
      // assert
      final expectedMap = {
        'trivia': ['test trivia']
      };
      expect(result, expectedMap);
    });
  });
}

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:facts_tdd/core/errors/exceptions.dart';
import 'package:facts_tdd/core/util/constants.dart';
import 'package:facts_tdd/data/models/fact_model.dart';
import 'package:facts_tdd/data/repositories/fact_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:facts_tdd/data/datasources/fact_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../fixtures/fixture_reader.dart';

// class MockHive extends Mock implements HiveInterface {}

// class MockHiveBox extends Mock implements Box {}

// void main() {
//   HiveFactLocalDataSource dataSource;
//   MockHive mockHive;
//   MockHiveBox mockHiveBox;

//   setUp(() {
//     mockHive = MockHive();
//     mockHiveBox = MockHiveBox();
//     dataSource = HiveFactLocalDataSource(mockHive);
//   });

//   group('getLastFact', () {
//     final tFactModel =
//         FactModel.fromJson(json.decode(fixture('fact_cached.json')));

//     test('should return Fact from Hive when there is one cached', () async {
//       // arrange
//       when(mockHiveBox.get(any)).thenAnswer((_) async => mockHiveBox);
//       // act
//       final result = await dataSource.getLastFact();
//       // assert
//       verify(mockHive.openBox(CACHED_FACT));
//       expect(result, equals(tFactModel));
//     });
//   });
// }

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  SharedPreferencesFactLocalDataSource datasource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = SharedPreferencesFactLocalDataSource(mockSharedPreferences);
  });

  group('getLastFact', () {
    final tFact = FactModel.fromJson(json.decode(fixture('fact_cached.json')));
    test('should return Fact from SharedPreferences when there is one',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('fact_cached.json'));
      // act
      final result = await datasource.getLastFact();
      // assert
      verify(mockSharedPreferences.getString(CACHED_FACT));
      expect(result, tFact);
    });

    test('should throw CacheException when there is no cached Fact', () async {
      // arrange
      when(mockSharedPreferences.get(any)).thenReturn(null);
      // act
      final call = datasource.getLastFact;
      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheFact', () {
    final tFact = FactModel(trivia: 'test trivia');
    test('should call SharedPreferences to store a Fact', () async {
      // act
      datasource.cacheFact(tFact);
      // assert
      final expectedJsonString = json.encode(tFact.toJson());
      verify(mockSharedPreferences.setString(CACHED_FACT, expectedJsonString));
    });

    test('should throw CacheException when there is no cached Fact', () async {
      // arrange
      when(mockSharedPreferences.get(any)).thenReturn(null);
      // act
      final call = datasource.getLastFact;
      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });
}

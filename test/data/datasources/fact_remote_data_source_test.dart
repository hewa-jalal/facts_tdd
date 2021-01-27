import 'dart:convert';

import 'package:facts_tdd/core/errors/exceptions.dart';
import 'package:facts_tdd/data/datasources/fact_remote_data_source.dart';
import 'package:facts_tdd/data/models/fact_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart' as dio;
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../fixtures/fixture_reader.dart';

// class MockDioClient extends Mock implements dio.HttpClientAdapter {}

// void main() {
//   MockDioClient mockDioClient;
//   DioFactRemoteDataSource dataSource;

//   setUp(() {
//     mockDioClient =
//     dataSource = DioFactRemoteDataSource(mockDioClient);
//   });

//   group('getConcreteFact', () {
//     final tSearchWord = 'test';

//     test('should perform a GET request for concrete endpoint', () async {
//       // arrange
//       when(mockDioClient.fetch(any, any, any)).thenAnswer(
//           (_) async => dio.ResponseBody.fromString(fixture('fact.json'), 200));

//       // act
//         dataSource.getConcreteFact(tSearchWord);
//       // assert
//       verify(mockDioClient.fetch());
//     });
//   });
// }

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  HttpFactRemoteDataSource dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = HttpFactRemoteDataSource(mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('fact.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('something went wrong', 404));
  }

  group('getConcreteFact', () {
    final tSearchWord = 'test';

    const Map<String, String> _headers = {
      "content-type": "application/json",
      "x-rapidapi-key": 'b0776bfe9fmshb1ad533efab37e0p1147e8jsn6f4448481d6e',
      "x-rapidapi-host": "webknox-trivia-knowledge-facts-v1.p.rapidapi.com",
    };
    test('should perform GET for concrete Fact', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      dataSource.getConcreteFact(tSearchWord);
      // assert
      verify(mockHttpClient.get(
        'https://webknox-trivia-knowledge-facts-v1.p.rapidapi.com/trivia/search?topic=$tSearchWord',
        headers: _headers,
      ));
    });

    test('should return Fact when the response code is 200', () async {
      final tFactModel = FactModel.fromJson(jsonDecode(fixture('fact.json')));
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getConcreteFact(tSearchWord);
      // assert
      expect(result, tFactModel);
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSource.getConcreteFact(tSearchWord);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('getRandomFact', () {
    const Map<String, String> _headers = {
      "content-type": "application/json",
      "x-rapidapi-key": 'b0776bfe9fmshb1ad533efab37e0p1147e8jsn6f4448481d6e',
      "x-rapidapi-host": "webknox-trivia-knowledge-facts-v1.p.rapidapi.com",
    };
    test('should perform GET for concrete Fact', () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      dataSource.getRandomFact();
      // assert
      verify(mockHttpClient.get(
        'https://webknox-trivia-knowledge-facts-v1.p.rapidapi.com/trivia/random',
        headers: _headers,
      ));
    });

    test('should return Fact when the response code is 200', () async {
      final tFactModel = FactModel.fromJson(jsonDecode(fixture('fact.json')));
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getRandomFact();
      // assert
      expect(result, tFactModel);
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSource.getRandomFact();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}

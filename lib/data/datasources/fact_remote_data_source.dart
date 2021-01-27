import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:facts_tdd/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:facts_tdd/data/models/fact_model.dart';

abstract class FactRemoteDataSource {
  /// throws a [ServerException] for all error codes
  Future<FactModel> getConcreteFact(String searchWord);
  Future<FactModel> getRandomFact();
}

class HttpFactRemoteDataSource implements FactRemoteDataSource {
  final http.Client client;

  HttpFactRemoteDataSource(this.client);

  static const Map<String, String> _headers = {
    "content-type": "application/json",
    "x-rapidapi-key": 'b0776bfe9fmshb1ad533efab37e0p1147e8jsn6f4448481d6e',
    "x-rapidapi-host": "webknox-trivia-knowledge-facts-v1.p.rapidapi.com",
  };
  @override
  Future<FactModel> getConcreteFact(String searchWord) => _getFactFromUrl(
      'https://webknox-trivia-knowledge-facts-v1.p.rapidapi.com/trivia/search?topic=$searchWord');

  @override
  Future<FactModel> getRandomFact() => _getFactFromUrl(
      'https://webknox-trivia-knowledge-facts-v1.p.rapidapi.com/trivia/random');

  Future<FactModel> _getFactFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return FactModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
}

// class DioFactRemoteDataSource implements FactRemoteDataSource {
//   final dio.HttpClientAdapter httpClientAdapter;

//   DioFactRemoteDataSource(this.httpClientAdapter);
//   @override
//   Future<FactModel> getConcreteFact(String searchWord) {
//     // TODO: implement getConcreteFact
//     throw UnimplementedError();
//   }

//   @override
//   Future<FactModel> getRandomFact() {
//     // TODO: implement getRandomFact
//     throw UnimplementedError();
//   }
// }

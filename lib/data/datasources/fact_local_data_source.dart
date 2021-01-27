import 'dart:convert';

import 'package:facts_tdd/core/errors/exceptions.dart';
import 'package:facts_tdd/core/util/constants.dart';
import 'package:facts_tdd/data/models/fact_model.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FactLocalDataSource {
  Future<FactModel> getLastFact();
  Future<void> cacheFact(FactModel factToCache);
}

class SharedPreferencesFactLocalDataSource implements FactLocalDataSource {
  final SharedPreferences sharedPreferences;

  SharedPreferencesFactLocalDataSource(this.sharedPreferences);
  @override
  Future<void> cacheFact(FactModel factToCache) {
    // just a dummy return to pass lint
    return sharedPreferences.setString(
        CACHED_FACT, json.encode(factToCache.toJson()));
  }

  @override
  Future<FactModel> getLastFact() {
    final jsonString = sharedPreferences.getString(CACHED_FACT);
    if (jsonString != null) {
      return Future.value(FactModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}

class HiveFactLocalDataSource implements FactLocalDataSource {
  final HiveInterface hive;

  HiveFactLocalDataSource(this.hive);
  @override
  Future<void> cacheFact(FactModel factToCache) {
    throw UnimplementedError();
  }

  @override
  Future<FactModel> getLastFact() async {
    final hiveBox = await hive.openBox(CACHED_FACT);
    hiveBox.put(CACHED_FACT, 'str');
    final triviaBox = await hiveBox.get(CACHED_FACT);
    print('triviaBox: assert(concrete != null),');
    return Future.value(triviaBox);
  }
}

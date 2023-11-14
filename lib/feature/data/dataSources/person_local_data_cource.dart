import 'dart:convert';
import 'dart:ffi';

import 'package:rick_and_morty/core/error/exception.dart';
import 'package:rick_and_morty/feature/data/models/person_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersonLocalDataSoutce {
  Future<List<PersonModel>> getLastPersonsFromCache();
  Future<void> personsToCache(List<PersonModel> persons);
}

const CACHED_PERSONS_LIST = "CACHED_PERSONS_LIST";

class PersonLocalDataSoutceImpl implements PersonLocalDataSoutce {
  final SharedPreferences sharedPreferences;

  PersonLocalDataSoutceImpl({required this.sharedPreferences});

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() {
    final jsonPersonsList =
        sharedPreferences.getStringList(CACHED_PERSONS_LIST) ?? [];

    if (jsonPersonsList.isNotEmpty) {
      return Future.value(jsonPersonsList
          .map((person) => PersonModel.fromJson(jsonDecode(person)))
          .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> personsToCache(List<PersonModel> persons) {
    final List<String> jsonPersonsList =
        persons.map((person) => jsonEncode(person.toJson())).toList();

    sharedPreferences.setStringList(CACHED_PERSONS_LIST, jsonPersonsList);
    return Future.value(jsonPersonsList);
  }
}

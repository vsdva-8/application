import 'dart:async';
import 'dart:convert';

import 'package:anime_more/entity/anime_query.dart';
import 'package:anime_more/entity/provider_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplytranslate/simplytranslate.dart';

import '../api/api.dart';

class AnimeListNotifier extends AsyncNotifier<AnimeData> {
  late final Dio dio;
  late final RestClient client;
  late final SimplyTranslator translator;
  late final SharedPreferences sp;
  AnimeListNotifier() {
    dio = Dio();
    client = RestClient(dio);
    translator = SimplyTranslator(EngineType.libre);
  }
  @override
  FutureOr<AnimeData> build() async {
    sp = await SharedPreferences.getInstance();
    var query = AnimeQuery.query;
    if (sp.containsKey('lastQuery')) {
      final lastQuery = sp.getString('lastQuery');
      query = Map.from(jsonDecode(lastQuery!));
      ref.watch(ProviderRepository.queryProvider.notifier).updateQuery(query);
    }
    return await client.getAnime(query).then((data) => data);
  }

  Future<void> getAnime(query) async {
    state = const AsyncValue.loading();
    saveLastQuery(query);
    state = await AsyncValue.guard(() async {
      return await client.getAnime(query).then((data) => data);
    });
  }

  saveLastQuery(Map<String, String> query) async {
    await sp.setString('lastQuery', jsonEncode(query));
  }
}

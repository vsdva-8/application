import 'package:anime_more/notifier/anime_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';

class FavoriteAnimeNotifier extends StateNotifier<
    List<AsyncNotifierProvider<AnimeNotifier, OneAnime>>> {
  late final Dio dio;
  late final RestClient client;
  Set<String> animeIds = {};
  FavoriteAnimeNotifier() : super([]) {
    dio = Dio();
    client = RestClient(dio);
    getFavoriteAnime();
  }

  getFavoriteAnime() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('anime_ids')) {
      if (prefs.getString('anime_ids')!.isNotEmpty) {
        animeIds = prefs.getString('anime_ids')!.split(',').toSet();
        List<AsyncNotifierProvider<AnimeNotifier, OneAnime>> animeSet = [];
        for (var id in animeIds) {
          final animeProvider = AsyncNotifierProvider<AnimeNotifier, OneAnime>(
              () => AnimeNotifier(id));
          animeSet.add(animeProvider);
        }
        state = animeSet;
      }
    }
  }

  addAnimeId(id) async {
    if (!animeIds.contains(id)) {
      List<AsyncNotifierProvider<AnimeNotifier, OneAnime>> animeList = [];
      animeList = List.from(state);
      animeList.add(AsyncNotifierProvider<AnimeNotifier, OneAnime>(
          () => AnimeNotifier(id)));
      state = animeList;
      final prefs = await SharedPreferences.getInstance();
      animeIds.add(id);
      prefs.setString('anime_ids', animeIds.join(','));
    }
  }

  removeAnimeId(id) async {
    List<AsyncNotifierProvider<AnimeNotifier, OneAnime>> animeList = [];
    animeList = List.from(state);
    int deletedId = -1;
    for (var i = 0; i < animeIds.length; i++) {
      if (animeIds.elementAt(i) == id) {
        animeIds.removeWhere((element) => element == id);
        deletedId = i;
        break;
      }
    }
    animeList.removeAt(deletedId);
    state = animeList;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('anime_ids', animeIds.join(','));
  }
}

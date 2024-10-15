import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api.dart';
import '../notifier/anime_list_notifier.dart';
import '../notifier/anime_notifier.dart';
import '../notifier/favorite_anime_notifier.dart';
import '../notifier/query_notifier.dart';

class ProviderRepository {
  static final animeListProvider =
      AsyncNotifierProvider<AnimeListNotifier, AnimeData>(
          () => AnimeListNotifier());

  static final queryProvider =
      StateNotifierProvider<QueryNotifier, Map<String, String>>(
          (ref) => QueryNotifier());

  static final favoriteAnimeProvider = StateNotifierProvider<
          FavoriteAnimeNotifier,
          List<AsyncNotifierProvider<AnimeNotifier, OneAnime>>>(
      (ref) => FavoriteAnimeNotifier());

  static final languageProvider = StateProvider<String>(
      (ref) => Platform.localeName.split('_').elementAt(0));
}
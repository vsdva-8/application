import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api.dart';

class AnimeNotifier extends AsyncNotifier<OneAnime> {
  late final Dio dio;
  late final RestClient client;
  final String id;
  AnimeNotifier(this.id) {
    dio = Dio();
    client = RestClient(dio);
  }
  @override
  FutureOr<OneAnime> build() async {
    return await client.getAnimeById(id).then((anime) => anime);
  }
}

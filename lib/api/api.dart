import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi(baseUrl: 'https://kitsu.io/api/edge/anime/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
  @GET('')
  Future<AnimeData> getAnime(@Queries() Map<String, String> query);
  @GET('/{id}')
  Future<OneAnime> getAnimeById(@Path('id') String id);
}

@JsonSerializable()
class Anime {
  final String? id;
  final Map<String, dynamic>? attributes;
  Anime({this.id, this.attributes});

  factory Anime.fromJson(Map<String, dynamic> json) => _$AnimeFromJson(json);
  Map<String, dynamic> toJson() => _$AnimeToJson(this);
}

@JsonSerializable()
class AnimeData {
  final List<Anime>? data;
  final Map<String, int>? meta;
  final Map<String, dynamic>? links;
  AnimeData({this.data, this.meta, this.links});

  factory AnimeData.fromJson(Map<String, dynamic> json) =>
      _$AnimeDataFromJson(json);
  Map<String, dynamic> toJson() => _$AnimeDataToJson(this);
}

@JsonSerializable()
class OneAnime {
  final Anime? data;
  OneAnime({this.data});
  factory OneAnime.fromJson(Map<String, dynamic> json) =>
      _$OneAnimeFromJson(json);
  Map<String, dynamic> toJson() => _$OneAnimeToJson(this);
}

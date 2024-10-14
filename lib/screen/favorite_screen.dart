import 'package:anime_more/entity/provider_repository.dart';
import 'package:anime_more/widget/reusable/anime_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectionProvider = StateProvider<bool>((ref) => true);

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
            backgroundColor: const Color.fromRGBO(54, 69, 79, 1),
            foregroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () async {
                  ref
                      .watch(ProviderRepository.favoriteAnimeProvider.notifier)
                      .getFavoriteAnime();
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 30,
                ))
          ],
        ),
        backgroundColor: const Color.fromRGBO(33, 42, 48, 1),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children:
                ref.watch(ProviderRepository.favoriteAnimeProvider).isEmpty
                    ? [
                        const Center(
                            child: Text('Your favorites list is empty!',
                                style: TextStyle(fontSize: 18)))
                      ]
                    : ref
                        .watch(ProviderRepository.favoriteAnimeProvider)
                        .map((e) => ref.watch(e).when(
                            data: (anime) =>
                                AnimeCard(favorite: false, anime: anime.data),
                            error: (error, stackTrace) => const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                            loading: () => const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: CircularProgressIndicator(
                                        color: Colors.redAccent),
                                  ),
                                )))
                        .toList(),
          ),
        ));
  }
}

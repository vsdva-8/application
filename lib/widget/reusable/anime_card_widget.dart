import 'package:anime_more/notifier/translator_notifier.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api.dart';
import '../../entity/provider_repository.dart';

class AnimeCard extends ConsumerWidget {
  final bool? favorite;
  final Anime? anime;
  AnimeCard({super.key, this.favorite, this.anime});
  final synopsisTranslatorProvider =
      AsyncNotifierProvider<TranslatorNotifier, String>(
          () => TranslatorNotifier());

  final isTranslated = StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        color: const Color.fromRGBO(54, 69, 79, 1),
        shadowColor: const Color.fromRGBO(12, 16, 18, 1),
        elevation: 3,
        child: Column(children: [
          Image.network(
            anime!.attributes!['posterImage']['large'] ?? '',
            loadingBuilder: (context, child, loading) {
              if (loading == null) return child;
              return const Padding(
                padding: EdgeInsets.all(15),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => const Center(
                child: Padding(
              padding: EdgeInsets.all(15),
              child: Icon(Icons.error, color: Colors.white),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              anime!.attributes!['canonicalTitle'] ?? '',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          ExpansionTile(
            onExpansionChanged: (expanded) async {
              if (expanded &&
                  ref.watch(ProviderRepository.languageProvider) != 'en' &&
                  !ref.watch(isTranslated)) {
                await ref
                    .read(synopsisTranslatorProvider.notifier)
                    .translate(anime!.attributes!['synopsis']);
                ref.watch(isTranslated.notifier).state = true;
              }
            },
            childrenPadding: const EdgeInsets.all(0),
            backgroundColor: Colors.white,
            collapsedBackgroundColor: const Color.fromRGBO(54, 69, 79, 1),
            textColor: Colors.black,
            collapsedTextColor: Colors.white,
            initiallyExpanded: false,
            iconColor: Colors.black,
            collapsedIconColor: Colors.white,
            title: const Text(
              'More',
              style: TextStyle(fontSize: 20),
            ),
            children: [
              ref.watch(ProviderRepository.languageProvider) != 'en'
                  ? ref.watch(synopsisTranslatorProvider).when(
                      data: (synopsis) => Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 15, right: 15, bottom: 15),
                            child: Text(
                              synopsis,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                      error: (error, stackTrace) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child:
                                  Text('Error', style: TextStyle(fontSize: 18)),
                            ),
                          ),
                      loading: () => const Padding(
                            padding: EdgeInsets.only(
                                top: 5, left: 5, right: 5, bottom: 15),
                            child: CircularProgressIndicator(
                              color: Colors.redAccent,
                            ),
                          ))
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 15, right: 15, bottom: 15),
                      child: Text(anime!.attributes!['synopsis']??'',
                          style: const TextStyle(fontSize: 18)),
                    ),
              Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text: anime!.attributes!['canonicalTitle'] ??
                                    ''));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text('Title copied')));
                          },
                          icon: const Icon(
                            Icons.copy,
                            size: 30,
                            color: Color.fromRGBO(151, 170, 184, 1),
                          )),
                      IconButton(
                        onPressed: () {
                          favorite!
                              ? ref
                                  .watch(ProviderRepository
                                      .favoriteAnimeProvider.notifier)
                                  .addAnimeId(anime!.id)
                              : ref
                                  .watch(ProviderRepository
                                      .favoriteAnimeProvider.notifier)
                                  .removeAnimeId(anime!.id);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 2),
                              content: favorite!
                                  ? const Text('Anime added to favorites!')
                                  : const Text(
                                      'Anime removed from favorites!')));
                        },
                        icon: Icon(
                          favorite!
                              ? Icons.favorite_rounded
                              : Icons.remove_circle_rounded,
                          color: Colors.redAccent,
                          size: 35,
                        ),
                      )
                    ],
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                      'Episodes: ${anime!.attributes!['episodeCount'] ?? ''}',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    )),
                    Expanded(
                      child: Text(
                        'Status: ${anime!.attributes!['status'] ?? ''}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 15, right: 15, bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                      'Avg rating: ${anime!.attributes!['averageRating'] ?? ''}',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    )),
                    Expanded(
                      child: Text(
                        'Age rating: ${anime!.attributes!['ageRatingGuide'] ?? ''}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 15, right: 15, bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                      'Shown: ${anime!.attributes!['startDate'] != null ? formatDate(DateTime.parse(anime!.attributes!['startDate']), [
                              d,
                              ' ',
                              M,
                              ' ',
                              yyyy
                            ]) : ''} - ${anime!.attributes!['endDate'] != null ? formatDate(DateTime.parse(anime!.attributes!['endDate']), [d, ' ', M, ' ', yyyy]) : ''}',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ))
                  ],
                ),
              )
            ],
          )
        ]));
  }
}

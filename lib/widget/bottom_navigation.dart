import 'package:anime_more/entity/provider_repository.dart';
import 'package:anime_more/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/filter.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavigation extends ConsumerWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const BottomNavigation({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromRGBO(54, 69, 79, 1),
      showUnselectedLabels: true,
      selectedItemColor: Colors.redAccent,
      unselectedItemColor: Colors.white,
      currentIndex: ref.watch(currentIndexProvider),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
            ),
            label: 'Previous'),
        BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded), label: 'Search'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            label: 'Next'),
      ],
      onTap: (index) {
        if (ref.watch(ProviderRepository.animeListProvider).hasValue &&
            !ref.watch(ProviderRepository.animeListProvider).isLoading &&
            !ref.watch(ProviderRepository.animeListProvider).hasError) {
          switch (index) {
            case 0:
              if (ref
                      .watch(ProviderRepository.queryProvider.notifier)
                      .getPageOffset() >
                  10) {
                ref
                    .watch(ProviderRepository.queryProvider.notifier)
                    .changePageOffset(ref
                            .watch(ProviderRepository.queryProvider.notifier)
                            .getPageOffset() -
                        10);
                ref
                    .watch(ProviderRepository.animeListProvider.notifier)
                    .getAnime(ref.watch(ProviderRepository.queryProvider));
              }
              break;
            case 1:
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PopScope(
                        canPop: true,
                        child: const SearchScreen(),
                        onPopInvokedWithResult: (popped, result) {
                          if (ref.watch(filterChanged)) {
                            ref.watch(categoryProvider.notifier).update(
                                (state) => ref
                                    .watch(ProviderRepository
                                        .queryProvider.notifier)
                                    .getCategories());
                            ref.watch(yearIndexProvider.notifier).update(
                                (state) => Filter.yearList.indexWhere(
                                    (element) =>
                                        element ==
                                        int.parse(ref
                                            .watch(ProviderRepository
                                                .queryProvider.notifier)
                                            .getYear())));
                            ref
                                .watch(filterChanged.notifier)
                                .update((state) => false);
                          }
                        },
                      )));
              break;
            case 2:
              if (ref
                          .watch(ProviderRepository.queryProvider.notifier)
                          .getPageOffset() +
                      10 -
                      ref
                          .watch(ProviderRepository.animeListProvider)
                          .value!
                          .meta!['count']! <
                  10) {
                ref
                    .watch(ProviderRepository.queryProvider.notifier)
                    .changePageOffset(ref
                            .watch(ProviderRepository.queryProvider.notifier)
                            .getPageOffset() +
                        10);
                ref
                    .watch(ProviderRepository.animeListProvider.notifier)
                    .getAnime(ref.watch(ProviderRepository.queryProvider));
              }
              break;
          }
        }
        ref.watch(currentIndexProvider.notifier).state = index;
      },
    );
  }
}

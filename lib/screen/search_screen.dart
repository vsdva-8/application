import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/filter.dart';
import '../entity/provider_repository.dart';

final categoryProvider = StateProvider<Set<String>>((ref) =>
    ref.watch(ProviderRepository.queryProvider.notifier).getCategories());
final yearIndexProvider = StateProvider<int>((ref) => Filter.yearList
    .indexWhere((element) =>
        element ==
        int.parse(
            ref.watch(ProviderRepository.queryProvider.notifier).getYear())));

final filterChanged = StateProvider<bool>((ref) => false);

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
          backgroundColor: const Color.fromRGBO(54, 69, 79, 1),
          foregroundColor: Colors.white
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Genres', style: TextStyle(fontSize: 20)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 3),
                    children: Filter.categories
                        .map((category) => Align(
                              alignment: Alignment.center,
                              child: FilterChip(
                                  backgroundColor: const Color.fromRGBO(121, 146, 163, 1),
                                  selectedColor: Colors.redAccent,
                                  showCheckmark: false,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.all(0),
                                  label: Text(
                                    category,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  selected: ref
                                      .watch(categoryProvider)
                                      .contains(category),
                                  onSelected: (selected) {
                                    if (selected) {
                                      Set<String> newCategories = {
                                        ...ref.watch(categoryProvider)
                                      };
                                      newCategories.add(category);
                                      ref
                                          .watch(categoryProvider.notifier)
                                          .update((state) => newCategories);
                                    } else {
                                      Set<String> newCategories = {
                                        ...ref.watch(categoryProvider)
                                      };
                                      newCategories.remove(category);
                                      ref
                                          .watch(categoryProvider.notifier)
                                          .update((state) => newCategories);
                                    }
                                    ref
                                        .watch(filterChanged.notifier)
                                        .update((state) => true);
                                  }),
                            ))
                        .toList()),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text('Year', style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: SizedBox(
                  height: 90,
                  width: 150,
                  child: CupertinoPicker(
                      diameterRatio: 2,
                      looping: true,
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(
                          initialItem: ref.watch(yearIndexProvider)),
                      onSelectedItemChanged: (index) {
                        ref.watch(yearIndexProvider.notifier).state = index;
                        ref
                            .watch(filterChanged.notifier)
                            .update((state) => true);
                      },
                      children: Filter.yearList
                          .map((year) => Center(
                                  child: Text(
                                '$year',
                                style: const TextStyle(fontSize: 17),
                              )))
                          .toList()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      ref
                          .watch(ProviderRepository.queryProvider.notifier)
                          .changeCategories(ref.watch(categoryProvider));
                      ref
                          .watch(ProviderRepository.queryProvider.notifier)
                          .changeYear(Filter.yearList
                              .elementAt(ref.watch(yearIndexProvider)));
                      ref
                          .watch(ProviderRepository.queryProvider.notifier)
                          .changePageOffset(10);
                      ref
                          .watch(ProviderRepository.animeListProvider.notifier)
                          .getAnime(
                              ref.watch(ProviderRepository.queryProvider));
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(fontSize: 20),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

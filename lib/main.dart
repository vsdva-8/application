import 'package:anime_more/entity/provider_repository.dart';
import 'package:anime_more/screen/favorite_screen.dart';
import 'package:anime_more/widget/bottom_navigation.dart';
import 'package:anime_more/widget/reusable/anime_card_widget.dart';
import 'package:anime_more/widget/settings_sidesheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:side_sheet/side_sheet.dart';

void main() async {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return MaterialApp(
      theme: ThemeData(
          dividerColor: Colors.transparent,
          useMaterial3: true,
          fontFamily: 'SF-Pro-Display',
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(33, 42, 48, 1),
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Anime More'),
          backgroundColor: const Color.fromRGBO(54, 69, 79, 1),
          foregroundColor: Colors.white,
          actions: [
            Builder(builder: (context) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () async {
                        SideSheet.right(
                          sheetBorderRadius: 15,
                            sheetColor: const Color.fromRGBO(54, 69, 79, 1),
                            body: const SettingsSidesheet(),
                            context: context);
                      },
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () async {
                        ref
                            .watch(
                                ProviderRepository.animeListProvider.notifier)
                            .getAnime(
                                ref.watch(ProviderRepository.queryProvider));
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const FavoriteScreen()));
                      },
                      icon: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.redAccent,
                        size: 30,
                      ))
                ],
              );
            })
          ],
        ),
        body: Column(
          children: [
            Flexible(
              child: ref.watch(ProviderRepository.animeListProvider).when(
                  data: (animeData) => Padding(
                        padding: const EdgeInsets.all(15),
                        child: ListView(
                            children: animeData.data!
                                .map((anime) =>
                                    AnimeCard(favorite: true, anime: anime))
                                .toList()),
                      ),
                  error: (error, stackTrace) {
                    return const Center(
                      child: Text('Check connection and retry',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    );
                  },
                  loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.redAccent))),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigation(scaffoldKey: scaffoldKey),
      ),
    );
  }
}

import 'package:anime_more/entity/provider_repository.dart';
import 'package:anime_more/entity/setting_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<Sorting> ratingSortingProvider=StateProvider((ref)=>ref.watch(ProviderRepository.queryProvider.notifier).getSetting(SettingOption.ratingSorting));

class SettingsSidesheet extends ConsumerWidget {
  const SettingsSidesheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const color=Colors.lightBlue;
    final fillColor=WidgetStateProperty.all(Colors.lightBlue);
    const textStyle=TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.white);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Settings', style: textStyle),
            ],
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  children: [
                    const Text('Rating:', style: textStyle),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SegmentedButton(
                        style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                          return states.contains(WidgetState.selected)? Colors.lightBlue: Colors.transparent;})),
                          showSelectedIcon: false,
                          segments: const [ButtonSegment(value: Sorting.ascending, label: Icon(Icons.arrow_upward_rounded, color: Colors.white)), ButtonSegment(value: Sorting.descending, icon: Icon(Icons.arrow_downward_rounded, color: Colors.white))], onSelectionChanged: (value){
                        ref.watch(ratingSortingProvider.notifier).update((state)=>value.first);
                          }, selected: <Sorting>{ref.watch(ratingSortingProvider)}),
                    )
                  ],
                )
              ]
            ),
          ),
          TextButton(onPressed: (){
            if(ref.watch(ratingSortingProvider)!=Sorting.empty){
              ref.watch(ProviderRepository.queryProvider.notifier).changeRatingSorting(ref.watch(ratingSortingProvider));
            }
            ref
              .watch(ProviderRepository.animeListProvider.notifier)
              .getAnime(
              ref.watch(ProviderRepository.queryProvider));
          Navigator.of(context).pop();}, style:  TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))), child: const Text(
          'Apply'))
        ],
      ),
    );
  }
}

import 'package:anime_more/entity/provider_repository.dart';
import 'package:anime_more/entity/sorting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<Sorting?> ratingSortingProvider=StateProvider((ref)=>Sorting.empty);

class SettingsSidesheet extends ConsumerWidget {
  const SettingsSidesheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const radioButtonColor=Colors.lightBlue;
    final fillColor=WidgetStateProperty.all(Colors.lightBlue);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Settings', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(title: const Text('Average rating'), textColor: Colors.white, subtitle: Column(children: [
                  RadioListTile(
                      fillColor: fillColor,
                      activeColor: radioButtonColor, value: Sorting.ascending, groupValue: ref.watch(ratingSortingProvider), onChanged: (value){ref.watch(ratingSortingProvider.notifier).update((state)=>value);
                    }, title: const Text('Ascending', style: TextStyle(color: Colors.white))),
                  RadioListTile(
                      fillColor: fillColor,
                      activeColor: radioButtonColor, value: Sorting.descending, groupValue: ref.watch(ratingSortingProvider), onChanged: (value){ref.watch(ratingSortingProvider.notifier).update((state)=>value);
                    }, title: const Text('Descending', style: TextStyle(color: Colors.white))),
                ],),)
              ]
            ),
          ),
          TextButton(onPressed: (){
            if(ref.watch(ratingSortingProvider)!=Sorting.empty){
              ref.watch(ProviderRepository.queryProvider.notifier).changeRatingSorting(ref.watch(ratingSortingProvider)!);
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

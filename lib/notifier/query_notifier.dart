import 'package:anime_more/entity/anime_query.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/setting_params.dart';

class QueryNotifier extends StateNotifier<Map<String, String>> {
  QueryNotifier() : super(AnimeQuery.query);

  updateQuery(Map<String, String> query) {
    state = query;
  }

  int getPageOffset() {
    return int.parse(state['page[offset]']!);
  }

  changePageOffset(int pageOffset) {
    Map<String, String> newQuery = Map.from(state);
    newQuery['page[offset]'] = pageOffset.toString();
    state = newQuery;
  }

  Set<String> getCategories() {
    return state['filter[categories]']!.split(',').toSet();
  }

  changeCategories(Set<String> categories) {
    Map<String, String> newQuery = Map.from(state);
    newQuery['filter[categories]'] = categories.join(',');
    state = newQuery;
  }

  String getYear() {
    return state['filter[year]']!;
  }

  changeYear(year) {
    Map<String, String> newQuery = Map.from(state);
    newQuery['filter[year]'] = year.toString();
    state = newQuery;
  }

  changeRatingSorting(Sorting sorting){
    Map<String, String> newQuery = Map.from(state);
    switch(sorting){
      case Sorting.ascending:
        newQuery['sort']='averageRating';
      case Sorting.descending:
        newQuery['sort']='-averageRating';
      case Sorting.empty:
        // TODO: Handle this case.
    }
    state = newQuery;
  }

  getSetting(SettingOption type){
    switch(type){
      case SettingOption.ratingSorting:
        if(state.containsKey('sort')){
          final sorting=state['sort']!.split(',');
          for (var value in sorting) {
            switch(value){
              case 'averageRating':
                return Sorting.ascending;
              case '-averageRating':
                return Sorting.descending;
              default:
                return Sorting.empty;
            }
          }
        }
        else{
          return Sorting.empty;
        }
    }
  }
}

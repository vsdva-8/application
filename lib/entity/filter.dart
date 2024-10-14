import 'dart:collection';

class Filter {
  static List<int> yearList = createYears();
  static final Set<String> categories = SplayTreeSet.from({
    'romance',
    'adventure',
    'school',
    'harem',
    'mecha',
    'fantasy',
    'comedy',
    'music',
    'sports',
    'military',
    'drama',
    'horror',
    'historical',
    'samurai',
    'psychological',
    'ecchi',
    'mystery',
    'seinen'
  });

  static List<int> createYears() {
    List<int> yearList = [];
    for (int i = DateTime.now().year; i >= DateTime.now().year - 100; i--) {
      yearList.add(i);
    }
    return yearList;
  }
}

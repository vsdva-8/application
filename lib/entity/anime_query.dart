class AnimeQuery {
  static final Map<String, String> query = {
    'filter[year]': DateTime.now().year.toString(),
    'filter[categories]': '',
    'page[offset]': '10',
    'page[limit]': '10',
  };
}

import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
//  NewsDbProvider dbProvider = NewsDbProvider();
//  NewsApiProvider apiProvider = NewsApiProvider();
// Instead of the lines above we are adding an abstract class that
// contains different sources. This gives flexibility int he future
// when we want to add new sources 
  List<Source> sources = <Source> [
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache> [
    newsDbProvider,
  ];

  // need a for loop for all sources when it has
  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fecthItem(int id) async {
    ItemModel item;
    var source;
    for(source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break; // found the source
      }
    }

    for (var cache in caches) {
      if (cache != source) { // To avoid duplicates
      cache.addItem(item);
      }
    }
    return item;
  }

  clearCache() async { // this returns a Future
    for (var cache in caches) {
      await cache.clear();
    }
  }
}
// abstract class tells that any object with the same 
//methods or instance variables will be considered as the same type of class
abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}
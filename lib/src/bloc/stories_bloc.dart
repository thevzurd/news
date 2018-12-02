import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>(); // similar to Streamcontroller in streams
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();  // The new stream returned from the transformer -> its the cache map
  final _itemsFetcher = PublishSubject<int>(); // returns the latest item in the stream - in our case its the id

  // Getters to Streams - acts as input to widgets
  Observable<List<int>> get topIds =>  _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream; // stream
  // Getter to Sinks
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
    // pipe takes a stream of events anf forwards to to a destination
  }

  // Repository adds items to repository
  fetchTopIds() async { // To fetch top ids from repository
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return _repository.clearCache(); // clearCache returns a future
  }
// make sure that we apply this transformer only one time.
// otherwise it will create multiple instances of cache.
// for that, we create a construstor (see above)
  _itemsTransformer() {
    // item stream
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>>cache, int id, index) {  // Function invoked each time a new item arrives
        cache[id] = _repository.fecthItem(id);
        return cache; 
        },
      <int, Future<ItemModel>>{},    // Intial value - empty cache map
    );
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
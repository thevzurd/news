import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>(); // similar to Streamcontroller in streams
  final _items = BehaviorSubject<int>(); // returns the latest item in the stream - in our case its the id
  Observable<Map<int, Future<ItemModel>>> items; // The new stream returned from 
  // the transformer -> its the cache map

  // Getters to Streams - acts as input to widgets
  Observable<List<int>> get topIds =>  _topIds.stream;

  // Getter to Sinks
  Function(int) get fetchItem => _items.sink.add;

  StoriesBloc() {
    items = _items.stream.transform(_itemsTransformer());
    // Note that this stream transformer returns a new stream
  }

  // Repository adds items to repository
  fetchTopIds() async { // To fetch top ids from repository
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
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
    _items.close();
  }
}
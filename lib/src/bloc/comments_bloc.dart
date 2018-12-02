import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
// this is similar to the Streambuilder and Itemsbuilder we have in the Stories bloc
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _repository = Repository();
// Getter to Stream
  Observable<Map<int, Future<ItemModel>>> get itemsWithComments =>
      _commentsOutput.stream;

// Getter to Sink
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
        (cache, int id, index) {
      // recursive fetch to get all the child comments under one comment
      cache[id] = _repository.fecthItem(id); // adding the iteam to cache map
      cache[id].then(
          // Promise - as soon as the future resolves the inner function is invoked
          (ItemModel item) { // invoked the function with item is got
        item.kids.forEach((kidId) => fetchItemWithComments(kidId)); 
        // This will add the item (the child comments) again inthe sink
        // and call the transformer on it again - recursive
        // continue this untill allt he children have been resolved
      });
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}

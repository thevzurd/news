import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../bloc/stories_provider.dart';
import 'dart:async';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId}); // initialize with the input itemID

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder : (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Text("still loading");
        }
        return FutureBuilder(
          future : snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!snapshot.hasData) {
              return Text("still loading $itemId");
            }
            return Text(itemSnapshot.data.title);
          },
        );
      },
    );
  }
}
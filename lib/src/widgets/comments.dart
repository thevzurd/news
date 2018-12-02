import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});
  Widget build(context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final children = <Widget>[
          ListTile(
            title: buildText(snapshot.data),
            subtitle: snapshot.data.by == ""
                ? Text("deleted comment")
                : Text(snapshot.data.by),
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: (depth + 1) * 16.0,
            ),
          ),
          Divider(),
        ];
        snapshot.data.kids.forEach((kidId) {
          children.add(Comment(
            // recursive
            itemId: kidId,
            itemMap: itemMap,
            depth: depth + 1,
          ));
        });
        return Column(
          children: children,
        );
      },
    );
  }
  Widget buildText(ItemModel item) {
    final text = item.text
    .replaceAll('&#x27;'," ' ")
    .replaceAll('<p>','')
    .replaceAll('</p>', '');
    return Text(text);
  }
}

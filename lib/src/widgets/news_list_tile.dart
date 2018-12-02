import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../bloc/stories_provider.dart';
import 'dart:async';
import '../widgets/loading_container.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId}); // initialize with the input itemID

  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        else { return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            } else {
            return buildTile(context, itemSnapshot.data); }
          },
        );}
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(children: [
      ListTile(
        onTap: () {
          // static method doesnt need an instance to be created
          // pushnamed is a static method
          // this will appear in the settings in your App's onGenerateroute thing
          Navigator.pushNamed(context, '/${item.id}');
        },
        title: Text(item.title),
        subtitle: Text('${item.score} votes'),
        trailing: Column(
          children: <Widget>[
            Icon(Icons.comment),
            Text('${item.descendants}'),
          ],
        ),
      ),
      Divider( height: 8.0,),
    ]);
  }
}
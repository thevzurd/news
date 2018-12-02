import 'package:flutter/material.dart';
import 'dart:async';
import '../bloc/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  Widget build(context) {
    final bloc = StoriesProvider.of(
        context); // gives access to the bloc up in the app hierarchy
    // context gives the reference to the bloc of the stories provider
    bloc.fetchTopIds(); // NEVER DO THIS - This is because the build
    // method is called a million times each time it renders
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      // Stream only top ids to display
      stream: bloc.topIds,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // no data yet
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // Items Stream will fetch the Item model for each of the item
        // we are planning to display. This means we need a new stream builder
        // Each one of them will be loaded independently. Therefore needs to add an
        // additional FutureBuilder inside it.
        // Problem is Streambuilder is going to rebuild for every single event (incoming)
        // this might cause all the listening FutureBuilders to build the same thing
        // To solve this problem, we use a transformer
        // It creates a collection (or a cache map with key value pairs)
        // This will map the item in the collection to a unique streambuilder
        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data[index]);
              return NewsListTile(
                itemId: snapshot.data[index],
              );
              //return Text(
              //    '${snapshot.data[index]}'); // the data inside is int, but text accepts only string
              // soo add the curly thing
            },
          ),
        );
      }, // StreamBuilder builder
    );
  } // buildlist
}

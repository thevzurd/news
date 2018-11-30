import 'package:flutter/material.dart';
import '../src/screens/news_list.dart';
import 'bloc/stories_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return StoriesProvider(
      // Provider for the whole app
      child: MaterialApp(
        title: 'News',
        home: NewsList(),
      ),
    );
  }
}

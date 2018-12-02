import 'package:flutter/material.dart';
import '../src/screens/news_list.dart';
import 'bloc/stories_provider.dart';
import 'screens/news_detail.dart';
import 'bloc/comments_provider.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return CommentsProvider(
      child: StoriesProvider(
        // Provider for the whole app
        child: MaterialApp(
          title: 'News',
// Navigator asks three questions in the following order
// 1. Do we have a 'home assigned
// 2. Do we have a route map assigned
// 3. Do we have an onGenerateRoute callback setup ?
// We can create a RouteTable where a route name can be assigned to a Page like a URL
// called PageBuilder. Its a Widget that has a builder function that returns an instance of the widget mapped
// However, it is difficult to pass information through it. its useful for static route names
// So we are going to use onGenerateRoute
          // home: NewsList(),

          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) {
            return NewsList();
          },
        );
        break;
      default:
        return MaterialPageRoute(
          builder: (context) {
            final commentsBloc = CommentsProvider.of(context);
            final itemId = int.parse(settings.name.replaceFirst('/', ''));
            commentsBloc.fetchItemWithComments(itemId);
            return NewsDetail(
              itemId: itemId,
            );
          },
        );
        break;
    }
  }
}

import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('FetchTopIds return a list of ids', () async { // first parameter is a title and second parameter is a function that executes the test
  // setup of test case
    final newsApi = NewsApiProvider(); // mock client
    newsApi.client = MockClient((Request request) async {
      return Response(json.encode([1,2,3,4]), 200);
    });
    final ids = await newsApi.fetchTopIds();
  // expectation
    expect(ids, [1,2,3,4]); // first argu is the value you want to test and second is the expectation
  });

    test('FetchItem return a list of ids', () async { // first parameter is a title and second parameter is a function that executes the test
  // setup of test case
    final newsApi = NewsApiProvider(); // mock client
    newsApi.client = MockClient ((Request request) async {
      final jsonMap = {'id' : 123};
      return Response(json.encode(jsonMap), 200);
    });
    final item = await newsApi.fetchItem(999);
  // expectation
    expect(item.id, 123); // first argu is the value you want to test and second is the expectation
  });
}
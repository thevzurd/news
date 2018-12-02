import 'dart:convert';
class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;

  ItemModel.fromJson(Map<String, dynamic> parseJson)
    : id = parseJson['id'],
     deleted = parseJson['deleted'] ?? false, // if this property is not there then default to false
     type = parseJson['type'],
     by = parseJson['by'] ?? '',
     time = parseJson['time'],
     text = parseJson['text'] ?? '',
     dead = parseJson['dead'] ?? false,
     parent = parseJson['parent'],
     kids = parseJson['kids'] ?? [],
     url = parseJson['url'],
     score = parseJson['score'],
     title = parseJson['title'] ?? '',
     descendants = parseJson['descendants'] ?? 0;

    ItemModel.fromDb(Map<String, dynamic> parseJson)
    : id = parseJson['id'],
     deleted = parseJson['deleted'] == 1, // if 1 then it will be set at true. trick to map number to boolean
     type = parseJson['type'],
     by = parseJson['by'],
     time = parseJson['time'],
     text = parseJson['text'],
     dead = parseJson['dead'] ==1,
     parent = parseJson['parent'],
     kids = jsonDecode(parseJson['kids']),
     url = parseJson['url'],
     score = parseJson['score'],
     title = parseJson['title'],
     descendants = parseJson['descendants'];

    Map<String, dynamic> toMap() {
        return <String, dynamic> {
          "id" : id,
          "type" : type,
          "by" : by,
          "time" : time,
          "text" : text,
          "parent" : parent,
          "url" : url,
          "score" : score,
          "title" : title,
          "descendants" :descendants,
          "deleted" : deleted ? 1 : 0,
          "dead" : dead ? 1 : 0, // if true then 1 else 0
          "kids" : jsonEncode(kids),
        };
    }
}
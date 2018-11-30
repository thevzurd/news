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
     deleted = parseJson['deleted'],
     type = parseJson['type'],
     by = parseJson['by'],
     time = parseJson['time'],
     text = parseJson['text'],
     dead = parseJson['dead'],
     parent = parseJson['parent'],
     kids = parseJson['kids'],
     url = parseJson['url'],
     score = parseJson['score'],
     title = parseJson['title'],
     descendants = parseJson['descendants'];
}
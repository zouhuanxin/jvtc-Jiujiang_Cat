import 'package:data_plugin/bmob/table/bmob_object.dart';

class System_Notice extends BmobObject {
  String title;
  String content;
  String url;
  String level;
  String author;
  var createdAt;

  System_Notice(
      {this.title,
      this.content,
      this.url,
      this.level,
      this.author,
      this.createdAt});

  System_Notice.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'],
        url = json['url'],
        level = json['level'],
        author = json['author'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'url': url,
        'level': level,
        'author': author,
        'createdAt': createdAt,
      };

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }
}

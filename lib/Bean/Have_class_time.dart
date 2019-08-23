
class Have_class_time{
   String title;
   String content;
   String isstart;
   Have_class_time({this.title,this.content,this.isstart});

   Have_class_time.fromJson(Map<String, dynamic> json)
       : title = json['title'],
         content = json['content'],
         isstart = json['isstart'];

   Map<String, dynamic> toJson() =>
       {
         'title': title,
         'content': content,
         'isstart': isstart,
       };
}
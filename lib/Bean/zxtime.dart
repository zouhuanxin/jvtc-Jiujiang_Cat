
class zxtime{
   String url;
   String text;
   String name;
   zxtime({this.url,this.text,this.name});

   zxtime.fromJson(Map<String, dynamic> json)
       : url = json['url'],
         text = json['text'],
         name = json['name'];

   Map<String, dynamic> toJson() =>
       {
         'url': url,
         'text': text,
         'imageurl': name,
       };
}
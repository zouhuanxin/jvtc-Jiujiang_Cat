
class lunbo{
   String url;
   String text;
   String imageurl;
   lunbo({this.url,this.text,this.imageurl});

   lunbo.fromJson(Map<String, dynamic> json)
       : url = json['url'],
         text = json['text'],
         imageurl = json['imageurl'];

   Map<String, dynamic> toJson() =>
       {
         'url': url,
         'text': text,
         'imageurl': imageurl,
       };
}
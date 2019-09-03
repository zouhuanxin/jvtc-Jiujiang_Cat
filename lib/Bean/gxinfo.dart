
class gxinfo{
   String gxversion;
   String text;
   String url;
   String url2;
   String url3;
   gxinfo({this.gxversion,this.text,this.url,this.url2,this.url3});

   gxinfo.fromJson(Map<String, dynamic> json)
       : gxversion = json['gxversion'],
         text = json['text'],
         url3 = json['url3'],
         url2 = json['url2'],
         url = json['url'];

   Map<String, dynamic> toJson() =>
       {
         'gxversion': gxversion,
         'text': text,
         'url3': url3,
         'url2': url2,
         'url': url,
       };
}
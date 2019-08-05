
class gxinfo{
   String gxversion;
   String text;
   String url;
   gxinfo({this.gxversion,this.text,this.url});

   gxinfo.fromJson(Map<String, dynamic> json)
       : gxversion = json['gxversion'],
         text = json['text'],
         url = json['url'];

   Map<String, dynamic> toJson() =>
       {
         'gxversion': gxversion,
         'text': text,
         'url': url,
       };
}
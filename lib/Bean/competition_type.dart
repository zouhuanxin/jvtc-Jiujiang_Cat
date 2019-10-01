
class competition_type{
   String text;
   String introduce;
   String vis;
   String color;
   String imageurl;
   competition_type({this.text,this.introduce,this.color,this.vis,this.imageurl});

   competition_type.fromJson(Map<String, dynamic> json)
       : text = json['text'],
         introduce = json['introduce'],
         color = json['color'],
         imageurl = json['imageurl'],
         vis = json['vis'];

   Map<String, dynamic> toJson() =>
       {
         'text': text,
         'introdce': introduce,
         'color': color,
         'imageurl': imageurl,
         'vis': vis
       };
}
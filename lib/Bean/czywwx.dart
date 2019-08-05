
class czywwx{
   String wx;
   String qq;
   String tel;
   String name;
   String imageurl;
   czywwx({this.wx,this.qq,this.imageurl,this.tel,this.name});

   czywwx.fromJson(Map<String, dynamic> json)
       : wx = json['wx'],
         qq = json['qq'],
         imageurl = json['imageurl'],
         tel = json['tel'],
         name = json['name'];

   Map<String, dynamic> toJson() =>
       {
         'wx': wx,
         'qq': qq,
         'tel': tel,
         'name': name,
         'imageurl': imageurl,
       };
}
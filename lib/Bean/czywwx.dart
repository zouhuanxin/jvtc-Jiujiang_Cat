
import 'package:data_plugin/bmob/table/bmob_object.dart';

class czywwx extends BmobObject{
   String wx;
   String qq;
   String tel;
   String name;
   String imageurl;
   String vis;
   String number;
   var objectId;
   czywwx({this.wx,this.qq,this.imageurl,this.tel,this.name,this.vis,this.number,this.objectId});

   czywwx.fromJson(Map<String, dynamic> json)
       : wx = json['wx'],
         qq = json['qq'],
         imageurl = json['imageurl'],
         tel = json['tel'],
         vis = json['vis'],
         objectId = json['objectId'],
         number = json['number'],
         name = json['name'];

   Map<String, dynamic> toJson() =>
       {
         'wx': wx,
         'qq': qq,
         'tel': tel,
         'name': name,
         'vis': vis,
         'number': number,
         'objectId': objectId,
         'imageurl': imageurl,
       };

   @override
   Map getParams() {
     // TODO: implement getParams
     return toJson();
   }
}
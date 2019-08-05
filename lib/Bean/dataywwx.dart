
import 'package:data_plugin/bmob/table/bmob_object.dart';

class dataywwx extends BmobObject{
   String emergency;
   String type;
   String userdata;
   String contact;
   String content;
   String name;
   String phone;
   var createdAt;
   var objectId;
   dataywwx({this.emergency,this.type,this.userdata,this.contact,this.content,this.name,this.phone});

   dataywwx.fromJson(Map<String, dynamic> json)
       : emergency = json['emergency'],
         type = json['type'],
         userdata = json['userdata'],
         contact = json['contact'],
         content = json['content'],
         name = json['name'],
         phone = json['phone'],
         createdAt = json['createdAt'],
         objectId = json['objectId'];

   Map<String, dynamic> toJson() =>
       {
         'emergency': emergency,
         'type': type,
         'userdata': userdata,
         'contact': contact,
         'content': content,
         'phone': phone,
         'name': name,
         'createdAt': createdAt,
         'objectId': objectId,
       };

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
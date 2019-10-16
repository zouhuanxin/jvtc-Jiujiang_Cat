
import 'package:data_plugin/bmob/table/bmob_object.dart';

class config extends BmobObject{
   String key;
   String value;
   String value2;
   var createdAt;
   var objectId;
   config({this.key,this.value,this.value2,this.createdAt,this.objectId});

   config.fromJson(Map<String, dynamic> json)
       : key = json['key'],
         value = json['value'],
         value2 = json['value2'],
         createdAt = json['createdAt'],
         objectId = json['objectId'];

   Map<String, dynamic> toJson() =>
       {
         'key': key,
         'value': value,
         'value2': value2,
         'createdAt': createdAt,
         'objectId': objectId
       };

  @override
  Map getParams() {
    return toJson();
  }
}
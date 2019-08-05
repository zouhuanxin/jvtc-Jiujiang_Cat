import 'package:data_plugin/bmob/table/bmob_object.dart';

import 'learn_assistant02.dart';
class learn_assistant extends BmobObject{
   String objectId;
   String time_phone;
   String phone;
   String time;
   dynamic learn02;
   learn_assistant({this.time,this.learn02,this.phone,this.time_phone});

   learn_assistant.fromJson(Map<String, dynamic> json)
       : time = json['time'],
         phone = json['phone'],
         time_phone = json['time_phone'],
         learn02 = json['learn02'],
         objectId = json['objectId'];

   Map<String, dynamic> toJson() =>
       {
         'time': time,
         'phone': phone,
         'time_phone': time_phone,
         'objectId': objectId,
         'learn02': learn02,
       };

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
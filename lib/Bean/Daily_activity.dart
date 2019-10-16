
import 'package:data_plugin/bmob/table/bmob_object.dart';

class Daily_activity extends BmobObject{
   String date;
   String number;
   var createdAt;
   var objectId;
   Daily_activity({this.date,this.number,this.createdAt,this.objectId});

   Daily_activity.fromJson(Map<String, dynamic> json)
       : date = json['date'],
         number = json['number'],
         createdAt = json['createdAt'],
         objectId = json['objectId'];

   Map<String, dynamic> toJson() =>
       {
         'date': date,
         'number': number,
         'createdAt': createdAt,
         'objectId': objectId
       };

  @override
  Map getParams() {
    return toJson();
  }
}
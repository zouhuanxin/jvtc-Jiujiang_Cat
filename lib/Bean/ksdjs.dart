
import 'package:data_plugin/bmob/table/bmob_object.dart';

class ksdjs extends BmobObject{
   String day;
   String proname;
   String time;
   String studentid;
   String userdata;
   String name;
   String phone;
   String content;
   var createdAt;
   var objectId;
   ksdjs({this.day,this.proname,this.time,this.studentid,this.userdata,this.name,this.phone,this.content});

   ksdjs.fromJson(Map<String, dynamic> json)
       : day = json['day'],
         proname = json['proname'],
         time = json['time'],
         studentid = json['studentid'],
         userdata = json['userdata'],
         name = json['name'],
         phone = json['phone'],
         content = json['content'],
         createdAt = json['createdAt'],
         objectId = json['objectId'];

   Map<String, dynamic> toJson() =>
       {
         'day': day,
         'proname': proname,
         'time': time,
         'studentid': studentid,
         'userdata': userdata,
         'name': name,
         'phone': phone,
         'content': content,
         'createdAt': createdAt,
         'objectId': objectId,
       };

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
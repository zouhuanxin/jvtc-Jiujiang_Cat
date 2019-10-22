
import 'package:data_plugin/bmob/table/bmob_object.dart';

class Course_Sgin extends BmobObject{
   String teachid;
   String teachname;
   String teachtel;
   String status;
   String sginpass;
   String f_sgin;
   String s_sgin;
   String studata;
   String course_name;
   String sgin_status;
   var createdAt;
   var objectId;
   Course_Sgin({this.teachid,this.teachname,this.teachtel,this.status,this.sginpass,this.f_sgin,this.s_sgin,this.studata,this.course_name,this.sgin_status});

   Course_Sgin.fromJson(Map<String, dynamic> json)
       : teachid = json['teachid'],
         teachname = json['teachname'],
         teachtel = json['teachtel'],
         status = json['status'],
         sginpass = json['sginpass'],
         f_sgin = json['f_sgin'],
         s_sgin = json['s_sgin'],
         studata = json['studata'],
         course_name = json['course_name'],
         sgin_status = json['sgin_status'],
         createdAt = json['createdAt'],
         objectId = json['objectId'];

   Map<String, dynamic> toJson() =>
       {
         'teachid': teachid,
         'teachname': teachname,
         'teachtel': teachtel,
         'status': status,
         'sginpass': sginpass,
         'f_sgin': f_sgin,
         's_sgin': s_sgin,
         'studata': studata,
         'course_name': course_name,
         'sgin_status': sgin_status,
         'createdAt': createdAt,
         'objectId': objectId,
       };

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
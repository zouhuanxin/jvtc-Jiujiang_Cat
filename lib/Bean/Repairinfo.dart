
import 'package:data_plugin/bmob/table/bmob_object.dart';

class Repairinfo extends BmobObject{
   String helpphone;
   String behelpphone;
   String content;
   Repairinfo({this.helpphone,this.behelpphone,this.content});

   Repairinfo.fromJson(Map<String, dynamic> json)
       : helpphone = json['helpphone'],
         behelpphone = json['behelpphone'],
         content = json['content'];

   Map<String, dynamic> toJson() =>
       {
         'helpphone': helpphone,
         'behelpphone': behelpphone,
         'content': content,
       };

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
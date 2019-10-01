
import 'package:data_plugin/bmob/table/bmob_object.dart';

class competition extends  BmobObject{
   String type;
   String introduce;
   String number;
   String numberperson;
   String url;
   String logo;
   String phone;
   var objectId;
   competition({this.type,this.introduce,this.number,this.numberperson,this.url,this.logo,this.phone,this.objectId});

   competition.fromJson(Map<String, dynamic> json)
       : type = json['type'],
         introduce = json['introduce'],
         number = json['number'],
         numberperson = json['numberperson'],
         url = json['url'],
         phone = json['phone'],
         objectId = json['objectId'],
         logo = json['logo'];

   Map<String, dynamic> toJson() =>
       {
         'type': type,
         'introduce': introduce,
         'number': number,
         'numberperson': numberperson,
         'url': url,
         'phone': phone,
         'objectId': objectId,
         'logo': logo
       };

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
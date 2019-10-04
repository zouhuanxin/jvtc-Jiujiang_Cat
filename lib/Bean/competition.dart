
import 'package:data_plugin/bmob/table/bmob_object.dart';

class competition extends  BmobObject{
   String type;
   String introduce;
   String number;
   String numberperson;
   String url;
   String logo;  //image1
   String image2;
   String image3;
   String phone;
   var objectId;
   competition({this.type,this.introduce,this.number,this.numberperson,this.url,this.logo,this.phone,this.objectId,this.image2,this.image3});

   competition.fromJson(Map<String, dynamic> json)
       : type = json['type'],
         introduce = json['introduce'],
         number = json['number'],
         numberperson = json['numberperson'],
         url = json['url'],
         phone = json['phone'],
         objectId = json['objectId'],
         image2 = json['image2'],
         image3 = json['image3'],
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
         'image2': image2,
         'image3': image3,
         'logo': logo
       };

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
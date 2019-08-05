
import 'dart:io';

import 'package:data_plugin/bmob/table/bmob_object.dart';

class QTuser extends BmobObject{
   String username;
   String phone;
   String password;
   String imagebase64;
   File image;
   QTuser({this.username,this.phone,this.password,this.imagebase64,this.image});

   QTuser.fromJson(Map<String, dynamic> json)
       : username = json['username'],
         phone = json['phone'],
         password = json['password'],
         imagebase64 = json['imagebase64'],
         image = json['image'];

   Map<String, dynamic> toJson() =>
       {
         'username': username,
         'phone': phone,
         'password': password,
         'imagebase64': imagebase64,
         'image': image,
       };

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
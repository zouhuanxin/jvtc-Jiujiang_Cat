
import 'dart:io';
import 'package:flutter_app01/my/my.dart';
import 'package:data_plugin/bmob/table/bmob_object.dart';

class QTuser extends BmobObject{
   String username;
   String phone;
   String password;
   String imagebase64;
   File image;
   var objectId;
   String studentid;
   String notice;
   QTuser({this.username,this.phone,this.password,this.imagebase64,this.image,this.studentid,this.notice});

   QTuser.fromJson(Map<String, dynamic> json)
       : username = json['username'],
         phone = json['phone'],
         password = json['password'],
         imagebase64 = json['imagebase64'],
         objectId = json['objectId'],
         image = json['image'],
         studentid = json['studentid'],
         notice = json['notice'];

   Map<String, dynamic> toJson() =>
       {
         'username': username,
         'phone': phone,
         'password': password,
         'imagebase64': imagebase64,
         'objectId': objectId,
         'image': image,
         'studentid': studentid,
         'notice': notice,
       };

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }
}
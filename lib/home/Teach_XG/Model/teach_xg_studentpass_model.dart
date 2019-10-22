

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:flutter_app01/home/JZ_association/Collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_xg_studentpass_model{

  Future<String> TeacherReSetpass(SharedPreferences prefs,String studentid)async{
    String res=await Teach_HttpUtil.TeacherReSetpass('', prefs.getString('teach_xgtoken'), studentid);
    print(res);
    Map<Object,dynamic>map=json.decode(res);
    if(map['code']==0){
      Map<Object,dynamic>map2=json.decode(json.encode(map['data']));
      return map2['msg'];
    }else{
      return null;
    }
  }

}


import 'dart:convert';

import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_xg_login_model{
  Future<Map<String, dynamic>> xg_login(username,password,SharedPreferences prefs)async{
    String xg_res=await HttpUtil.xglogin('login', username, password);
    Map<String, dynamic> xg_maptemp = json.decode(xg_res);
    if(xg_maptemp['code'].toString().trim()=='0'){
      Map<String, dynamic> resmap=await search_teach(xg_maptemp['token'].toString(),prefs);
      if(resmap!=null){
        prefs.setString('teach_xgtoken', xg_maptemp['token'].toString());
        prefs.setString('teach_xgstudentid', username);
        prefs.setString('teach_xgpassword', password);
      }
      return resmap;
    }else{
      return null;
    }
  }

  //查询教师接口
  Future<Map<String, dynamic>>  search_teach(token,prefs) async{
    String res=await Teach_HttpUtil.teacher_info('',token);
  //  print('res:'+res);
    Map<String, dynamic> maptemp = json.decode(res);
    if(maptemp['code'].toString().trim()=='0') {
      Map<String, dynamic> tempres = json.decode(json.encode(maptemp['data']));
      //print(tempres['basicsinfo']);
      prefs.setString('teach_xgdata', json.encode(tempres['basicsinfo']));
      Map<String, dynamic> temp = json.decode(json.encode(tempres['basicsinfo']));
      return temp;
    }else{
      return null;
    }
  }

}
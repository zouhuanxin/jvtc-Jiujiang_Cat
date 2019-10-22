

import 'dart:convert';

import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_jw_login_model{
  Future<Map<String, dynamic>> jw_login(username,password,SharedPreferences prefs)async{
    String jw_res=await HttpUtil.jwlogin('jwlogin', username, password);
    Map<String, dynamic> jw_maptemp = json.decode(jw_res);
    print(jw_res);
    if(jw_maptemp['code'].toString().trim()=='0'){
      Map<String, dynamic> resmap=await search_teach(jw_maptemp['cookie'].toString(),prefs);
      if(resmap!=null){
        prefs.setString('jwcookie', jw_maptemp['cookie'].toString());
        prefs.setString('teach_jwstudentid', username);
        prefs.setString('teach_jwpassword', password);
      }
      return resmap;
    }else{
      return null;
    }
  }

  //查询教师接口
  Future<Map<String, dynamic>>  search_teach(cookie,prefs) async{
    String res=await Teach_HttpUtil.teach_teach_info('teach_teach_info',cookie);
    print('查询教师接口'+res);
    Map<String, dynamic> maptemp = json.decode(res);
    if(maptemp['code'].toString().trim()=='0') {
      prefs.setString('teach_data', maptemp['data']);
      Map<String, dynamic> tempres = json.decode(maptemp['data']);
      return tempres;
    }else{
      return null;
    }
  }

}
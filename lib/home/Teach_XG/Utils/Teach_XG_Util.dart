
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_login_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Teach_XG_Util{

  //自动登陆方法
  static void auto_login() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    if(prefs.getString('teach_xgstudentid')==null||prefs.getString('teach_xgpassword')==null){
      return;
    }
    String xg_res=await HttpUtil.xglogin('login', prefs.getString('teach_xgstudentid'), prefs.getString('teach_xgpassword'));
    Map<String, dynamic> xg_maptemp = json.decode(xg_res);
    if(xg_maptemp['code'].toString().trim()=='0'){
      prefs.setString('teach_xgtoken', xg_maptemp['token'].toString());
      Util.showTaost('自动登陆成功', Toast.LENGTH_SHORT, Colors.blue);
    }else{
      Util.showTaost('自动登陆失败', Toast.LENGTH_SHORT, Colors.red);
    }
  }

}
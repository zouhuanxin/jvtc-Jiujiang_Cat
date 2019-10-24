
import 'dart:async';
import 'dart:convert';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/common/Loading_Toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util{

  static void showTaost(msg, type, color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Future<int> auto_login() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String jw_res;
    //如果不为空并且学号为五位数则是老师账号则调用教师登陆
    //为了分辨教师学生使用前必须绑定学号 否则默认为学生使用
    if(now_studentid!=null&&now_studentid.length==5){
       jw_res=await HttpUtil.jwlogin('jwlogin', prefs.getString('teach_jwstudentid'), prefs.getString('teach_jwpassword'));
    }else{
      jw_res=await HttpUtil.jwlogin('jwlogin', prefs.getString('learn_teach_student_id'), prefs.getString('teach_password'));
    }
    Map<String, dynamic> jw_maptemp = json.decode(jw_res);
    if(jw_maptemp['code'].toString().trim()=='0'){
      prefs.setString('jwcookie', jw_maptemp['cookie'].toString());
      Util.showTaost('自动登陆成功', Toast.LENGTH_SHORT, Colors.blue);
      return 0;
    }else{
      Util.showTaost('自动登陆失败', Toast.LENGTH_SHORT, Colors.black38);
      return -1;
    }
  }

  static Future<int> auto_login2() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String xg_res;
    //如果不为空并且学号为五位数则是老师账号则调用教师登陆
    //为了分辨教师学生使用前必须绑定学号 否则默认为学生使用
    if(now_studentid!=null&&now_studentid.length==5){
      xg_res=await HttpUtil.xglogin('login', prefs.getString('teach_xgstudentid'), prefs.getString('teach_xgpassword'));
    }else{
      xg_res=await  HttpUtil.xglogin('login', prefs.getString('learn_teach_student_id'), prefs.getString('learn_password'));
    }
    Map<String, dynamic> xg_maptemp = json.decode(xg_res);
    if(xg_maptemp['code'].toString().trim()=='0'){
      prefs.setString('teach_xgtoken', xg_maptemp['token'].toString());
      Util.showTaost('自动登陆成功', Toast.LENGTH_SHORT, Colors.blue);
      return 0;
    }else{
      Util.showTaost('自动登陆失败', Toast.LENGTH_SHORT, Colors.black38);
      return -1;
    }
  }

  static Future<int> auto_login3() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String jw_res;
    if(now_studentid!=null&&now_studentid.length==5){
      jw_res=await HttpUtil.jwlogin('jwlogin', now_studentid.trim(), prefs.getString('teach_jwpassword'));
    }else{
      jw_res=await HttpUtil.jwlogin('jwlogin', now_studentid.trim(), prefs.getString('teach_password').trim());
    }
    Map<String, dynamic> jw_maptemp = json.decode(jw_res);
    if(jw_maptemp['code'].toString().trim()=='0'){
      prefs.setString('jwcookie', jw_maptemp['cookie'].toString());
      Util.showTaost('自动登陆成功', Toast.LENGTH_SHORT, Colors.blue);
      return 0;
    }else{
      //Util.showTaost('自动登陆失败', Toast.LENGTH_SHORT, Colors.black38);
      return -1;
    }
  }

  //跳转方法
  static void jump(BuildContext context,object){
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => object));
  }

  //装逼加载界面
  static void open_zbui(BuildContext context){
    Loading_Toast lt;
    Timer time;
    lt=Loading_Toast(context,'安全检查中...');
    lt.Open_Loading();
    time=new Timer.periodic(new Duration(seconds: 1), (timer) {
      time.cancel();
      lt.Upload_data('检查通过...');
      time=new Timer.periodic(new Duration(milliseconds: 500), (timer) {
        time.cancel();
        lt.Upload_data('系统模式启动...');
        time=new Timer.periodic(new Duration(milliseconds: 500), (timer) {
          time.cancel();
          lt.Upload_data('启动完毕，欢迎使用。');
          time=new Timer.periodic(new Duration(milliseconds: 500), (timer) {
            lt.Close_Loading();
            time.cancel();
          });
        });
      });
    });
  }

}
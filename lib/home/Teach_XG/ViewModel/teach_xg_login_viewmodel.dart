

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/common/Loading_Toast.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_login_model.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_login_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_xg_login_viewmodel with ChangeNotifier{
  String username='';
  String login_state='当前未登录';
  String password;
  bool pass_vis=true;
  teach_xg_login_model txlm;
  SharedPreferences prefs;

  teach_xg_login_viewmodel(teach_xg_login_model txlm){
    this.txlm=txlm;
    loading();
  }

  void loading() async{
    prefs=await SharedPreferences.getInstance();
    if(prefs.getString('teach_xgstudentid')!=null) username=prefs.getString('teach_xgstudentid');
    if(prefs.getString('teach_xgpassword')!=null) password=prefs.getString('teach_xgpassword');
    if(prefs.getString('teach_xgdata')!=null) {
      Map<String, dynamic> maptemp = json.decode(prefs.getString('teach_xgdata'));
      this.login_state=maptemp['UserName'];
    }
    notifyListeners();
  }

  set_username(T){
   username=T;
   notifyListeners();
  }

  set_password(T){
    password=T;
    notifyListeners();
  }

  set_pass_vis(){
    pass_vis=!pass_vis;
    notifyListeners();
  }

  void login(BuildContext context) async{
    var emailReg = RegExp(r"(([0-9])){6}$");
    if (emailReg.hasMatch(username)) {
      Util.showTaost('请输入正确的学工号', Toast.LENGTH_SHORT, Colors.red);
      return;
    }
    Loading_Toast lt=Loading_Toast(context,'登陆中...');
    lt.Open_Loading();
    //登陆学工平台
    Map<String, dynamic> maptemp=await this.txlm.xg_login(username, password, prefs);
    lt.Close_Loading();
    if(maptemp!=null){
      this.login_state=maptemp['UserName'];
      notifyListeners();
      Util.showTaost('登陆成功', Toast.LENGTH_SHORT, Colors.blue);
      Navigator.pop(context);
    }else{
      Util.showTaost('登陆失败', Toast.LENGTH_SHORT, Colors.red);
    }
  }

}
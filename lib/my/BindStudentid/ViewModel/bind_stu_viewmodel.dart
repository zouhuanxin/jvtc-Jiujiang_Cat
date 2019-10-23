
import 'dart:convert';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/common/Loading_Toast.dart';
import 'package:flutter_app01/my/BindStudentid/Model/bind_stu_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bind_stu_viewmodel with ChangeNotifier{
  String studentid;
  String password;
  String prompt_message='';
  bind_stu_model bsm;
  SharedPreferences sharedPreferences;
  BuildContext context;

  bind_stu_viewmodel(bind_stu_model bsm,BuildContext context){
    this.bsm=bsm;
    this.context=context;
    loading();
  }

  //获取是否登陆学教平台如果当前有学号记录则取出
  void loading() async{
    sharedPreferences=await SharedPreferences.getInstance();
    try{
      studentid=now_studentid;
      QTuser qTuser=await bsm.search_stu();
      if(qTuser.studentid==null||qTuser.studentid==''){
        prompt_message='你暂未绑定过学号';
      }else{
        prompt_message='你绑定的学号为：${qTuser.studentid}';
      }
    }catch(e){}
    notifyListeners();
  }

  void set_studentid_input(T){
    studentid=T;
    notifyListeners();
  }

  void set_password_input(T){
    password=T;
    notifyListeners();
  }

  void Submit() async{
    Loading_Toast lt=Loading_Toast(context,'登陆验证中...');
    lt.Open_Loading();
    if(studentid.length>4){
      //先验证学号与密码是否正确
      String xg_res=await HttpUtil.xglogin('login', studentid, password);
      Map<String, dynamic> xg_maptemp = json.decode(xg_res);
      if(xg_maptemp['code'].toString().trim()=='0'){
        //提交
        int res=await bsm.updateSingle(studentid);
        if(res==0){
          Navigator.pop(context);
        }
        heduishefen();
        loading();
        lt.Close_Loading();
      }else{
        Util.showTaost('密码错误', Toast.LENGTH_SHORT, Colors.red);
      }
    }else{
      Util.showTaost('请输入学号', Toast.LENGTH_SHORT, Colors.red);
    }
  }

  //小猫手身份验证
  void heduishefen() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    BmobQuery<QTuser> query = BmobQuery();
    query.addWhereEqualTo("phone",await sharedPreferences.getString('phone'));
    query.queryObjects().then((data) {
      List<QTuser> templist = data.map((i) => QTuser.fromJson(i)).toList();
      username=templist[0].username;
      phone=templist[0].phone;
      objectid=templist[0].objectId;
      now_studentid=templist[0].studentid;
      now_login_image_base64 = templist[0].imagebase64;
      sharedPreferences.setString('username', username);
      sharedPreferences.setString('phone', phone);
      sharedPreferences.setString('objectid', objectid);
      sharedPreferences.setString('now_studentid', now_studentid);
      sharedPreferences.setString('now_login_image_base64', templist[0].imagebase64);
      notifyListeners();
    }).catchError((e) {});
  }
}
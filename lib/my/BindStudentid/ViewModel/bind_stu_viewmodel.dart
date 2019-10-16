
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/my/BindStudentid/Model/bind_stu_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bind_stu_viewmodel with ChangeNotifier{
  String studentid;
  String password;
  String prompt_message='';
  bind_stu_model bsm;
  SharedPreferences sharedPreferences;

  bind_stu_viewmodel(bind_stu_model bsm){
    this.bsm=bsm;
    loading();
  }

  //获取是否登陆学教平台如果当前有学号记录则取出
  void loading() async{
    sharedPreferences=await SharedPreferences.getInstance();
    if(sharedPreferences.getString('learn_teach_student_id')!=null){
      studentid=sharedPreferences.getString('learn_teach_student_id');
    }
    QTuser qTuser=await bsm.search_stu();
    if(qTuser.studentid==null){
      prompt_message='你暂未绑定过学号';
    }else{
      prompt_message='你绑定的学号为：${qTuser.studentid}';
    }
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
    if(studentid.length>4){
      //先验证学号与密码是否正确
      String xg_res=await HttpUtil.xglogin('login', studentid, password);
      Map<String, dynamic> xg_maptemp = json.decode(xg_res);
      if(xg_maptemp['code'].toString().trim()=='0'){
        //提交
        await bsm.updateSingle(studentid);
        loading();
      }else{
        Util.showTaost('密码错误', Toast.LENGTH_SHORT, Colors.red);
      }
    }else{
      Util.showTaost('请输入学号', Toast.LENGTH_SHORT, Colors.red);
    }
  }

}
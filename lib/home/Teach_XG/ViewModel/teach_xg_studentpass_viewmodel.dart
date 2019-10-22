

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_main_model.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_studentinfo_view.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_main_model.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_studentpass_model.dart';
import 'package:flutter_app01/home/Teach_XG/View/teach_xg_studentpass_view.dart';
import 'package:flutter_app01/home/Teach_XG/View/teach_xg_teachinfo_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_xg_studentpass_viewmodel with ChangeNotifier{
  String username;
  teach_xg_studentpass_model txsm;
  SharedPreferences prefs;

  teach_xg_studentpass_viewmodel(teach_xg_studentpass_model txsm){
    this.txsm=txsm;
    loading();
  }

  void loading () async{
    prefs = await SharedPreferences.getInstance();
  }

  set_username(T){
    this.username=T;
    notifyListeners();
  }
  
  void TeacherReSetpass() async{
    if(username==null){
      Util.showTaost('请输入学号', Toast.LENGTH_SHORT, Colors.red);
      return;
    }
    String res=await this.txsm.TeacherReSetpass(prefs, username);
    if(res!=null){
      Util.showTaost(res, Toast.LENGTH_SHORT, Colors.blue);
    }else{
      Util.showTaost('重置失败', Toast.LENGTH_SHORT, Colors.red);
    }
  }

}
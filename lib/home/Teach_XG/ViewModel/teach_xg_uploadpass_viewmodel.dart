

import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/common/Loading_Toast.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_uploadpass_model.dart';
import 'package:flutter_app01/home/Teach_Student_UploadPass/Model/teach_student_uploadpass_model.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_uploadpass_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_xg_uploadpass_viewmodel with ChangeNotifier {
  teach_xg_uploadpass_model txum;
  String oldpassword, password1, password2;
  bool vis1=true,vis2=true,vis3=true;
  SharedPreferences prefs;
  BuildContext context;

  teach_xg_uploadpass_viewmodel(teach_xg_uploadpass_model txum,BuildContext context){
    this.txum=txum;
    this.context=context;
    loading();
  }

  void loading() async{
    prefs=await SharedPreferences.getInstance();
  }

  set_data(T1,T2){
    switch(T1){
      case 'oldpassword':
        oldpassword=T2;
        break;
      case 'password1':
        password1=T2;
        break;
      case 'password2':
        password2=T2;
        break;
      case 'vis1':
        vis1=!vis1;
        break;
      case 'vis2':
        vis2=!vis2;
        break;
      case 'vis3':
        vis3=!vis3;
        break;
    }
    notifyListeners();
  }

  void uploadpss() async{
    if(oldpassword==null&&password1==null&&password2==null){
      Util.showTaost('不能为空', Toast.LENGTH_SHORT, Colors.red);
      return;
    }
    if(password1!=password2){
      Util.showTaost('俩次密码输入不一致', Toast.LENGTH_SHORT, Colors.red);
      return;
    }
    String res1=await this.txum.xg_uploadpss(prefs, oldpassword, password1, password2);
    if(res1!=null){
      Util.showTaost(res1, Toast.LENGTH_SHORT, Colors.blue);
      Navigator.pop(context);
    }else{
      Util.showTaost(res1, Toast.LENGTH_SHORT, Colors.red);
    }
  }

}
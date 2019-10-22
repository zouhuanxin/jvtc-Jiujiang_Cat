

import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/common/Loading_Toast.dart';
import 'package:flutter_app01/home/Teach_Student_UploadPass/Model/teach_student_uploadpass_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_student_uploadpass_viewmodel with ChangeNotifier {
  teach_student_uploadpass_model tsum;
  String oldpassword, password1, password2;
  bool vis1=true,vis2=true,vis3=true;
  SharedPreferences prefs;
  BuildContext context;

  teach_student_uploadpass_viewmodel(teach_student_uploadpass_model tsum,BuildContext context){
    this.tsum=tsum;
    this.context=context;
    loading();
  }

  void loading() async{
    prefs=await SharedPreferences.getInstance();
    Loading_Toast lt=Loading_Toast(context, '检查当前账号状态...');
    lt.Open_Loading();
    int index1= await Util.auto_login();
    int index2= await Util.auto_login2();
    lt.Close_Loading();
    if(index1==0&&index2==0){
      //通过
    }else{
      lt=Loading_Toast(context, '请先前往教务系统与学工平台登陆...');
      lt.Open_Loading();
    }
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
    String res1=await this.tsum.jw_uploadpss(prefs, oldpassword, password1, password2);
    if(res1!=null){
      String res2=await this.tsum.xg_uploadpss(prefs, oldpassword, password1, password2);
      if(res2!=null){
        Util.showTaost('密码修改成功', Toast.LENGTH_SHORT, Colors.blue);
        Navigator.pop(context);
      }else{
        //如果学工平台密码修改则把教务系统密码改回去
        await this.tsum.jw_uploadpss(prefs, password1, oldpassword, oldpassword);
        Util.showTaost(res2, Toast.LENGTH_SHORT, Colors.red);
      }
    }else{
      Util.showTaost(res1, Toast.LENGTH_SHORT, Colors.red);
    }
  }

}
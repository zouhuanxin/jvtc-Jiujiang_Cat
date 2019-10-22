
import 'dart:convert';

import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_xg_uploadpass_model {

  Future<String> xg_uploadpss(SharedPreferences prefs,oldpassword, password1, password2) async{
    String res=await Teach_HttpUtil.xg_uploadpas('', prefs.getString('teach_xgtoken'), oldpassword, password1, password2);
    Map<Object,dynamic>map=json.decode(res);
    print(res);
    if(map['code']==0){
      return map['message'];
    }else{
      return null;
    }
  }

}
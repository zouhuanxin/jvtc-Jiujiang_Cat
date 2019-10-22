
import 'dart:convert';

import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_jw_uploadpass_model {
  
  Future<String> jw_uploadpss(SharedPreferences prefs,oldpassword, password1, password2) async{
    String res=await Teach_HttpUtil.jw_uploadpas('teach_uploadpass_info', prefs.getString('jwcookie'), oldpassword, password1, password2);
    Map<Object,dynamic>map=json.decode(res);
    print(res);
    if(map['code']=='0'){
      return map['data'];
    }else{
      return null;
    }
  }

}
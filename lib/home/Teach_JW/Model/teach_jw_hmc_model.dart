

import 'dart:convert';

import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_jw_hmc_model{

  Future<List> teach_hmc_info1(SharedPreferences prefs,jx0404id) async{
    String res=await Teach_HttpUtil.teach_hmc_info('teach_hmc_info', prefs.getString('jwcookie'), jx0404id);
    Map<Object,dynamic>map=json.decode(res);
    if(map['code']=='0'){
      List list=json.decode(map['data']);
      return list;
    }else{
      return null;
    }
  }
}
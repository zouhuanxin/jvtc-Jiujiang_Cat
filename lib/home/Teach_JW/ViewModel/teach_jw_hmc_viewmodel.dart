

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_hmc_model.dart';
import 'package:flutter_app01/home/Teach_JW/Utils/Teach_JW_Util.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_hmc_details_view.dart';
import 'package:flutter_app01/home/Teach_JW/common_ui/hmc_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_jw_hmc_viewmodel with ChangeNotifier{
  teach_jw_hmc_model tjhm;
  List<Widget>list_ui1=[];
  SharedPreferences prefs;
  BuildContext context;

  teach_jw_hmc_viewmodel(teach_jw_hmc_model tjhm,BuildContext context){
    this.tjhm=tjhm;
    this.context=context;
    _loading();
  }

  void _loading() async{
    prefs=await SharedPreferences.getInstance();
    if(prefs.getString('teach_data')!=null){
      String res=prefs.getString('teach_data');
      Map<Object,dynamic>map=json.decode(res);
      List list=json.decode(json.encode(map['data']));
      for(int i=0;i<list.length;i++){
        Map<Object,dynamic>map2=json.decode(json.encode(list[i]));
        String temp=map2['hmc'].toString().split('(')[1].split(',')[0];
        list_ui1.add(hmc_ui.Card1(map2['bj'], map2['kc'], temp.substring(1,temp.length-1),this));
      }
      notifyListeners();
    }
  }

  void teach_hmc_info1(jx0404id) async{
    List list =await this.tjhm.teach_hmc_info1(prefs, jx0404id);
    if(list!=null){
      Teach_JW_Util.jump(context, new teach_jw_hmc_details_view(list: list,));
    }else{
      Util.showTaost('访问失败', Toast.LENGTH_SHORT, Colors.red);
    }
  }

}
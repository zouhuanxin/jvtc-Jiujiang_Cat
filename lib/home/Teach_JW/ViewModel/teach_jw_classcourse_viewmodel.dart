

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/common/Loading_Toast.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_classcourse_model.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_studentinfo_model.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_teachcourse_model.dart';
import 'package:flutter_app01/home/Teach_JW/Utils/Teach_JW_Util.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_course_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_jw_classcourse_viewmodel with ChangeNotifier{
  String xnxqh='',skyx='',xqid='',jzwid='',skjs='',zc1='',zc2='',skxq1='',skxq2='',jc1='',jc2='';
  teach_jw_classcourse_model tjcm;
  SharedPreferences prefs;
  BuildContext context;

  teach_jw_classcourse_viewmodel(teach_jw_classcourse_model tjcm,BuildContext context){
    this.tjcm=tjcm;
    this.context=context;
    loading();
  }

  set_drop_data(T1,T2){
    switch(T1){
      case 'xnxqh':
        xnxqh=T2;
        break;
      case 'skyx':
        skyx=T2;
        break;
      case 'xqid':
        xqid=T2;
        break;
      case 'jzwid':
        jzwid=T2;
        break;
      case 'skjs':
        skjs=T2;
        break;
      case 'zc1':
        zc1=T2;
        break;
      case 'zc2':
        zc2=T2;
        break;
      case 'skxq1':
        skxq1=T2;
        break;
      case 'skxq2':
        skxq2=T2;
        break;
      case 'jc1':
        jc1=T2;
        break;
      case 'jc2':
        jc2=T2;
        break;
    }
    notifyListeners();
  }

  List<DropdownMenuItem> getListData1(){
    return this.tjcm.getListData();
  }

  List<DropdownMenuItem> getListData2(){
    return this.tjcm.getListData2();
  }

  List<DropdownMenuItem> getListData3(){
    return this.tjcm.getListData3();
  }

  List<DropdownMenuItem> getListData4(){
    return this.tjcm.getListData4();
  }

  void search() async{
    List list=await this.tjcm.search(prefs, xnxqh, skyx,xqid,jzwid,  skjs, zc1, zc2, skxq1, skxq2, jc1, jc2);
   // print(list);
    Loading_Toast lt=Loading_Toast(context, '查找中...');
    lt.Open_Loading();
    if(list==null||list.length<10){
      Util.showTaost('查找失败', Toast.LENGTH_SHORT, Colors.red);
      lt.Close_Loading();
      return;
    }
    lt.Close_Loading();
    Teach_JW_Util.jump(context, new teach_jw_course_view(list: list,));
  }

  void loading() async{
    prefs=await SharedPreferences.getInstance();
  }


}
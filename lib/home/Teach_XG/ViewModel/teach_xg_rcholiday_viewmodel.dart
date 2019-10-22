

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_main_model.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_studentinfo_view.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_main_model.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_rcholiday_model.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_studentpass_model.dart';
import 'package:flutter_app01/home/Teach_XG/View/teach_xg_studentpass_view.dart';
import 'package:flutter_app01/home/Teach_XG/View/teach_xg_teachinfo_view.dart';
import 'package:flutter_app01/home/Teach_XG/common_ui/custom_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_xg_rcholiday_viewmodel with ChangeNotifier{
  teach_xg_rcholiday_model txrm;
  SharedPreferences prefs;
  List<DropdownMenuItem> items1;
  List<DropdownMenuItem> items2;
  String TermNo,Status;
  //返回ui结果集合
  List<Widget> ui_list=[];

  teach_xg_rcholiday_viewmodel(teach_xg_rcholiday_model txrm){
    this.txrm=txrm;
    loading();
  }

  void loading () async{
   prefs = await SharedPreferences.getInstance();
   items1= this.txrm.getListData();
   items2= this.txrm.getListData2();
   notifyListeners();
  }

  set_TermNo(T){
    TermNo=T;
    notifyListeners();
  }

  set_Status(T){
    Status=T;
    notifyListeners();
  }

  void search_data() async{
    if(TermNo==null||Status==null){
      Util.showTaost('请选择', Toast.LENGTH_SHORT, Colors.red);
      return;
    }
    List list=await this.txrm.FDYAllLeaveExam(prefs, TermNo, Status);
    if(list==null){
      Util.showTaost('查询失败', Toast.LENGTH_SHORT, Colors.red);
      return;
    }
    ui_list.clear();
    for(int i=0;i<list.length;i++){
      Map<Object,dynamic>map=json.decode(json.encode(list[i]));
      ui_list.add(custom_ui.card1(map['name'],map['stu_id'],map['sex'],map['date'],map['x_date'],map['reason'],map['location'],map['class']
          ,map['period'],map['stat'],map['id'],this));
    }
    notifyListeners();
  }

  void FDYAllLeaveExam_Edit(id,type) async{
    String res=await this.txrm.FDYAllLeaveExam_Edit(prefs, id, type);
    if(res!=null){
      Util.showTaost(res, Toast.LENGTH_SHORT, Colors.blue);
      search_data();
    }else{
      Util.showTaost('操作失败', Toast.LENGTH_SHORT, Colors.red);
    }
  }

}
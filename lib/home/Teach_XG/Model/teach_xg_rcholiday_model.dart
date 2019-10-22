

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_xg_rcholiday_model{

  Future<List> FDYAllLeaveExam(SharedPreferences prefs,TermNo,Status) async{
    String res =await Teach_HttpUtil.FDYAllLeaveExam('', prefs.getString('teach_xgtoken'),TermNo,Status);
    Map<Object,dynamic>map=json.decode(res);
    if(map['code']==0){
      Map<Object,dynamic>map2=json.decode(json.encode(map['data']));
      List list=json.decode(json.encode(map2['list']));
      return list;
    }else{
      return null;
    }
  }

  Future<String> FDYAllLeaveExam_Edit(SharedPreferences prefs,id,type) async{
    String res =await Teach_HttpUtil.FDYAllLeaveExam_Edit('', prefs.getString('teach_xgtoken'),id,type);
    Map<Object,dynamic>map=json.decode(res);
    if(map['code']==0){
      return '操作成功';
    }else{
      return null;
    }
  }

  //学期选择
  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem;
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('所有'),
      value: '',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('2019-2020-2'),
      value: '2019-2020-2',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('2019-2020-1'),
      value: '2019-2020-1',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('2018-2019-2'),
      value: '2018-2019-2',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('2018-2019-1'),
      value: '2018-2019-1',
    );
    items.add(dropdownMenuItem);
    return items;
  }

  //状态选择
  List<DropdownMenuItem> getListData2() {
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem;
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('所有'),
      value: '',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('等待班主任审批'),
      value: '1',
    );
    items.add(dropdownMenuItem);
    return items;
  }



}
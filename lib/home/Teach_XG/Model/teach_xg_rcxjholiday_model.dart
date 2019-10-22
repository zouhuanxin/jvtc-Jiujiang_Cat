

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_xg_rcxjholiday_model{

  Future<List> FDYDisAllLeave(SharedPreferences prefs,TermNo) async{
    String res =await Teach_HttpUtil.FDYDisAllLeave('', prefs.getString('teach_xgtoken'),TermNo);
    Map<Object,dynamic>map=json.decode(res);
    if(map['code']==0){
      Map<Object,dynamic>map2=json.decode(json.encode(map['data']));
      List list=json.decode(json.encode(map2['list']));
      print(list);
      return list;
    }else{
      return null;
    }
  }

  Future<String> FDYDisAllLeave2(SharedPreferences prefs,ids) async{
    String res =await Teach_HttpUtil.FDYDisAllLeave2('', prefs.getString('teach_xgtoken'),ids);
    print(res);
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


}
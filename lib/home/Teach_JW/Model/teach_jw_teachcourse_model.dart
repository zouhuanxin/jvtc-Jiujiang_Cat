

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_jw_teachcourse_model{

  //学年学期选择
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

  //上课院系选择
  List<DropdownMenuItem> getListData2() {
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem;
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('所有'),
      value: '',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('教务处'),
      value: '00',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('机械工程学院'),
      value: '01',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('电气工程学院'),
      value: '02',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('船舶工程学院'),
      value: '03',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('汽车工程学院'),
      value: '04',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('信息工程学院'),
      value: '05',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('建筑工程学院'),
      value: '06',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('财会金融学院'),
      value: '07',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('经济管理学院'),
      value: '08',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('继续教育学院'),
      value: '09',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('马克思主义学院'),
      value: '23',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('创新创业学院'),
      value: '24',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('工程训练中心'),
      value: '25',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('学生工作处'),
      value: '27',
    );
    items.add(dropdownMenuItem);
    return items;
  }

  Future<List> search(SharedPreferences prefs,xnxqh, skyx, skjs, zc1, zc2, skxq1, skxq2, jc1, jc2) async{
    String res=await Teach_HttpUtil.teach_teachcourse_info('teach_teachcourse_info', prefs.getString('jwcookie'), xnxqh, skyx, skjs, zc1, zc2, skxq1, skxq2, jc1, jc2);
    Map<Object,dynamic>map=json.decode(res);
    if(map['code']=='0'){
      List list=json.decode(map['data']);
      //print(list);
      return list;
    }else{
      return null;
    }
  }
}
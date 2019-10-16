
import 'package:flutter/material.dart';

class teach_create_class_model{

  //班级学院选择框数据
  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem;
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('信息工程学院'),
      value: '信息工程学院',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('电气工程学院'),
      value: '电气工程学院',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('财会金融学院'),
      value: '财会金融学院',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('船舶工程学院'),
      value: '船舶工程学院',
    );
    items.add(dropdownMenuItem);
    return items;
  }

}
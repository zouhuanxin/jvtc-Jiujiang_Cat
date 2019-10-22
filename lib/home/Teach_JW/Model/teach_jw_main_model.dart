

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/home/JZ_association/Collection.dart';

class teach_jw_main_model{

  //跳转方法
  void jump(BuildContext context,object){
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => object));
  }
}
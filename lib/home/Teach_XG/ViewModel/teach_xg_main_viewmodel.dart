

import 'package:flutter/cupertino.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_main_model.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_studentinfo_view.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_main_model.dart';
import 'package:flutter_app01/home/Teach_XG/Utils/Teach_XG_Util.dart';
import 'package:flutter_app01/home/Teach_XG/View/teach_xg_rcholiday_view.dart';
import 'package:flutter_app01/home/Teach_XG/View/teach_xg_rcxjholiday_view.dart';
import 'package:flutter_app01/home/Teach_XG/View/teach_xg_studentpass_view.dart';
import 'package:flutter_app01/home/Teach_XG/View/teach_xg_teachinfo_view.dart';
import 'package:flutter_app01/home/Teach_XG/View/teach_xg_uploadpass_view.dart';

class teach_xg_main_viewmodel with ChangeNotifier{
  String defaul_image='https://ss0.bdstatic.com/6Ox1bjeh1BF3odCf/it/u=79211764,2995484383&fm=74&app=80&f=GIF&size=f121,121?sec=1880279984&t=f71b624e5264ede7a0c44597c47b4100';
  teach_xg_main_model txmm;

  teach_xg_main_viewmodel(teach_xg_main_model txmm){
    this.txmm=txmm;
    Teach_XG_Util.auto_login();
  }

  //跳转方法
  void jump(BuildContext context,object){
    this.txmm.jump(context, object);
  }

  //身体卡片点击跳转
  void onclick_jump(text,BuildContext context){
    switch(text){
      case '个人信息':
        this.txmm.jump(context, new teach_xg_teachinfo_view());
        break;
      case '学生密码修改':
        this.txmm.jump(context, new teach_xg_studentpass_view());
        break;
      case '日常请假审核':
        this.txmm.jump(context, new teach_xg_rcholiday_view());
        break;
      case '日常销假管理':
        this.txmm.jump(context, new teach_xg_rcxjholiday_view());
        break;
      case '节日请假审核':

        break;
      case '节日销假管理':

        break;
      case '密码修改':
        this.txmm.jump(context, new teach_xg_uploadpass_view());
        break;
    }
  }

}


import 'package:flutter/cupertino.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_main_model.dart';
import 'package:flutter_app01/home/Teach_JW/Utils/Teach_JW_Util.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_classcourse_view.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_hmc_view.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_studentinfo_view.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_teachcourse_view.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_uploadpass_view.dart';

class teach_jw_main_viewmodel with ChangeNotifier{
  String defaul_image='https://ss0.bdstatic.com/6Ox1bjeh1BF3odCf/it/u=79211764,2995484383&fm=74&app=80&f=GIF&size=f121,121?sec=1880279984&t=f71b624e5264ede7a0c44597c47b4100';
  teach_jw_main_model tjmm;

  teach_jw_main_viewmodel(teach_jw_main_model tjmm){
    this.tjmm=tjmm;
    Teach_JW_Util.auto_login();
  }

  //跳转方法
  void jump(BuildContext context,object){
    this.tjmm.jump(context, object);
  }

  //身体卡片点击跳转
  void onclick_jump(text,BuildContext context){
    switch(text){
      case '学生基本信息查询':
        this.tjmm.jump(context, new teach_jw_studentinfo_view());
        break;
      case '教师课表查询':
        this.tjmm.jump(context, new teach_jw_teachcourse_view());
        break;
      case '教室课表查询':
        this.tjmm.jump(context, new teach_jw_classcourse_view());
        break;
      case '班级花名册':
        this.tjmm.jump(context, new teach_jw_hmc_view());
        break;
      case '密码修改':
        this.tjmm.jump(context, new teach_jw_uploadpass_view());
        break;
    }
  }

}
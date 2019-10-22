

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/home/Student_course_sgin/Model/student_home_model.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/Model/teach_home_model.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/common_ui/teach_sgin_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class teach_home_viewmodel with ChangeNotifier{
  teach_home_model thm;
  BuildContext context;
  List<Widget>list_ui=[];

  teach_home_viewmodel(teach_home_model thm,BuildContext context){
    this.thm=thm;
    this.context=context;
    search1();
    bus.on("teach_details_view", (arg) {
      search1();
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off("teach_details_view"); //移除广播机制
  }

  void search1() async{
    if(now_studentid==null){
      return;
    }
    list_ui.clear();
    List<Course_Sgin>list = await this.thm.queryWhereEqual();
    for(Course_Sgin cs in list){
      List list1=cs.studata.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
      List list2=[];
      if(cs.s_sgin.length>5){
        list2=cs.s_sgin.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
      }
      List list3=[];
      if(cs.f_sgin.length>5){
        list3=cs.f_sgin.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
      }
      list_ui.add(teach_sgin_ui.card1(cs,this,list1.length.toString(),list2.length.toString(),list3.length.toString(),context));
    }
    notifyListeners();
  }

}
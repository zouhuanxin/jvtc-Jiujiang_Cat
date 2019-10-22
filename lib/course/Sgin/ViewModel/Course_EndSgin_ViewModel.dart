

import 'dart:async';
import 'dart:convert';

import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/course/Sgin/Model/Course_EndSgin_Model.dart';
import 'package:flutter_app01/course/Sgin/common_ui/course_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Course_EndSgin_ViewModel with ChangeNotifier{
  Course_EndSgin_Model cem;
  BuildContext context;
  String value;
  List<Widget>list_ui=[];
  static Timer time;
  int finish_number=0,unfinish_number=0;

  Course_EndSgin_ViewModel(Course_EndSgin_Model cem,BuildContext context,String value){
    this.cem=cem;
    this.context=context;
    this.value=value;
    time=new Timer.periodic(new Duration(seconds: 2), (timer) {
      search();
    });
  }

  void time_colse(){
    time.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    time_colse();
  }

  void search() async{
    List<Course_Sgin> list=await this.cem.queryWhereEqual();
    Course_Sgin cs;
    for(Course_Sgin test in list){
      if(test.teachid.trim()==now_studentid.trim()){
        cs=test;
      }
    }
    List arr=cs.s_sgin.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
    List sumarr=cs.studata.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
    finish_number=arr.length;
    unfinish_number=sumarr.length-arr.length;
    list_ui.clear();
    for(String str in arr){
      list_ui.add(course_ui.s_sgin_ui(str.split('&')[0], str.split('&')[1]));
    }
    notifyListeners();
  }

  //结束签到
  void end_sgin() async{
    time_colse();
    List<Course_Sgin> list=await this.cem.queryWhereEqual();
    Course_Sgin cs;
    for(Course_Sgin test in list){
      if(test.teachid.trim()==now_studentid.trim()){
        cs=test;
      }
    }

    List list1=[],list2=[];
    try{
      list1=cs.studata.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
      list2=cs.s_sgin.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
      for(int i=0;i<list1.length;i++){
        for(int j=0;j<list2.length;j++){
          String str1=list1[i].toString().split('&')[0];
          String str2=list2[j].toString().split('&')[0];
          if(str1.trim()==str2.trim()){
            list1.removeAt(i);
          }
        }
      }
    }catch(e){}

    int res=await this.cem.End_Sign(cs.objectId, list1.toString());
    if(res==0){
      Util.showTaost('结束签到成功', Toast.LENGTH_SHORT, Colors.blue);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

}
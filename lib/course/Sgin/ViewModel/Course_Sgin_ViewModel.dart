
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/course/Sgin/Model/Course_Sgin_Model.dart';
import 'package:flutter_app01/course/Sgin/common_ui/course_ui.dart';
import 'package:flutter_app01/home/Teach_JW/Utils/Teach_JW_Util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Course_Sgin_ViewModel with ChangeNotifier{
  Course_Sgin_Model csm;
  BuildContext context;
  SharedPreferences prefs;
  List<Widget>list_ui=[];
  String buttontext='创建签到';
  String value;
  String sgin_pass,course_name;

  Course_Sgin_ViewModel(Course_Sgin_Model csm,BuildContext context,String value){
    this.csm=csm;
    this.context=context;
    this.value=value;
    loading();
  }

  //拉取学生信息
  void loading() async{
    prefs=await SharedPreferences.getInstance();
    if(prefs.getString('teach_data')!=null){
      String res=prefs.getString('teach_data');
      Map<Object,dynamic>map=json.decode(res);
      List list=json.decode(json.encode(map['data']));
      for(int i=0;i<list.length;i++){
        Map<Object,dynamic>map2=json.decode(json.encode(list[i]));
        if(value.split(':')[0].toString().trim()==map2['kc'].toString().split('(')[0].trim()
        &&value.split(':')[1].toString().trim()==map2['bj'].toString().split('：')[1].trim()){
          course_name=value.split(':')[0].toString().trim();
          String temp=map2['hmc'].toString().split('(')[1].split(',')[0].trim();
          await teach_hmc_info1(temp.substring(1,temp.length-1));
        }
      }
    }
  }

  List list=[];
  void teach_hmc_info1(jx0404id) async{
    list =await this.csm.teach_hmc_info1(prefs, jx0404id);
    if(list!=null){
      _load_data(list);
    }else{
      Util.showTaost('访问失败', Toast.LENGTH_SHORT, Colors.red);
    }
  }

  void _load_data(List list) {
    for(int i=0;i<list.length;i++){
      List list2=json.decode(json.encode(list[i]));
      list_ui.add(
          Container(
            child: Row(
              children: <Widget>[
                course_ui.course_Card(list2[0].toString().split(':')[1].replaceAll('}', '')),
                course_ui.course_Card(list2[2].toString().split(':')[1].replaceAll('}', '')),
                course_ui.course_Card(list2[3].toString().split(':')[1].replaceAll('}', '')),
                course_ui.course_Card(list2[5].toString().split(':')[1].replaceAll('}', '')),
                course_ui.course_Card(list2[6].toString().split(':')[1].replaceAll('}', '')),
              ],
            ),
          )
      );
    }
    notifyListeners();
  }

  //创建签到
  void create_sgin() async{
    if(course_name.trim()==null||course_name.trim().length<1){
      Util.showTaost('课程名不能为空', Toast.LENGTH_SHORT, Colors.red);
      return;
    }
    if(buttontext.trim()=='创建签到'){
      //buttontext='结束签到';
      List templist=[];
      for(int i=0;i<list.length;i++){
        List list2=json.decode(json.encode(list[i]));
        templist.add(list2[5].toString().split(':')[1].replaceAll('}', '').trim()+'&'+list2[6].toString().split(':')[1].replaceAll('}', '').trim());
      }
      this.csm.create_sgin(templist, sgin_pass,course_name,context);
    }else{
      buttontext='创建签到';
    }
    notifyListeners();
  }

  set_sgin_pass(T){
    sgin_pass=T;
    notifyListeners();
  }
  set_course_name(T){
    course_name=T;
    notifyListeners();
  }
}
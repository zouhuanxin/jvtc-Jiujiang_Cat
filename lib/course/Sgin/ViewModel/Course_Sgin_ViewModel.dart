
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/common/Loading_Toast.dart';
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
          //这里course_name改为 课程名+班级名 以防止重复
          //因为可能会出现老师 授予俩个班同一门课程  这种情况如果仅保存课程名就会出现重复的情况
          //这里为了配合网页端的使用符号使用 - 号链接
          course_name=value.split(':')[0].toString().trim()+'-'+value.split(':')[1].toString().trim();
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
      //开启一个等待提示ui
      Loading_Toast lt;
      lt=Loading_Toast(context,'正在检查当前账号签到记录状态');
      lt.Open_Loading();
      //创建签到前先检查此账号有无未结束签到 如果有未结束签到则先把未结束签到结束后再创建此次签到
      List<Course_Sgin>list1=await this.csm.queryWhereEqual();
      for(int i=0;i<list1.length;i++){
        //则表示当前账号有未关闭状态的签到
        //这里一定要有账号判断
        //以保证不改变其他人的签到记录状态
        if(list1[i].teachid.trim()==now_studentid.trim()){
          //结束此次未关闭状态的签到
          lt.Upload_data('检查到异常，正在修复');
          int type=await this.csm.End_Sign(list1[i].objectId);
          if(type==0){
            lt.Upload_data('修复完成');
          }else{
            Util.showTaost('请重新创建签到', Toast.LENGTH_SHORT, Colors.green);
            return;
          }
        }
        lt.Upload_data('正在检查当前账号签到记录状态');
      }
      await this.csm.create_sgin(templist, sgin_pass,course_name,context);
      lt.Close_Loading();
    }else{
      //buttontext='创建签到';
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
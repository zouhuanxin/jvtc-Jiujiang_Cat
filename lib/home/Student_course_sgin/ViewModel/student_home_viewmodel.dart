

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/home/Student_course_sgin/Model/student_home_model.dart';
import 'package:flutter_app01/home/Student_course_sgin/common_ui/student_sgin_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class student_home_viewmodel with ChangeNotifier{
  student_home_model shm;
  BuildContext context;
  List<Widget>list_ui=[];

  student_home_viewmodel(student_home_model shm,BuildContext context){
    this.shm=shm;
    this.context=context;
    search1();
  }

  void search1() async{
    if(now_studentid.trim()==null){
      return;
    }
    list_ui.clear();
    List<Course_Sgin>list = await this.shm.queryWhereEqual();
    for(Course_Sgin cs in list){
      //判断是否是这个班级的学生从而进行签到
      //检查是否是此班级学生
      List list1=cs.studata.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
      bool vis=true;
      for(String str in list1){
        String tempstr=str.split('&')[0].trim();
        if(tempstr.trim()==now_studentid.trim()){
          vis=false;
        }
      }
      list_ui.add(student_sgin_ui.card1(cs,this,vis));
    }
    notifyListeners();
  }

  //签到
  void sgin(Course_Sgin cs) async{
    if(cs.sginpass.trim()==''||cs.sginpass.trim()==null||cs.sginpass.trim().length<1){
      showmodel1('签到警告', '确认签到吗?',cs);
    }else{
      showmodel2('签到警告',cs);
    }
  }

  //弹窗1
  showmodel1(String title, String content,Course_Sgin cs) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text((content)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("关闭"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("签到",style: TextStyle(color: Colors.red),),
              onPressed: () async{
                Navigator.of(context).pop();
                await qiandao(cs);
              },
            ),
          ],
        ));
  }
  //弹窗2
  showmodel2(String title,Course_Sgin cs) {
    String pass='';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Container(
            height: ScreenUtil().setHeight(220),
            child: Column(
              children: <Widget>[
//                Align(
//                  alignment: Alignment.topLeft,
//                  child: Text(
//                    '   签到密码',
//                    style: TextStyle(
//                        color: Color(int.parse(color2)),
//                        fontSize: 16,
//                        fontWeight: FontWeight.w600,
//                        fontStyle: FontStyle.normal),
//                  ),
//                ),
                SizedBox(height: ScreenUtil().setHeight(20),),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '请输入密码',
                    fillColor: Colors.white,
                    filled: dart_model,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
                  ),
                  textAlign: TextAlign.start,
                  onChanged: (T) {
                    pass=T;
                  },
                  autofocus: false,
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("关闭"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("签到",style: TextStyle(color: Colors.red),),
              onPressed: () async{
                if(pass.trim()==''||pass.trim()==null||pass.trim().length<1){
                  Util.showTaost('请输入密码', Toast.LENGTH_SHORT, Colors.red);
                  return;
                }
                if(pass.trim()!=cs.sginpass.trim()){
                  Util.showTaost('密码错误', Toast.LENGTH_SHORT, Colors.red);
                  return;
                }
                await qiandao(cs);
              },
            ),
          ],
        ));
  }

  void qiandao(Course_Sgin cs) async{
    //检查是否是此班级学生
    List list1=cs.studata.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
    String name;
    for(String str in list1){
      String tempstr=str.split('&')[0].trim();
      if(tempstr.trim()==now_studentid.trim()){
        name=str.split('&')[1];
      }
    }
    if(name!=null){
      //取出原来的数据
      //为尽可能保证数据的同步性这里再发送一次查询请求
      List<Course_Sgin> cs2=await this.shm.queryWhereEqual2(cs.objectId);
      List reslist=[];
      List arr1=cs2[0].s_sgin.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
      for(String str in arr1){
        if(str.length>1&&str.split('&')[0].trim()==now_studentid.trim()){
          reslist=[];
          Util.showTaost('你已经签到!', Toast.LENGTH_SHORT, Colors.green);
          return;
        }
        if(str.length>1) reslist.add(str);
      }
      String temp=now_studentid+'&'+name;
      reslist.add(temp);
      int i=await this.shm.updateSingle(reslist.toString(), cs.objectId);
      if(i==0){
        Navigator.of(context).pop();
        search1();
      }
    }else{
      Util.showTaost('你不是本班学生', Toast.LENGTH_SHORT, Colors.red);
    }
  }

}
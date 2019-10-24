

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/Utils/WebViewPage.dart';
import 'package:flutter_app01/common/Loading_Toast.dart';
import 'package:flutter_app01/home/Student_course_sgin/Model/student_home_model.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/Model/teach_home_model.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/common_ui/teach_sgin_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class teach_home_viewmodel with ChangeNotifier{
  teach_home_model thm;
  BuildContext context;
  List<Widget>list_ui=[];
  //搜索框输入内容
  String input1='',course_name;
  List<DropdownMenuItem> drop_items=[];

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
    for(int i=0;i<list.length;i++){
      List list1=list[i].studata.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
      List list2=[];
      if(list[i].s_sgin.length>5){
        list2=list[i].s_sgin.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
      }
      List list3=[];
      if(list[i].f_sgin.length>5){
        list3=list[i].f_sgin.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
      }
      list_ui.add(teach_sgin_ui.card1(list[i],this,list1.length.toString(),list2.length.toString(),list3.length.toString(),context));
    }
    getListData(list);
    notifyListeners();
  }

  void set_input1(T){
    input1=T;
    notifyListeners();
  }

  void set_coursename(T){
    course_name=T;
    notifyListeners();
  }

  //搜索此学生所有签到记录表
  void search_table(){
    if(input1==null||input1.length<3||input1==''){
      Util.showTaost('请输入', Toast.LENGTH_SHORT, Colors.grey);
      return;
    }
    if(course_name==null||course_name.length<3||course_name==''){
      Util.showTaost('请选择', Toast.LENGTH_SHORT, Colors.grey);
      return;
    }
    if(now_studentid==null||now_studentid.length<3||now_studentid==''){
      Util.showTaost('请绑定学号或者登陆系统', Toast.LENGTH_SHORT, Colors.grey);
      return;
    }
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new WebViewPage(
                url: 'http://47.94.255.154:8080/imagetable/index.html?teachid='+now_studentid+'&sid='+input1+'&course_name='+course_name+'',
                title: '学生签到统计')));
  }

  void getListData(List<Course_Sgin>list) {
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem;
    //去重
    //去重保存集合
    Set set = new Set();
    List<dynamic>str_list=new List();
    for(int i=0;i<list.length;i++){
      set.add(list[i].course_name.toString().split('-')[0].trim());
    }
    str_list=set.toList();
    for(int i=0;i<str_list.length;i++){
      String temp=str_list[i].toString().split('-')[0].trim();
      dropdownMenuItem = new DropdownMenuItem(
        child: Text(temp.length>5?temp.substring(0,5)+'\n'+temp.substring(5,
            temp.toString().trim().length>10?11:temp.toString().trim().length):temp,style: TextStyle(fontSize: ScreenUtil().setSp(35)),overflow: TextOverflow.ellipsis,),
        value: str_list[i].toString().trim(),
      );
      items.add(dropdownMenuItem);
    }
    drop_items.clear();
    drop_items=items;
    notifyListeners();
  }


  void deleteSingle(String currentObjectId) async{
    int res=await this.thm.deleteSingle(currentObjectId);
    if(res==0){
      search1();
    }
  }

  //弹窗
  deleteSingle_showmodel(String currentObjectId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('系统提示'),
          content: Text(('确定删除此条签到记录吗？')),
          actions: <Widget>[
            new FlatButton(
              child: new Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("删除",style: TextStyle(color: Colors.red),),
              onPressed: () {
                deleteSingle(currentObjectId);
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
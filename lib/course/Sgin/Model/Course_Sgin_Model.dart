

import 'dart:convert';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/course/Sgin/View/Course_EndSgin_View.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Course_Sgin_Model{

  Future<List> teach_hmc_info1(SharedPreferences prefs,jx0404id) async{
    String res=await Teach_HttpUtil.teach_hmc_info('teach_hmc_info', prefs.getString('jwcookie'), jx0404id);
    Map<Object,dynamic>map=json.decode(res);
    if(map['code']=='0'){
      List list=json.decode(map['data']);
      return list;
    }else{
      return null;
    }
  }

  //添加签到信息
  void create_sgin(List list,String pass,String course_name,BuildContext context) async{
    Course_Sgin cs = Course_Sgin();
    cs.teachid = now_studentid;
    cs.teachname = username;
    cs.teachtel = phone;
    cs.status='true';
    cs.studata=json.encode(list);
    cs.sginpass=pass;
    cs.course_name=course_name;
    cs.save().then((BmobSaved bmobSaved) {
      Util.showTaost('创建成功', Toast.LENGTH_SHORT, Colors.blue);
      Util.jump(context, new Course_EndSgin_View(str: bmobSaved.objectId,));
    }).catchError((e) {
      print(BmobError.convert(e).error);
    });
  }

  //查询此账号之前签到有无未结束签到
  //如果有则先结束所有未结束签到
  //如果无则开始创建签到

  Future<List<Course_Sgin>> queryWhereEqual() async{
    List<Course_Sgin>blogs=[];
    BmobQuery<Course_Sgin> query = BmobQuery();
    query.addWhereEqualTo("status", 'true');
    await query.queryObjects().then((data) {
      blogs = data.map((i) => Course_Sgin.fromJson(i)).toList();
    }).catchError((e) {
      print(BmobError.convert(e).error);
    });
    return blogs;
  }
  //结束签到  修改状态
  Future<int> End_Sign(String currentObjectId) async{
    int type=-1;
    Course_Sgin blog = Course_Sgin();
    blog.objectId = currentObjectId;
    blog.status='false';
    await blog.update().then((BmobUpdated bmobUpdated) {
      type=0;
    }).catchError((e) {
      type-1;
      print(BmobError.convert(e).error);
    });
    return type;
  }
}
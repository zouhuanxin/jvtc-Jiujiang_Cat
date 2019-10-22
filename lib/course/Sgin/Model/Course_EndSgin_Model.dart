

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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Course_EndSgin_Model{

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
  Future<int> End_Sign(String currentObjectId,String f_sgin) async{
    int type=-1;
    Course_Sgin blog = Course_Sgin();
    blog.objectId = currentObjectId;
    blog.f_sgin=f_sgin;
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
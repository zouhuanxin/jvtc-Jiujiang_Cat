
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class student_home_model{

  //查询一条数据
  ///等于条件查询
  Future<List<Course_Sgin>> queryWhereEqual() async{
    List<Course_Sgin>blogs=[];
    BmobQuery<Course_Sgin> query = BmobQuery();
    query.addWhereEqualTo("status", "true");
    await query.queryObjects().then((data) {
      blogs = data.map((i) => Course_Sgin.fromJson(i)).toList();
    }).catchError((e) {
      print(BmobError.convert(e).error);
    });
    return blogs;
  }

  Future<List<Course_Sgin>> queryWhereEqual2(String objectid) async{
    List<Course_Sgin>blogs=[];
    BmobQuery<Course_Sgin> query = BmobQuery();
    query.addWhereEqualTo("objectId", objectid);
    await query.queryObjects().then((data) {
      blogs = data.map((i) => Course_Sgin.fromJson(i)).toList();
    }).catchError((e) {
      print(BmobError.convert(e).error);
    });
    return blogs;
  }

  Future<int>updateSingle(String str,String currentObjectId) async{
    int type=0;
    Course_Sgin blog = Course_Sgin();
    blog.objectId = currentObjectId;
    blog.s_sgin = str;
    await blog.update().then((BmobUpdated bmobUpdated) {
      Util.showTaost('签到成功', Toast.LENGTH_SHORT, Colors.blue);
      type=0;
    }).catchError((e) {
      type=-1;
      Util.showTaost('签到失败', Toast.LENGTH_SHORT, Colors.red);
      print(BmobError.convert(e).error);
    });
    return type;
  }

  //修改当前签到状态
  Future<int>updateSingle2(String str,String currentObjectId) async{
    int type=0;
    Course_Sgin blog = Course_Sgin();
    blog.objectId = currentObjectId;
    blog.sgin_status = str;
    await blog.update().then((BmobUpdated bmobUpdated) {
      type=0;
    }).catchError((e) {
      type=-1;
      print(BmobError.convert(e).error);
    });
    return type;
  }

}
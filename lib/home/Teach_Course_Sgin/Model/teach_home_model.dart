
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class teach_home_model{

  //查询一条数据
  ///等于条件查询
  Future<List<Course_Sgin>> queryWhereEqual() async{
    List<Course_Sgin>blogs=[];
    BmobQuery<Course_Sgin> query = BmobQuery();
    query.addWhereEqualTo("teachid", now_studentid);
    query.setOrder('-createdAt');
    query.setLimit(100);
    //query.setSkip(1);
    await query.queryObjects().then((data) {
      blogs = data.map((i) => Course_Sgin.fromJson(i)).toList();
    }).catchError((e) {
      print(BmobError.convert(e).error);
    });
    return blogs;
  }

  ///删除一条数据
  Future<int>deleteSingle(String currentObjectId) async{
    int type=0;
    Course_Sgin blog = Course_Sgin();
    blog.objectId = currentObjectId;
    await blog.delete().then((BmobHandled bmobHandled) {
      currentObjectId = null;
      type=0;
      Util.showTaost('删除成功', Toast.LENGTH_SHORT, Colors.blue);
    }).catchError((e) {
      type=-1;
      Util.showTaost('删除失败', Toast.LENGTH_SHORT, Colors.red);
      print(BmobError.convert(e).error);
    });
    return type;
  }
}
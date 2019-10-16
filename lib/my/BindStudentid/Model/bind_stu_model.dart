
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class bind_stu_model{

  //添加学号字段到用户表中
  updateSingle(stu) async{
    BmobQuery<QTuser> query = BmobQuery();
    query.addWhereEqualTo("phone", phone);
    await query.queryObjects().then((data) {
      List<QTuser>templist = data.map((i) => QTuser.fromJson(i)).toList();
      QTuser blog = QTuser();
      blog.objectId = templist[0].objectId;
      blog.studentid=stu;
      blog.update().then((BmobUpdated bmobUpdated) {
        Util.showTaost('绑定成功', Toast.LENGTH_SHORT, Colors.blue);
      }).catchError((e) {
        Util.showTaost('稍后重试', Toast.LENGTH_SHORT, Colors.red);
      });
    }).catchError((e) {});
  }

  //检查此账号是否以及绑定过学号
  Future<QTuser> search_stu() async{
    QTuser qTuser;
    BmobQuery<QTuser> query = BmobQuery();
    query.addWhereEqualTo("phone", phone);
    await query.queryObjects().then((data) {
      List<QTuser>templist = data.map((i) => QTuser.fromJson(i)).toList();
      qTuser=templist[0];
    }).catchError((e) {});
    return qTuser;
  }

}
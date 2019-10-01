
import 'dart:io';

import 'package:data_plugin/bmob/bmob_file_manager.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/type/bmob_file.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FileHttp{
  ///上传文件，上传文件涉及到android的文件访问权限，调用此方法前需要开发者们先适配好应用在各个android版本的权限管理。
  static Future<String> uploadFile(String path) async{
    String url;
    if (path == null) {
      showTaost("请先选择文件",Toast.LENGTH_SHORT,Colors.red);
      return null;
    }
    //showTaost("上传中，请稍候……",Toast.LENGTH_SHORT,Colors.blue);
    File file = new File(path);
    await BmobFileManager.upload(file).then((BmobFile bmobFile) {
      //print("${bmobFile.cdn}\n${bmobFile.url}\n${bmobFile.filename}");
      showTaost("图片上传成功",Toast.LENGTH_SHORT,Colors.blue);
      url = bmobFile.url;
    }).catchError((e) {
      showTaost(BmobError.convert(e).error,Toast.LENGTH_SHORT,Colors.red);
    });
    return url;
  }

  ///删除文件
  static Future<String> deleteFile(String url) {
    if (url == null) {
      showTaost("请先选择文件",Toast.LENGTH_SHORT,Colors.red);
      return null;
    }
    BmobFileManager.delete(url).then((BmobHandled bmobHandled) {
      //print("删除成功：" + bmobHandled.msg);
      showTaost('删除成功',Toast.LENGTH_SHORT,Colors.blue);
      return bmobHandled.msg;
    }).catchError((e) {
      print(BmobError.convert(e).error);
      showTaost(BmobError.convert(e).error,Toast.LENGTH_SHORT,Colors.red);
    });
  }

  static void showTaost(msg, type, color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
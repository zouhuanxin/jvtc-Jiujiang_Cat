
import 'dart:io';

import 'package:data_plugin/bmob/bmob_file_manager.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/type/bmob_file.dart';

class FileHttp{
  ///上传文件，上传文件涉及到android的文件访问权限，调用此方法前需要开发者们先适配好应用在各个android版本的权限管理。
  static Future<String> uploadFile(String path) {
    if (path == null) {
      print("请先选择文件");
      return null;
    }
    print("上传中，请稍候……");
    File file = new File(path);
    BmobFileManager.upload(file).then((BmobFile bmobFile) {
      print("${bmobFile.cdn}\n${bmobFile.url}\n${bmobFile.filename}");
      return bmobFile.url;
    }).catchError((e) {
      return BmobError.convert(e).error;
    });
  }

  ///删除文件
  static Future<String> deleteFile(String url) {
    if (url == null) {
      print("请先上传文件");
      return null;
    }
    BmobFileManager.delete(url).then((BmobHandled bmobHandled) {
      print("删除成功：" + bmobHandled.msg);
      return bmobHandled.msg;
    }).catchError((e) {
      print(BmobError.convert(e).error);
      return BmobError.convert(e).error;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/home/Teach_course_sgin/Model/teach_create_class_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class teach_create_class_viewmodel with ChangeNotifier{
  String class_name,class_college,class_teachname;
  teach_create_class_model tccm;
  List<DropdownMenuItem> items;

  teach_create_class_viewmodel(teach_create_class_model tccm){
    this.tccm=tccm;
    loading_drop();
  }

  void loading_drop(){
    items=tccm.getListData();
    notifyListeners();
  }

  void set_class_name(T){
    class_name=T;
    notifyListeners();
  }

  void set_class_college(T){
    class_college=T;
    notifyListeners();
  }

  void set_class_teachname(T){
    class_teachname=T;
    notifyListeners();
  }

  //提交信息
  void Submit(){
    Util.showTaost('提交成功', Toast.LENGTH_SHORT, Colors.blue);
  }

}
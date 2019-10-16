
import 'package:flutter/cupertino.dart';
import 'package:flutter_app01/home/Teach_course_sgin/Model/sgin_class_bean.dart';
import 'package:flutter_app01/home/Teach_course_sgin/Model/teach_view_main_model.dart';

class teach_view_main_viewmodel with ChangeNotifier{

  String phone;
  List<sgin_class_bean>list=[];

  teach_view_main_model tvmm=new teach_view_main_model();

  void search_sgin_class(){
    list = tvmm.search_sgin_class(phone);
    notifyListeners(); //通知听众刷新
  }

}
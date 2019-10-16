
import 'package:flutter_app01/home/Teach_course_sgin/Model/sgin_class_bean.dart';

class teach_view_main_model{

  //获取此用户是否有创建签到班级
  Object search_sgin_class(phone){
    //这里模拟一组数据
    List<sgin_class_bean>list=[];
    for(int i=0;i<5;i++){
      String temp=i.toString();
      sgin_class_bean scb=new sgin_class_bean(temp,temp,temp,temp,temp);
      list.add(scb);
    }
    return list;
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/home/Student_course_sgin/ViewModel/student_home_viewmodel.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/View/teach_details_view.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/ViewModel/teach_home_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class teach_sgin_ui{

  //卡片1
  static Widget card1(Course_Sgin cs,teach_home_viewmodel shv,String text1,String text2,String text3,BuildContext context){
    return GestureDetector(
      onTap: (){
        Util.jump(context, new teach_details_view(cs: cs,));
      },
      child: new Container(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
            child: Column(
              children: <Widget>[
                Align(child: Text(cs.course_name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(70)),),alignment: Alignment.topLeft,),
                Align(child: Text('教师:'+cs.teachname,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('学工号:'+cs.teachid,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('创建时间:'+cs.createdAt,style: TextStyle(fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(40),color: Colors.green,),),alignment: Alignment.topLeft,),
                Row(
                  children: <Widget>[
                    Expanded(child: Align(child: Text('班级总人数:'+text1,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.center,),flex: 1,),
                    Expanded(child: Align(child: Text('已签到人数:'+text2,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.center,),flex: 1,),
                    Expanded(child: Align(child: Text('未签到人数:'+text3,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.center,),flex: 1,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
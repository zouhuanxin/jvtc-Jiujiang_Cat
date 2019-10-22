

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/home/Student_course_sgin/ViewModel/student_home_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class student_sgin_ui{

  //卡片1
  static Widget card1(Course_Sgin cs,student_home_viewmodel shv,bool vis){
    return GestureDetector(
      onTap: (){
        //Util.jump(context, new teach_classcourse_view(classId: objectid,));
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
                Align(child: Text('时间:'+cs.createdAt,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                SizedBox(height: ScreenUtil().setHeight(30),),
                Offstage(
                  offstage: vis,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text('',style: TextStyle(color: Colors.white),),flex: 2,),
                      Expanded(child: RaisedButton(onPressed: (){
                        shv.sgin(cs);
                      },child: Text('签到',style: TextStyle(color: Colors.white),),color: Colors.blue,),flex: 1,)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
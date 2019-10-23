
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/home/Teach_JW/ViewModel/teach_jw_hmc_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class course_ui{

  static Widget Card1(text1,text2,id){
    return new Container(
      height: ScreenUtil().setHeight(260),
      padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setHeight(20), ScreenUtil().setWidth(20), ScreenUtil().setHeight(20)),
      child: Card(
        child: Row(
          children: <Widget>[
            Expanded(child: Column(
              children: <Widget>[
                Text('\n'+text1),
                Text(text2),
              ],
            ),flex: 4,),
            Expanded(child: GestureDetector(
              onTap: (){

              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(10), 0),
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setHeight(10), ScreenUtil().setWidth(10), ScreenUtil().setHeight(10)),
                decoration: BoxDecoration(
                  color: Colors.grey
                ),
                child:  Text('花名册',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),textAlign: TextAlign.center,),
              ),
            ),flex: 1,),
          ],
        ),
      ),
    );
  }

  static Widget course_Card(String text){
    return new GestureDetector(
      onTap: (){
        if(text.length==1){
          return;
        }
        //_ShowModel(list[0].toString().split(':')[1].replaceAll('}', ''), text);
      },
      child: new Container(
        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), ScreenUtil().setHeight(15), ScreenUtil().setWidth(15), ScreenUtil().setHeight(15)),
        height: ScreenUtil().setHeight(200),
        width: ScreenUtil().setWidth(180),
        child: Text(text,style: TextStyle(fontSize: ScreenUtil().setSp(30)),textAlign: TextAlign.center,),
      ),
    );
  }

  static Widget head_text(String text){
    return new Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), ScreenUtil().setHeight(15), ScreenUtil().setWidth(15), ScreenUtil().setHeight(15)),
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(180),
      child: Text(text,style: TextStyle(color:Colors.green,fontSize: ScreenUtil().setSp(30)),textAlign: TextAlign.center,),
    );
  }

  static Widget s_sgin_ui(text1,text2,text3){
    return new GestureDetector(
      onTap: (){

      },
      child: new Container(
        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), ScreenUtil().setHeight(15), ScreenUtil().setWidth(15), ScreenUtil().setHeight(15)),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(text1,style: TextStyle(fontSize: ScreenUtil().setSp(30)),textAlign: TextAlign.center,),flex: 1,),
            Expanded(child: Text(text2,style: TextStyle(fontSize: ScreenUtil().setSp(30)),textAlign: TextAlign.center,),flex: 1,),
            Expanded(child: Text(text3,style: TextStyle(fontSize: ScreenUtil().setSp(30)),textAlign: TextAlign.center,),flex: 1,)
          ],
        ),
      ),
    );
  }
}
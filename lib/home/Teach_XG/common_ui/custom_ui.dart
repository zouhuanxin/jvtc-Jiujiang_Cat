

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/Teach_HttpUtil.dart';
import 'package:flutter_app01/home/Teach_XG/ViewModel/teach_xg_rcholiday_viewmodel.dart';
import 'package:flutter_app01/home/Teach_XG/ViewModel/teach_xg_rcxjholiday_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class custom_ui{

  //日常请假审批数据卡片
  static Widget card1 (text1,text2,text3,text4,text5,text6,text7,text8,text9,text10,id,teach_xg_rcholiday_viewmodel txrv){
    return GestureDetector(
      onTap: (){

      },
      child: new Container(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
            child: Column(
              children: <Widget>[
                Align(child: Text(text1,style: TextStyle(fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(70)),),alignment: Alignment.topLeft,),
                Align(child: Text(text2,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('性别:'+text3,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('请假时间:'+text4,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('销假时间:'+text5,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('事由类型:'+text6,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('外出地点:'+text7,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('班级:'+text8,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text(text9,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text(text10,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.red),),alignment: Alignment.topLeft,),
                Row(
                  children: <Widget>[
                    Expanded(child: RaisedButton(onPressed: (){
                      txrv.FDYAllLeaveExam_Edit(id, 2);
                    },child: Text('审批拒绝',style: TextStyle(color: Colors.white),),color: Colors.red,),flex: 1,),
                    Expanded(child: RaisedButton(onPressed: (){
                      txrv.FDYAllLeaveExam_Edit(id, 1);
                    },child: Text('审批通过',style: TextStyle(color: Colors.white),),color: Colors.blue,),flex: 1,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //日常销假管理数据卡片
  static Widget card2 (text1,text2,text3,text4,text5,text6,text7,text8,id,teach_xg_rcxjholiday_viewmodel txrv){
    return GestureDetector(
      onTap: (){

      },
      child: new Container(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
            child: Column(
              children: <Widget>[
                Align(child: Text(text1,style: TextStyle(fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(70)),),alignment: Alignment.topLeft,),
                Align(child: Text(text2,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('性别:'+text3,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('请假时间:'+text4,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('销假时间:'+text5,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('外出地点:'+text6,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('班级:'+text7,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Align(child: Text('学期:'+text8,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                Row(
                  children: <Widget>[
                    Expanded(child: Text('',style: TextStyle(color: Colors.white),),flex: 1,),
                    Expanded(child: RaisedButton(onPressed: (){
                      txrv.FDYDisAllLeave2(id);
                    },child: Text('销假',style: TextStyle(color: Colors.white),),color: Colors.blue,),flex: 1,)
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
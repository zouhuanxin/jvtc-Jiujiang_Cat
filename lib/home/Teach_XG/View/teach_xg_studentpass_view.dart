
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_studentpass_model.dart';
import 'package:flutter_app01/home/Teach_XG/ViewModel/teach_xg_studentpass_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_xg_studentpass_view extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_xg_studentpass_view_State();
  }

}

class teach_xg_studentpass_view_State extends State<teach_xg_studentpass_view>{
  var providers = Providers();

  void _loading() async{
    var txsm= teach_xg_studentpass_model();
    var txsv= teach_xg_studentpass_viewmodel(txsm);
    providers.provide(Provider<teach_xg_studentpass_viewmodel>.value(txsv));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  Widget username_input(){
    return new Container(
      margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
      padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
      child: Provide<teach_xg_studentpass_viewmodel>(builder: (context,child,value){
        return TextField(
          maxLines: 1,
          decoration:  InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 0)
          ),
          onChanged: (T){
            value.set_username(T);
          },
          autofocus: false,
        );
      }),
    );
  }

  //修改按钮
  Widget buildUploadButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child:
        Provide<teach_xg_studentpass_viewmodel>(builder: (context, child, value) {
          return RaisedButton(
            child: Text(
              '重置',
              style: TextStyle(color: Color(int.parse(color1))),
            ),
            color: Color(int.parse(color2)),
            onPressed: () {
              value.TeacherReSetpass();
            },
            shape: StadiumBorder(side: BorderSide()),
          );
        }),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ProviderNode(child: Scaffold(
      appBar: new AppBar(
        title: new Text(
          '学生密码重置                                       ',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(int.parse(color2)),
              fontWeight: FontWeight.w800,
              fontSize: 17),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(int.parse(color2))),
        backgroundColor: Color(int.parse(color1)),
        centerTitle: true,
        actions: <Widget>[new Container()],
      ),
      body: new Container(
        decoration: BoxDecoration(color: Color(int.parse(color1))),
        child: ListView(
          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(50),),
            Text(
              '   学生学号',
              style: TextStyle(
                  color: Color(int.parse(color2)),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal),
            ),
            username_input(),
            Container(
              height: 1,
              decoration: BoxDecoration(
                  color: Color(int.parse(color2))
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(100),),
            buildUploadButton(),
          ],
        ),
      ),
    ), providers: providers);
  }

}
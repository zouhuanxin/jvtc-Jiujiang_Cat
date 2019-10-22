
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teach_xg_teachinfo_view extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_xg_teachinfo_view_State();
  }

}

class teach_xg_teachinfo_view_State extends State<teach_xg_teachinfo_view>{
  SharedPreferences prefs;
  Map<Object,dynamic>map;

  void _loading() async{
    prefs=await SharedPreferences.getInstance();
    map = json.decode(prefs.getString('teach_xgdata'));
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  Widget ziliao_card (){
    return GestureDetector(
      onTap: (){

      },
      child: new Container(
        child: Card(
          child: Container(
            margin: EdgeInsets.all(ScreenUtil().setWidth(40)),
            padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
            child: Column(
              children: <Widget>[
                Align(child: Text('姓名:'+(map==null?'请尝试重新登陆':map['UserName']),style: TextStyle(fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(70)),),alignment: Alignment.topLeft,),
                SizedBox(height: ScreenUtil().setHeight(20),),
                Align(child: Text('学工号:'+(map==null?'':map['XGH']),style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                SizedBox(height: ScreenUtil().setHeight(20),),
                Align(child: Text('性别:'+((map==null?'':map['Sex']=='1'?'男':'女')),style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          '教师个人信息                                       ',
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
          children: <Widget>[
            ziliao_card()
          ],
        ),
      ),
    );
  }

}
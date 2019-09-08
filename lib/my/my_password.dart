import 'dart:async';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/index/index.dart';
import 'package:flutter_app01/my/upload_password.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/my/SMS_password.dart';

class my_password extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return my_password_State();
  }
}

class my_password_State extends State<my_password> {

  Widget buildButton01(){
    return Align(
      alignment: Alignment.center,
      child: new Container(
        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
        width: 300,
        height: 50,
        child: RaisedButton(
          textTheme: ButtonTextTheme.accent,
          color: Colors.blue,
          highlightColor: Colors.deepPurpleAccent,
          splashColor: Colors.yellow,
          colorBrightness: Brightness.dark,
          elevation: 50.0,
          highlightElevation: 100.0,
          disabledElevation: 20.0,
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new SMS_password()));
          },
          child: Text(
            '短信验证码修改',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }

  Widget buildButton02(){
    return Align(
      alignment: Alignment.center,
      child: new Container(
        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
        width: 300,
        height: 50,
        child: RaisedButton(
          textTheme: ButtonTextTheme.accent,
          color: Colors.green,
          highlightColor: Colors.deepPurpleAccent,
          splashColor: Colors.yellow,
          colorBrightness: Brightness.dark,
          elevation: 50.0,
          highlightElevation: 100.0,
          disabledElevation: 20.0,
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new upload_password()));
          },
          child: Text(
            '旧密码验证修改',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }


  @override
Widget build(BuildContext context) {
  return new Scaffold(
      appBar: new AppBar(
        title: new Text('修改密码                                       ',
          textAlign: TextAlign.left,
          style: TextStyle(color: Color(int.parse(color2)),
              fontWeight: FontWeight.w800,
              fontSize: 17),),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(int.parse(color2))),
        backgroundColor: Color(int.parse(color1)),
        centerTitle: true,
        actions: <Widget>[
          new Container()
        ],
      ),
      body: new Container(
        decoration: BoxDecoration(
            color: Color(int.parse(color1))
        ),
        child: new Container(
          child: new ListView(
            children: <Widget>[
              buildButton01(),
              buildButton02()
            ],
          ),
        ),
      ));
}}
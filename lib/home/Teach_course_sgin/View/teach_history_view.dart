
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_course_sgin/ViewModel/teach_view_main_viewmodel.dart';
import 'package:provide/provide.dart';

class teach_history_view extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_history_view_State();
  }

}

class teach_history_view_State extends State<teach_history_view>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '签到记录                                       ',
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
        body: Container(
          decoration: BoxDecoration(
              color: Color(int.parse(color1))
          ),
          child: new ListView(
            children: <Widget>[

            ],
          ),
        ));
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/gxinfo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';
import 'package:flutter_app01/home/home.dart';
import 'package:flutter_app01/course/course.dart';
import 'package:flutter_app01/my/my.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:data_plugin/bmob/bmob_query.dart';

class Love_time extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Love_time_State();

}

class Love_time_State extends State<Love_time>{
  
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('情侣时光                                       ',
            textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse('0xffffffff')),fontWeight: FontWeight.w800,fontSize: 25),),
          elevation: 0.0,
          leading: new Container(
            margin: EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: (){

              },
              child: new ClipOval(
                child: new Image.asset('images/2.0.x/couples.png',fit: BoxFit.fill),
              ),
            ),
          ),
          backgroundColor: Color(int.parse('0xfffb93c0')),
          centerTitle: true,
        ),
        body: new Container(
          decoration: BoxDecoration(
              color: Color(int.parse(color1))
          ),
          child: new ListView(
            children: [

            ],
          ),
        ),
      ),
    );
  }

}
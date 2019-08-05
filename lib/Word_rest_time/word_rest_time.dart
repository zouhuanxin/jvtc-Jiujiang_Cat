import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Learn_teach/learn_teach.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter_app01/Bean/zxtime.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';

class word_rest_time extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>word_rest_time_State();

}

class word_rest_time_State extends State<word_rest_time>{
  String imageurl='https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=4010497054,3899149768&fm=26&gp=0.jpg';
  String title='夏季作息时间表';
  Widget component1(){
    return new Container(
      child: new Column(
        children: <Widget>[
          new Text(title,style: TextStyle(color: Color(int.parse(color2))),),
          new Image(image: new NetworkImage(imageurl) )
        ],
      ),
    );
  }

  void _bmob_get_information(){
    BmobQuery<zxtime> query = BmobQuery();
    query.addWhereNotEqualTo("imageurl", "12%%%3");
    query.queryObjects().then((data) {
      List<zxtime> sfs = data.map((i) => zxtime.fromJson(i)).toList();
      setState(() {
        title=sfs[0].name+"\n"+sfs[0].text;
        imageurl=sfs[0].url;
      });
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: "系统错误",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bmob_get_information();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('作息时间                                       ',
          textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
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
            color: Color(int.parse(color1)),
          ),
          child: new ListView(
            children: <Widget>[
              component1()
            ],
          ),
        )
    );
  }

}
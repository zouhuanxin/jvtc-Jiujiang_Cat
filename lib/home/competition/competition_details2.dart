import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/Bean/competition.dart';
import 'package:flutter_app01/HttpUtil/Lose_HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

//失物招领


class competition_details2 extends StatefulWidget {
  final competition cp;
  final QTuser qt;
  const competition_details2({Key key, this.cp,this.qt}) : super(key: key);

  @override
  State<StatefulWidget> createState() => competition_details2_State(cp,qt);
}

class competition_details2_State extends State<competition_details2> {
  competition cp;
  QTuser qt;

  competition_details2_State(value1,value2) {
    cp = value1;
    qt = value2;
  }

  void Toastmodel(str,type,color){
    Fluttertoast.showToast(
        msg: str,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          '作品介绍                                       ',
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
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                child: new Align(
                  alignment: FractionalOffset.center,
                  child: new GestureDetector(
                    child: new ClipOval(
                      child: new Image.memory(base64.decode(qt==null?default_image:qt.imagebase64),fit: BoxFit.fill,height: 80,width: 80,),
                    ),
                  ),
                ),
              ),
              Text(
                qt==null?'匿名':qt.username,
                style: TextStyle(
                    color: Color(int.parse(color2)),
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            cp.introduce,
            style: TextStyle(
                color: Color(int.parse(color2)),
                fontWeight: FontWeight.w100,
                fontSize: 12),
            maxLines: 15,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '分类：${cp.type}',
            style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.w100, fontSize: 12),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: cp.logo!=null
                ? new Image.network(
              cp.logo,
              fit: BoxFit.fill,
              width: cp.logo!=null
                  ? MediaQueryData.fromWindow(ui.window).size.width * 0.9
                  : 0,
            )
                : Text(''),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: cp.image2!=null
                ? new Image.network(
              cp.image2,
              fit: BoxFit.fill,
              width: cp.image2!=null
                  ? MediaQueryData.fromWindow(ui.window).size.width * 0.9
                  : 0,
            )
                : Text(''),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: cp.image3!=null
                ? new Image.network(
              cp.image3,
              fit: BoxFit.fill,
              width: cp.image3!=null
                  ? MediaQueryData.fromWindow(ui.window).size.width * 0.9
                  : 0,
            )
                : Text(''),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}

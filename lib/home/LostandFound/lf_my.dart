import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';

//失物招领

class lf_my extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => lf_my_State();
}

class lf_my_State extends State<lf_my> {
  //搜索方式有俩种
  //一种以图搜图
  //一种特征搜索
  //上次提交时需要提交图片库同时进行特征识别以及文字识别

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          '失物招领-我的                                       ',
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
      body: Text("我的"),
    );
  }
}

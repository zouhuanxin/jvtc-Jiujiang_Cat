import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/course/Ui_course2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class teach_jw_course_view extends StatefulWidget{
  final List list;

  const teach_jw_course_view({Key key, this.list}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_jw_course_view_State(list);
  }

}

class teach_jw_course_view_State extends State<teach_jw_course_view>{
  List list=[];
  teach_jw_course_view_State(List list){
    this.list=list;
  }

  Widget head_text(String text){
    return new Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), ScreenUtil().setHeight(15), ScreenUtil().setWidth(15), ScreenUtil().setHeight(15)),
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(200),
      child: Text(text,style: TextStyle(color:Colors.green,fontSize: ScreenUtil().setSp(30)),textAlign: TextAlign.center,),
    );
  }

  Widget course_Card(String text){
    return new GestureDetector(
      onTap: (){
        if(text.length==1){
          return;
        }
        _ShowModel(list[0].toString().split(':')[1].replaceAll('}', ''), text);
      },
      child: new Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), ScreenUtil().setHeight(15), ScreenUtil().setWidth(15), ScreenUtil().setHeight(15)),
        height: ScreenUtil().setHeight(200),
        width: ScreenUtil().setWidth(200),
        decoration: BoxDecoration(
          color: text.length!=1?Color(int.parse('0xfff1f1f1')):Color(int.parse(color1)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: text.length!=1?Color(int.parse('0xfff1f1f1')):Color(int.parse(color1)), width: 0.5),
          boxShadow: [BoxShadow(color: text.length!=1?Color(int.parse('0xffcccccc')):Color(int.parse(color1)),
              offset: Offset(1.0, 1.0), blurRadius: 1.0, spreadRadius: 1.0),],
        ),
        child: Text(text,style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
      ),
    );
  }

  Widget _load_data() {
    List<Widget>list_ui=[];
    for(int i=1;i<7;i++){
      list_ui.add(
        Row(
          children: <Widget>[
            course_Card(list[1+(i-1)*1].toString().split(':')[1].replaceAll('}', '')),
            course_Card(list[7+(i-1)*1].toString().split(':')[1].replaceAll('}', '')),
            course_Card(list[13+(i-1)*1].toString().split(':')[1].replaceAll('}', '')),
            course_Card(list[19+(i-1)*1].toString().split(':')[1].replaceAll('}', '')),
            course_Card(list[25+(i-1)*1].toString().split(':')[1].replaceAll('}', '')),
            course_Card(list[31+(i-1)*1].toString().split(':')[1].replaceAll('}', '')),
            course_Card(list[37+(i-1)*1].toString().split(':')[1].replaceAll('}', '')),
          ],
        )
      );
    }
    return Container(
      height: ScreenUtil().setHeight(1600),
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          new Column(
            children: [
              Row(
                children: <Widget>[
                  head_text('星期一'),
                  head_text('星期二'),
                  head_text('星期三'),
                  head_text('星期四'),
                  head_text('星期五'),
                  head_text('星期六'),
                  head_text('星期天'),
                ],
              ),
              Column(
                children: list_ui,
              )
            ],
          )
        ],
      ),
    );
  }

  //弹窗
  _ShowModel(String title, String content) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text((content)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("关闭"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '查找结果                                       ',
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
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: <Widget>[new Container()],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(int.parse(color1))
          ),
          child: ListView(
            children: <Widget>[
              _load_data()
            ],
          ),
        ));
  }

}
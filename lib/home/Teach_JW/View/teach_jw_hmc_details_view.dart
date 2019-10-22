import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/course/Ui_course2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class teach_jw_hmc_details_view extends StatefulWidget{
  final List list;

  const teach_jw_hmc_details_view({Key key, this.list}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_jw_hmc_details_view_view(list);
  }

}

class teach_jw_hmc_details_view_view extends State<teach_jw_hmc_details_view>{
  List list=[];

  teach_jw_hmc_details_view_view(List list){
    this.list=list;
  }

  Widget head_text(String text){
    return new Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), ScreenUtil().setHeight(15), ScreenUtil().setWidth(15), ScreenUtil().setHeight(15)),
      height: ScreenUtil().setHeight(100),
      width: ScreenUtil().setWidth(180),
      child: Text(text,style: TextStyle(color:Colors.green,fontSize: ScreenUtil().setSp(30)),textAlign: TextAlign.center,),
    );
  }

  Widget course_Card(String text){
    return new GestureDetector(
      onTap: (){
        if(text.length==1){
          return;
        }
        //_ShowModel(list[0].toString().split(':')[1].replaceAll('}', ''), text);
      },
      child: new Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), ScreenUtil().setHeight(15), ScreenUtil().setWidth(15), ScreenUtil().setHeight(15)),
        height: ScreenUtil().setHeight(200),
        width: ScreenUtil().setWidth(180),
        child: Text(text,style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(int.parse(color2))),textAlign: TextAlign.center,),
      ),
    );
  }

  Widget _load_data() {
    List<Widget>list_ui=[];
    for(int i=0;i<list.length;i++){
      List list2=json.decode(json.encode(list[i]));
      list_ui.add(
        Container(
          child: Row(
            children: <Widget>[
              //course_Card(list2[0].toString().split(':')[1].replaceAll('}', '')),
              //course_Card(list2[1].toString().split(':')[1].replaceAll('}', '')),
              course_Card(list2[2].toString().split(':')[1].replaceAll('}', '')),
              //course_Card(list2[3].toString().split(':')[1].replaceAll('}', '')),
              course_Card(list2[4].toString().split(':')[1].replaceAll('}', '')),
              course_Card(list2[5].toString().split(':')[1].replaceAll('}', '')),
              course_Card(list2[6].toString().split(':')[1].replaceAll('}', '')),
              course_Card(list2[7].toString().split(':')[1].replaceAll('}', '')),
            ],
          ),
        )
      );
    }
    return Container(
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          new Column(
            children: [
              Expanded(
                child: Row(
                  children: <Widget>[
                    //head_text('序号'),
                    //head_text('单位名称'),
                    head_text('专业名称'),
                    //head_text('当前年级'),
                    head_text('班级'),
                    head_text('学号'),
                    head_text('姓名'),
                    head_text('性别'),
                  ],
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  width: ScreenUtil().setWidth(1060),
                  child: ListView(
                    children: list_ui,
                  ),
                ),
                flex: 11,
              )
            ],
          ),
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
          child: _load_data(),
        ));
  }

}
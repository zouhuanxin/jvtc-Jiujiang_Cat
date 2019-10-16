
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_course_sgin/View/teach_create_class_view.dart';
import 'package:flutter_app01/home/Teach_course_sgin/ViewModel/teach_view_main_viewmodel.dart';
import 'package:flutter_app01/home/competition/competition_release.dart';
import 'package:provide/provide.dart';

class teach_class_view extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_class_view_State();
  }

}

class teach_class_view_State extends State<teach_class_view>{

  //班级卡片
  Widget card (){
   return new Container(
     child: Card(
       child: Container(
         padding: EdgeInsets.all(10),
         child: Column(
           children: <Widget>[
             Align(child: Text('移动互联1701',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),alignment: Alignment.topLeft,),
             Align(child: Text('任课老师:毕传林',style: TextStyle(fontWeight: FontWeight.w200,fontSize: 12,color: Colors.black38),),alignment: Alignment.topLeft,),
             Align(child: Text('课程名称:安卓基础开发',style: TextStyle(fontWeight: FontWeight.w200,fontSize: 12,color: Colors.black38),),alignment: Alignment.topLeft,),
             Align(child: Text('班级人数:37人',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12,color: Colors.black38),),alignment: Alignment.topLeft,),
           ],
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
            '班级人员                                       ',
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
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) =>
              <PopupMenuItem<String>>[
                PopupMenuItem<String>(child: Text("创建班级"), value: "创建班级",),
              ],
              onSelected: (String action) {
                switch (action) {
                  case "创建班级":
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new teach_create_class_view()));
                    break;
                }
              },
              onCanceled: () {
               // print("onCanceled");
              },
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Color(int.parse(color1))
          ),
          child: new ListView(
            children: <Widget>[
              card(),
              card(),
              card(),
              card(),
              card(),
              card(),
              card(),
              card(),
              card(),
            ],
          ),
        ));
  }

}
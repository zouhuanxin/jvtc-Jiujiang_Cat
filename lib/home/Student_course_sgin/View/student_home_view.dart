import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Student_course_sgin/Model/student_home_model.dart';
import 'package:flutter_app01/home/Student_course_sgin/ViewModel/student_home_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class student_home_view extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return student_home_view_State();
  }

}

class student_home_view_State extends State<student_home_view>{
  var providers = Providers();

  void _loading() {
    var shm = student_home_model();
    var shv = student_home_viewmodel(shm,context);
    providers.provide(Provider<student_home_viewmodel>.value(shv));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProviderNode(
      providers: providers,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(
            '学生签到                                       ',
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
          actions: <Widget>[],
        ),
        body: new Container(
            decoration: BoxDecoration(color: Color(int.parse(color1))),
            child: Provide<student_home_viewmodel>(builder: (context,child,value){
              return ListView(
                padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(50)),
                children: [
                  Column(
                    children: value.list_ui,
                  )
                ],
              );
            })),
      ),
    );
  }

}
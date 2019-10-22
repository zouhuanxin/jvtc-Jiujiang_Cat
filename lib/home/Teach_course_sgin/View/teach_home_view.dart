import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Student_course_sgin/Model/student_home_model.dart';
import 'package:flutter_app01/home/Student_course_sgin/ViewModel/student_home_viewmodel.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/Model/teach_home_model.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/ViewModel/teach_home_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class teach_home_view extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_home_view_State();
  }

}

class teach_home_view_State extends State<teach_home_view>{
  var providers = Providers();

  void _loading() {
    var thm = teach_home_model();
    var thv = teach_home_viewmodel(thm,context);
    providers.provide(Provider<teach_home_viewmodel>.value(thv));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  @override
  void dispose() {
    super.dispose();
    bus.off("teach_details_view"); //移除广播机制
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProviderNode(
      providers: providers,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(
            '教师签到记录                                       ',
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
            child: Provide<teach_home_viewmodel>(builder: (context,child,value){
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
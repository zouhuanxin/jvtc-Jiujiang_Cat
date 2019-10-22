import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/course/Sgin/Model/Course_Sgin_Model.dart';
import 'package:flutter_app01/course/Sgin/ViewModel/Course_Sgin_ViewModel.dart';
import 'package:flutter_app01/course/Sgin/common_ui/course_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

class Course_Sgin_View extends StatefulWidget{
  final String str;

  const Course_Sgin_View({Key key, this.str}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Course_Sgin_View_State(str);
  }

}

class Course_Sgin_View_State extends State<Course_Sgin_View>{
  String str;
  Course_Sgin_View_State(String str){
    this.str=str;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  var providers = Providers();
  void _loading() {
    var csm = Course_Sgin_Model();
    var csv = Course_Sgin_ViewModel(csm,context,str);
    providers.provide(Provider<Course_Sgin_ViewModel>.value(csv));
  }

  Widget table(){
    return Provide<Course_Sgin_ViewModel>(builder: (context,child,value){
      return Column(
        children: value.list_ui,
      );
    });
  }

  Widget buildButton1() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child:
        Provide<Course_Sgin_ViewModel>(builder: (context, child, value) {
          return RaisedButton(
            textTheme: ButtonTextTheme.accent,
            colorBrightness: Brightness.dark,
            child: Text(
              value.buttontext,
              style: TextStyle(color: Colors.white),
            ),
            color: value.buttontext=='创建签到'?Colors.blue:Colors.red,
            onPressed: () {
              value.create_sgin();
            },
            shape: StadiumBorder(side: BorderSide()),
          );
        }),
      ),
    );
  }

  Widget password_input() {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.all(5.0),
      child: Provide<Course_Sgin_ViewModel>(
          builder: (context, child, value) {
            return TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: '如不需要设置密码不填即可',
                fillColor: Colors.white,
                filled: dart_model,
                contentPadding:
                EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
              ),
              textAlign: TextAlign.start,
              onChanged: (T) {
                value.set_sgin_pass(T);
              },
              autofocus: false,
            );
          }),
    );
  }

  Widget coursename_input() {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.all(5.0),
      child: Provide<Course_Sgin_ViewModel>(
          builder: (context, child, value) {
            return TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: '课程名',
                fillColor: Colors.white,
                filled: dart_model,
                contentPadding:
                EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
              ),
              textAlign: TextAlign.start,
              onChanged: (T) {
                value.set_course_name(T);
              },
              autofocus: false,
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProviderNode(
      providers: providers,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(
            '创建签到                                       ',
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
            child: Column(
              children: <Widget>[
                Expanded(child: Row(
                  children: <Widget>[
                    course_ui.head_text('序号'),
                    course_ui.head_text('专业名称'),
                    course_ui.head_text('当前年级'),
                    course_ui.head_text('学号'),
                    course_ui.head_text('姓名'),
                  ],
                ),flex: 1,),
                Expanded(child: new ListView(children: [table()],),flex: 6,),
                Expanded(child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: ScreenUtil().setHeight(20),),
//                      Align(
//                        alignment: Alignment.topLeft,
//                        child: Text(
//                          '   签到课程名',
//                          style: TextStyle(
//                              color: Color(int.parse(color2)),
//                              fontSize: 16,
//                              fontWeight: FontWeight.w600,
//                              fontStyle: FontStyle.normal),
//                        ),
//                      ),
//                      coursename_input(),
                      SizedBox(height: ScreenUtil().setHeight(20),),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '   请设置签到密码',
                          style: TextStyle(
                              color: Color(int.parse(color2)),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      password_input(),
                      SizedBox(height: ScreenUtil().setHeight(20),),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '   请确认学生信息无误',
                          style: TextStyle(
                              color: Color(int.parse(color2)),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(80),),
                      buildButton1()
                    ],
                  ),
                ),flex: 6,)
              ],
            )),
      ),
    );
  }

}
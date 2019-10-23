import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/course/Sgin/Model/Course_EndSgin_Model.dart';
import 'package:flutter_app01/course/Sgin/ViewModel/Course_EndSgin_ViewModel.dart';
import 'package:flutter_app01/course/Sgin/common_ui/course_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class Course_EndSgin_View extends StatefulWidget{
  final String str;

  const Course_EndSgin_View({Key key, this.str}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Course_EndSgin_View_State(str);
  }

}

class Course_EndSgin_View_State extends State<Course_EndSgin_View>{
  String str;
  Course_EndSgin_View_State(String str){
    this.str=str;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  var providers = Providers();
  Course_EndSgin_Model cem;
  Course_EndSgin_ViewModel cev;
  void _loading() {
    cem = Course_EndSgin_Model();
    cev = Course_EndSgin_ViewModel(cem,context,str);
    providers.provide(Provider<Course_EndSgin_ViewModel>.value(cev));
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cev.time_colse();
  }

  Widget buildButton1() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child:
        Provide<Course_EndSgin_ViewModel>(builder: (context, child, value) {
          return RaisedButton(
            textTheme: ButtonTextTheme.accent,
            colorBrightness: Brightness.dark,
            child: Text(
              '结束签到',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
            onPressed: () {
              value.end_sgin();
            },
            shape: StadiumBorder(side: BorderSide()),
          );
        }),
      ),
    );
  }

  Widget table(){
    return Provide<Course_EndSgin_ViewModel>(builder: (context,child,value){
      return Column(
        children: value.list_ui,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WillPopScope(
      child: ProviderNode(
        providers: providers,
        child: Scaffold(
          appBar: PreferredSize(child: new Offstage(
            offstage: true,
            child: new AppBar(
              title: new Text('结束签到                                       ',
                textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
              elevation: 0.0,
              iconTheme: IconThemeData(color: Color(int.parse(color2))),
              backgroundColor: Color(int.parse(color1)),
              centerTitle: true,
              leading: Builder(
                builder: (BuildContext context) {
                  return Text('');
                },
              ),
              actions: <Widget>[
                new Container()
              ],
            ),
          ), preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),),
          body: new Container(
              decoration: BoxDecoration(color: Color(int.parse(color1))),
              child: Column(
                children: <Widget>[
                  SizedBox(height: ScreenUtil().setHeight(50),),
                  Expanded(child: new Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(child: course_ui.head_text('学号'),flex: 1,),
                        Expanded(child: course_ui.head_text('姓名'),flex: 1,),
                        Expanded(child: course_ui.head_text('状态'),flex: 1,),
                      ],
                    ),
                  ),flex: 1,),
                  Expanded(child: new ListView(children: [table()],),flex: 4,),
                  Expanded(child: new ListView(children: [
                    Provide<Course_EndSgin_ViewModel>(builder: (context,child,value){
                      return Row(
                        children: <Widget>[
                          Expanded(child: course_ui.head_text('已签到人数:'+value.finish_number.toString()),flex: 1,),
                          Expanded(child: course_ui.head_text('未签到人数:'+value.unfinish_number.toString()),flex: 1,),
                        ],
                      );
                    })
                  ],),flex: 1,),
                  Expanded(child: new Column(children: [
                    SizedBox(height: ScreenUtil().setHeight(80),),
                    buildButton1()
                  ],),flex: 3,),
                ],
              )),
        ),
      ), onWillPop: (){

    }
    );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Student_course_sgin/Model/student_home_model.dart';
import 'package:flutter_app01/home/Student_course_sgin/ViewModel/student_home_viewmodel.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/Model/teach_home_model.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/ViewModel/teach_home_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class teach_home_view extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_home_view_State();
  }
}

class teach_home_view_State extends State<teach_home_view> {
  var providers = Providers();

  void _loading() {
    var thm = teach_home_model();
    var thv = teach_home_viewmodel(thm, context);
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

  Widget drop(){
    return Provide<teach_home_viewmodel>(builder: (context,child,value){
      return new Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setHeight(25)),
        child: new Align(
          alignment: Alignment.topCenter,
          child: DropdownButton(
            items: value.drop_items,
            hint: new Text('请选择', textAlign: TextAlign.center),
            //当没有默认值的时候可以设置的提示
            value: value.course_name,
            //下拉菜单选择完之后显示给用户的值
            onChanged: (T) {
              value.set_coursename(T);
            },
            elevation: 20,
            underline: Container(),
            //设置阴影的高度
            style: new TextStyle(
              //设置文本框里面文字的样式
                color: Colors.black),
            isDense: false,
            iconSize: 20.0, //设置三角标icon的大小
          ),
        ),
      );
    });
  }

  //搜索框
  Widget search_input() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setHeight(30)),
      height: ScreenUtil().setHeight(130),
      child: Provide<teach_home_viewmodel>(builder: (context, child, value) {
        return TextField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '学生学号',
            border: OutlineInputBorder(),
            fillColor: Colors.white,
            filled: dart_model,
            contentPadding: EdgeInsets.all(10.0),
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.blue,
                ),
                onPressed: () {
                  value.search_table();
                }),
          ),
          textAlign: TextAlign.start,
          onChanged: (T) {
            value.set_input1(T);
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
            child:
                Provide<teach_home_viewmodel>(builder: (context, child, value) {
              return ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setHeight(50)),
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(child: drop(),flex: 1,),
                      Expanded(child: search_input(),flex: 3,),
                    ],
                  ),
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

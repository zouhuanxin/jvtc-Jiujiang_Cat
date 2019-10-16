
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_course_sgin/Model/teach_create_class_model.dart';
import 'package:flutter_app01/home/Teach_course_sgin/ViewModel/teach_create_class_viewmodel.dart';
import 'package:flutter_app01/home/Teach_course_sgin/ViewModel/teach_view_main_viewmodel.dart';
import 'package:flutter_app01/home/competition/competition_release.dart';
import 'package:provide/provide.dart';

class teach_create_class_view extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_create_class_view_State();
  }

}

class teach_create_class_view_State extends State<teach_create_class_view>{
  var providers = Providers();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    teach_create_class_model tccm=teach_create_class_model();
    var tccv= teach_create_class_viewmodel(tccm);
    providers.provide(Provider<teach_create_class_viewmodel>.value(tccv));
  }

  //班级名称输入框
  Widget classname_input() {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.all(5.0),
      child: Provide<teach_create_class_viewmodel>(builder: (context,child,value){
        return TextField(
          maxLines: 1,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 0)),
          textAlign: TextAlign.start,
          onChanged: (T) {
            value.set_class_name(T);
          },
          autofocus: false,
        );
      }),
    );
  }

  //班级学院选择框
  Widget drop() {
    return new Align(
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              '分类',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(int.parse(color2))),
            ),
            flex: 1,
          ),
          Expanded(
            child: Provide<teach_create_class_viewmodel>(builder:(context,child,value){
              return DropdownButton(
                items: value.items,
                hint: new Text('请选择', textAlign: TextAlign.center),
                //当没有默认值的时候可以设置的提示
                value: value.class_college,
                //下拉菜单选择完之后显示给用户的值
                onChanged: (T) {
                  value.set_class_college(T);
                },
                elevation: 20,
                underline: Container(),
                //设置阴影的高度
                style: new TextStyle(
                  //设置文本框里面文字的样式
                    color: Colors.black),
                isDense: false,
                iconSize: 20.0, //设置三角标icon的大小
              );
            } ),
            flex: 1,
          )
        ],
      ),
    );
  }

  //任课老师姓名输入框
  Widget class_teachname_input() {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.all(5.0),
      child: Provide<teach_create_class_viewmodel>(builder: (context,child,value){
        return TextField(
          maxLines: 1,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 0)),
          textAlign: TextAlign.start,
          onChanged: (T) {
            value.set_class_teachname(T);
          },
          autofocus: false,
        );
      })
    );
  }

  //创建班级按钮
  Align buildSubmitButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: Provide<teach_create_class_viewmodel>(builder: (context,child,value){
          return RaisedButton(
            child: Text(
              '创建班级',
              style: TextStyle(color: Color(int.parse(color1))),
            ),
            color: Color(int.parse(color2)),
            onPressed: () {
              value.Submit();
            },
            shape: StadiumBorder(side: BorderSide()),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //顶层依赖
    return ProviderNode(
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text(
              '创建班级                                       ',
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
          ),
          body: Container(
            decoration: BoxDecoration(
                color: Color(int.parse(color1))
            ),
            child: new ListView(
              children: <Widget>[
                Text(
                  '   班级名称',
                  style: TextStyle(
                      color: Color(int.parse(color2)),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal),
                ),
                classname_input(),
                Text(
                  '   班级学院',
                  style: TextStyle(
                      color: Color(int.parse(color2)),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal),
                ),
                drop(),
                Text(
                  '   任课老师',
                  style: TextStyle(
                      color: Color(int.parse(color2)),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal),
                ),
                classname_input(),
                SizedBox(height: 30,),
                buildSubmitButton(),
                SizedBox(height: 20,),
              ],
            ),
          )),
        providers: providers
    );
  }

}
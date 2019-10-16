
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_course_sgin/ViewModel/teach_view_main_viewmodel.dart';
import 'package:provide/provide.dart';

class teach_view_main extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_view_main_State();
  }

}

class teach_view_main_State extends State<teach_view_main>{
  var tvmv= teach_view_main_viewmodel();
  var providers = Providers();

  void loading(){
    //将teach_view_main_viewmodel对象添加进providers
    providers.provide(Provider<teach_view_main_viewmodel>.value(tvmv));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProviderNode(
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                '上课签到                                       ',
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
            body: Container(
              decoration: BoxDecoration(
                color: Color(int.parse(color1))
              ),
              child: new ListView(
                children: <Widget>[
                  Provide<teach_view_main_viewmodel>(
                    builder: (context,child,tvmv){
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Text(tvmv.list.toString()),
                            RaisedButton(
                              child: Text('点击'),
                              onPressed: (){
                                tvmv.search_sgin_class();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            )),
        providers: providers
    );
  }

}
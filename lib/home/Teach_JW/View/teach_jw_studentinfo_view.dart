
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_studentinfo_model.dart';
import 'package:flutter_app01/home/Teach_JW/ViewModel/teach_jw_studentinfo_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class teach_jw_studentinfo_view extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_jw_studentinfo_view_State();
  }

}

class teach_jw_studentinfo_view_State extends State<teach_jw_studentinfo_view>{
  var providers = Providers();
  void _loading() {
    var tjsm = teach_jw_studentinfo_model();
    var tjsv = teach_jw_studentinfo_viewmodel(tjsm);
    providers.provide(Provider<teach_jw_studentinfo_viewmodel>.value(tjsv));
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
            '学生基本信息查询                                       ',
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
        body: new Container(
          decoration: BoxDecoration(color: Color(int.parse(color1))),
          child: ListView(
            padding:
            EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(50)),
            children: <Widget>[

            ],
          ),
        ),
      ),
    );
  }

}
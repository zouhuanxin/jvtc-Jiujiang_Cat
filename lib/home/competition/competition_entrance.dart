import 'dart:async';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter_app01/Bean/competition_type.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/my/SMS_password.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'competition_details.dart';
import 'competition_person.dart';
import 'competition_release.dart';

class competition_entrance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return competition_entrance_State();
  }
}

class competition_entrance_State extends State<competition_entrance> {
  List<Widget> allui = [];
  List<competition_type> sfs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bmob_get_information();
  }

  void _bmob_get_information() {
    sfs.clear();
//    competition_type ct=competition_type();
//    ct.text='报名参赛';
//    ct.color='0xff000000';
//    allui.add(buildButton01(ct));
//    ct=competition_type();
//    ct.text='个人作品';
//    ct.color='0xff000000';
//    allui.add(buildButton01(ct));
    BmobQuery<competition_type> query = BmobQuery();
    query.addWhereEqualTo("vis", "true");
    query.queryObjects().then((data) {
      sfs = data.map((i) => competition_type.fromJson(i)).toList();
      for (competition_type sf in sfs) {
        if (sf != null) {
          setState(() {
            allui.add(buildButton01(sf));
          });
        }
      }
    }).catchError((e) {});
  }

  Widget buildButton01(competition_type ct) {
    return Align(
      alignment: Alignment.center,
      child: new Container(
        margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
        width: ScreenUtil().setWidth(1000),
        child: RaisedButton(
          textTheme: ButtonTextTheme.accent,
          color: Color(int.parse(ct.color)),
          highlightColor: Colors.deepPurpleAccent,
          splashColor: Colors.yellow,
          colorBrightness: Brightness.dark,
          elevation: 50.0,
          highlightElevation: 100.0,
          disabledElevation: 20.0,
          onPressed: () {
            if(ct.text=='报名参赛'){
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new competition_release()));
            }else if(ct.text=='个人作品'){
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new competition_person()));
            }else{
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new competition_details(
                        ct: ct,
                      )));
            }
          },
          child: Column(
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(20),),
              Text(
                ct.text,
                style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(60),fontWeight: FontWeight.w500),
              ),
              Text(
                ct.introduce,
                overflow: TextOverflow.ellipsis,
                maxLines: 7,
                style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(30)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '活动项目                                       ',
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
          child: new Container(
            child: new ListView(
              children: <Widget>[
                new Column(
                  children: allui,
                )
              ],
            ),
          ),
        ));
  }
}

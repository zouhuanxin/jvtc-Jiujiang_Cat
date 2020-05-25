import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta/meta.dart';
import 'package:flutter_app01/Learn_teach/learn_teach.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter_app01/Bean/lunbo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';

class dormitory_knowing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => dormitory_knowing_State();
}

class dormitory_knowing_State extends State<dormitory_knowing> {
  //paging value
  num now_page = 1;
  num sum_page = 0;
  num page_nmber = 100;
  num now_loading_entry_sum = 100;

  num hongbang = 0, baibang = 0, anquan = 0;

  Widget head_card() {
    for (int i = 0; i < dormitory_knowing_list.length; i++) {
      Map<String, Object> tempmap =
          json.decode(json.encode(dormitory_knowing_list[i]));
      if (tempmap['grade'] == '红榜寝室') {
        hongbang++;
      } else if (tempmap['grade'] == '白榜寝室') {
        baibang++;
      } else {
        anquan++;
      }
    }
    return new Container(
      height: ScreenUtil().setHeight(60),
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '红榜' + hongbang.toString(),
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                flex: 1,
              ),
              Expanded(
                child: Text(
                  '白榜' + baibang.toString(),
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                flex: 1,
              ),
              Expanded(
                child: Text(
                  '安全' + anquan.toString(),
                  style: TextStyle(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                flex: 1,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget activity_eevaluation_Card() {
    return new Container(
      child: new Column(
        children: dormitory_knowing_ui_list,
      ),
    );
  }

  List<Widget> dormitory_knowing_ui_list = [];

  void _loading_dormitory_knowing_ui() {
    dormitory_knowing_ui_list.clear();
    if (dormitory_knowing_list.length > page_nmber) {
      sum_page = (dormitory_knowing_list.length / page_nmber);
      sum_page = int.parse(sum_page.toString().split('.')[0]);
      if (dormitory_knowing_list.length % page_nmber != 0) {
        sum_page++;
      }
    } else {
      sum_page = 1;
    }
    var i = (now_page - 1) * page_nmber;
    if (now_page == sum_page) {
      now_loading_entry_sum = dormitory_knowing_list.length;
    } else {
      now_loading_entry_sum = page_nmber * now_page;
    }
    for (i; i < now_loading_entry_sum; i++) {
      Map<String, Object> tempmap =
          json.decode(json.encode(dormitory_knowing_list[i]));
      dormitory_knowing_ui_list.add(Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Color(int.parse(color4)),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        margin: EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Text('宿舍', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(
                    tempmap == null ? '' : tempmap['dorm'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('分数', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(
                    tempmap == null ? '' : tempmap['score'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('状态', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(
                    tempmap == null ? '' : tempmap['grade'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: tempmap['grade'] == '红榜寝室'
                            ? Colors.blue
                            : tempmap['grade'] == '白榜寝室'
                                ? Colors.red
                                : Colors.black),
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('来源', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(
                    tempmap == null ? '' : tempmap['source'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('时间', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(
                    tempmap == null ? '' : tempmap['time'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                new Text('周次', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(
                    tempmap == null ? '' : tempmap['week'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
    }
  }

  Widget paging_component() {
    return new Container(
      child: new Row(
        children: <Widget>[
          new Container(
            child: Expanded(
              child: new RaisedButton(
                onPressed: () {
                  if (now_page > 1) {
                    setState(() {
                      now_page--;
                      _loading_dormitory_knowing_ui();
                    });
                  }
                },
                color: Color(int.parse(color2)),
                child: new Text(
                  '上一页',
                  style: TextStyle(color: Color(int.parse(color1))),
                ),
              ),
              flex: 1,
            ),
          ),
          new Container(
            child: Expanded(
              child: new Text('$now_page/$sum_page',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(int.parse(color2)))),
              flex: 1,
            ),
          ),
          new Container(
            child: Expanded(
              child: new RaisedButton(
                onPressed: () {
                  if (now_page < sum_page) {
                    setState(() {
                      now_page++;
                      _loading_dormitory_knowing_ui();
                    });
                  }
                },
                color: Color(int.parse(color2)),
                child: new Text('下一页',
                    style: TextStyle(color: Color(int.parse(color1)))),
              ),
              flex: 1,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '查寝列表                                       ',
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
          child: new ListView(
            padding: EdgeInsets.all(10.0),
            children: <Widget>[
              head_card(),
              activity_eevaluation_Card(),
              paging_component(),
            ],
          ),
        ));
  }

  List<dynamic> dormitory_knowing_list = [];
  var login_number = 0;

  void _get_Activity_evaluation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str1 = await HttpUtil.xg_query_activity_info(
        'StuEnlightenRoomScore', prefs.getString('xgtoken'));
    if (int.parse(json.decode(str1)['code'].toString()) == 0) {
      //Successful request , token vaild
      dormitory_knowing_list =
          json.decode(json.encode(json.decode(str1)['data']));
    } else if (login_number < 1) {
      //Failed request , token invaild
      //Exit this screen and log in agein
      login_number = 1;
      if (await HttpUtil.Automatic_landing() == '0') {
        _get_Activity_evaluation();
      } else {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
    setState(() {
      _loading_dormitory_knowing_ui();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _get_Activity_evaluation();
  }
}

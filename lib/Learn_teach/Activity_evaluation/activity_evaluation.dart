import 'package:flutter/material.dart';
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

class activity_evaluation extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>activity_evaluation_State();
}

class activity_evaluation_State extends State<activity_evaluation>{

  //paging value
  num now_page=1;
  num sum_page=0;
  num page_nmber=10;
  num now_loading_entry_sum=10;

  Widget activity_eevaluation_Card(){
    return new Container(
      child: new Column(
        children: activity_evaluation_ui_list,
      ),
    );
  }

  List<Widget>activity_evaluation_ui_list=[];
  List<Map<String,Object>>activity_evaluation_map_list=[];
  void _loading_activity_evaluation_ui(){
    activity_evaluation_ui_list.clear();
    if(activity_evaluation_list.length>10){
      sum_page=(activity_evaluation_list.length/10);
      sum_page=int.parse(sum_page.toString().split('.')[0]);
      if(activity_evaluation_list.length%10!=0){
        sum_page++;
      }
    }else{
      sum_page=1;
    }
    var i=(now_page-1)*10;
    if(now_page==sum_page){
      now_loading_entry_sum=activity_evaluation_list.length;
    }else{
      now_loading_entry_sum=10*now_page;
    }
    for(i;i<now_loading_entry_sum;i++){
      Map<String,Object> tempmap=json.decode(json.encode(activity_evaluation_list[i]));
      activity_evaluation_map_list.add(tempmap);
      activity_evaluation_ui_list.add(Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Color(int.parse(color4)),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        margin: EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Text('活动名称',textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap==null?'':tempmap['name'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('活动时间',textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap==null?'':tempmap['date'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('活动类型',textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap==null?'':tempmap['type'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('素拓分',textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap==null?'':tempmap['score'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('申请单位',textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap==null?'':tempmap['unit'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                ),
                new Text('状态',textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap==null?'':tempmap['stat'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: new GestureDetector(
                    onTap: (){_activity_evaluation(tempmap['id']);},
                    child: new Text(tempmap==null?'':
                    (tempmap['stat']=='未评价，点击评价'||tempmap['stat']=='未评价,点击评价'?'点击评价':''),textAlign: TextAlign.center,
                      style: TextStyle(color: tempmap==null?Colors.black26:
                      (tempmap['stat']=='未评价，点击评价'||tempmap['stat']=='未评价,点击评价'?Colors.blue:Colors.black26)),)
                  ),
                )
              ],
            )
          ],
        ),
      ));
    }
  }

  void _activity_evaluation(id) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String str1=await HttpUtil.xg_query_activity_evaluation('AppAction',id, sharedPreferences.getStringList('xgtoken'));
    if(int.parse(json.decode(str1)['code'].toString())==0){
      Fluttertoast.showToast(
          msg: "评价成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      _get_Activity_evaluation();
    }else{
      Fluttertoast.showToast(
          msg: "评价失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  Widget paging_component(){
    return new Container(
      child: new Row(
        children: <Widget>[
          new Container(
            child: Expanded(child: new RaisedButton(onPressed:(){
              if(now_page>1){
                setState(() {
                  now_page--;
                  _loading_activity_evaluation_ui();
                });
              }
            },color: Color(int.parse(color2)),child: new Text('上一页',style: TextStyle(color: Color(int.parse(color1))),),),flex: 1,),
          ),
          new Container(
            child: Expanded(child: new Text('$now_page/$sum_page',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),flex: 1,),
          ),
          new Container(
            child: Expanded(child: new RaisedButton(onPressed: (){
              if(now_page<sum_page){
                setState(() {
                  now_page++;
                  _loading_activity_evaluation_ui();
                });
              }
            },color: Color(int.parse(color2)),child: new Text('下一页',style: TextStyle(color: Color(int.parse(color1)))),),flex: 1,),
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
          title: new Text('活动评价                                       ',
            textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Color(int.parse(color2))),
          backgroundColor: Color(int.parse(color1)),
          centerTitle: true,
          actions: <Widget>[
            new Container()
          ],
        ),
        body: new Container(
          decoration: BoxDecoration(
            color: Color(int.parse(color1)),
          ),
          child: new ListView(
            padding: EdgeInsets.all(10.0),
            children: <Widget>[
              activity_eevaluation_Card(),
              paging_component(),
            ],
          ),
        )
    );
  }

  List<dynamic> activity_evaluation_list=[];
  var login_number=0;
  void _get_Activity_evaluation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str1=await HttpUtil.xg_query_activity_info('getStuActive', prefs.getString('xgtoken'));
    if(int.parse(json.decode(str1)['code'].toString())==0){
      //Successful request , token vaild
      activity_evaluation_list=json.decode(json.encode(json.decode(str1)['data']));
    }else if(login_number<1){
      //Failed request , token invaild
      //Exit this screen and log in agein
      login_number=1;
      if(await HttpUtil.Automatic_landing()=='0'){
        _get_Activity_evaluation();
      }else{
        Navigator.pop(context);
      }
    }else{
      Navigator.pop(context);
    }
    setState(() {
      _loading_activity_evaluation_ui();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _get_Activity_evaluation();
  }

}
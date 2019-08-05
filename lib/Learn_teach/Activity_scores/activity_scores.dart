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

class activity_scores extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>activity_scores_State();

}

class activity_scores_State extends State<activity_scores>{

  Map<String,Object> activity_data_map=null;

  Widget table1(){
    return new Container(
      child: new Column(
        children: <Widget>[
          Text('我的素拓得分',style: TextStyle(fontSize: 18,color: Color(int.parse(color2))),),
          SizedBox(height: 10,),
          Table(
            //表格边框样式
            border: TableBorder.all(
              color: Colors.black12,
              width: 2.0,
              style: BorderStyle.solid,
            ),
            children: [
              TableRow(
                  children: [
                    Text('思想政治与道德修养',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(activity_data_map==null?'':activity_data_map['CountA1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('社会实践与志愿服务',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(activity_data_map==null?'':activity_data_map['CountB1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('学术科技与创新创业',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(activity_data_map==null?'':activity_data_map['CountC1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('文化艺术与身心发展',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(activity_data_map==null?'':activity_data_map['CountD1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('社团活动与社会工作',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(activity_data_map==null?'':activity_data_map['CountE1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('技能培训与继续教育',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(activity_data_map==null?'':activity_data_map['CountF1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('素拓总分',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(activity_data_map==null?'':activity_data_map['SunCount1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('结论',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(activity_data_map==null?'':activity_data_map['Status'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
            ],
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('我的素拓得分                                       ',
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
              table1(),
            ],
          ),
        )
    );
  }

  var login_number=0;
  void _query_individual_activity_score() async{
    //{"code":0,"message":null,"data":{"CountA1":"-9.000","CountB1":"4.000",
    // "CountC1":"0.000","CountD1":"4.300","CountE1":"6.000","CountF1":"0.000","SunCount1":"5.300","Status":"总分不足。"}}
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Local no data
    //send a request to the server
    String str1=await HttpUtil.xg_query_activity_score_info('MyActionGetNum', prefs.getString('xgtoken'));
    if(int.parse(json.decode(str1)['code'].toString().trim())==0){
      //Successful request , token vaild
      activity_data_map=json.decode(json.encode(json.decode(str1)['data']));
    }else if(login_number<1){
      //Failed request , token invaild
      //Exit this screen and log in agein
      login_number=1;
      if(await HttpUtil.Automatic_landing()=='0'){
        _query_individual_activity_score();
      }else{
        Navigator.pop(context);
      }
    }else{
      Navigator.pop(context);
    }
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _query_individual_activity_score();
  }

}
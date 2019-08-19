import 'dart:convert';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/System_Notice.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app01/Utils/WebViewPage.dart';

class System_notice extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => System_notice_State();

}

class System_notice_State extends State<System_notice>{
  List<System_Notice>_list=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bmob_get_System_Notice_information();
  }

  void _bmob_get_System_Notice_information(){
    BmobQuery<System_Notice> query = BmobQuery();
    query.addWhereNotEqualTo("imageurl", "12%%%3");
    query.queryObjects().then((data) {
      _list.clear();
      _list = data.map((i) => System_Notice.fromJson(i)).toList();
      _loading_ui();
    }).catchError((e) {
      _showmodel('获取通知信息失败', Toast.LENGTH_SHORT);
    });
  }

  void _showmodel(String mes, var type) {
    Fluttertoast.showToast(
        msg: mes,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Widget System_Notice_Card(){
    return new Container(
      child: new Column(
        children: System_Notice_ui_list,
      ),
    );
  }

  List<Widget>System_Notice_ui_list=[];
  void _loading_ui(){
    System_Notice_ui_list.clear();
    for(var i=0;i<_list.length;i++){
      Map<String,Object> tempmap=json.decode(json.encode(_list[i]));
      System_Notice_ui_list.add(Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Color(int.parse(color4)),
            border: new Border.all(width: 1.0, color: Color(int.parse(tempmap['level']))),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        margin: EdgeInsets.all(10.0),
        child: new GestureDetector(
          onTap: (){
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new WebViewPage(url:tempmap['url'],title:tempmap['title'])));
          },
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: new Text(tempmap==null?'':tempmap['title'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.w400),),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              new Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: new Text(tempmap==null?'':tempmap['content'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              new Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: new Text(tempmap==null?'':tempmap['author'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10,
                        fontWeight: FontWeight.w200),),
                  ),
                  Expanded(
                    flex: 1,
                    child: new Text(tempmap==null?'':tempmap['createdAt'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10,
                        fontWeight: FontWeight.w200),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('系统通知                                       ',
          textAlign:TextAlign.left,style: TextStyle(color:  Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(int.parse(color2))),
        backgroundColor: Color(int.parse(color1)),
        centerTitle: true,
      ),
      body: new Container(
        decoration: BoxDecoration(
            color: Color(int.parse(color1))
        ),
        child: new ListView(
          children: <Widget>[
            System_Notice_Card()
          ],
        ),
      ),
    );
  }

}
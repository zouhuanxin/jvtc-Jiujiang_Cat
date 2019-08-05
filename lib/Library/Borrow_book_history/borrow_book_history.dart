import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';

class borrow_book_history extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => borrow_book_history_State();

}

class borrow_book_history_State extends State<borrow_book_history>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _query_history_book();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('借阅历史                                       ',
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
              table1()
            ],
          ),
        )
    );
  }

  List<Widget> borrow_book_history_list=[];
  List<dynamic>borrow_book_history_data=[];

  void _query_history_book() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String str1=await HttpUtil.library_book_history_query('tshistorylbinfo', sharedPreferences.getString('tscookie'));
    if(json.decode(str1)['code'].toString().trim()=='0'){
      borrow_book_history_data=json.decode(json.encode(json.decode(str1)['data']));
    }
    //print(borrow_book_history_data);
    loading_table1_data();
  }

  //183052776  200034
  Widget table1(){
    return new Container(
      child: new Column(
        children: borrow_book_history_list,
      ),
    );
  }

  void loading_table1_data(){
    for(var i=1;i<borrow_book_history_data.length;i++){
      Map<String,Object>tempmap=json.decode(json.encode(borrow_book_history_data[i]));
      borrow_book_history_list.add(
          Container(
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
                    new Text('序号',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td1'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                    new Text('条码号',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td2'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text('题名',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td3'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                    new Text('责任者',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td4'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text('借阅日期',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td5'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                    new Text('归还日期',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td6'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text('馆藏地',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td7'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                    new Text('',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text('',textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                )
              ],
            ),
          )
      );
    }
    setState(() {

    });
  }

}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';

class now_borrow_book extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => now_borrow_book_State();

}

class now_borrow_book_State extends State<now_borrow_book>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _query_now_borrow_book();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('当前借阅                                       ',
            textAlign:TextAlign.left,style: TextStyle( color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
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

  List<Widget> now_borrow_book_list=[];
  List<dynamic>now_borrow_book_data=[];

  void _query_now_borrow_book() async{
    now_borrow_book_data.clear();
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String str1=await HttpUtil.now_library_book_query('tsdqjyinfo', sharedPreferences.getString('tscookie'));
    if(json.decode(str1)['code'].toString().trim()=='0'){
      now_borrow_book_data=json.decode(json.encode(json.decode(str1)['data']));
    }
    //print(borrow_book_history_data);
    loading_table1_data();
  }

  //183052776  200034
  Widget table1(){
    return new Container(
      child: new Column(
        children: now_borrow_book_list,
      ),
    );
  }

  void loading_table1_data(){
    now_borrow_book_list.clear();
    for(var i=1;i<now_borrow_book_data.length;i++){
      Map<String,Object>tempmap=json.decode(json.encode(now_borrow_book_data[i]));
      now_borrow_book_list.add(
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
                    new Text('条码号',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td1'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                    new Text('题名/责任者',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td2'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text('续借量',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td3'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                    new Text('馆藏地',textAlign: TextAlign.center),
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
                    new Text('附件',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td7'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                    Expanded(
                      flex: 1,
                      child: new GestureDetector(
                        onTap: (){_renew_book(tempmap);},
                        child: new Text('点击续借',textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blue),),
                      ),
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

  //renew book interface
  void _renew_book(Map<String,Object>tempmap) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String str1=await HttpUtil.renew_book_query('tsxjinfo',tempmap['bar_code'],tempmap['check'],sharedPreferences.getString('verification_code'), sharedPreferences.getString('tscookie'));
    //print(str1);
    if(json.decode(str1)['code'].toString().trim()=='0'){

    }
    Fluttertoast.showToast(
        msg: json.decode(str1)['data'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}
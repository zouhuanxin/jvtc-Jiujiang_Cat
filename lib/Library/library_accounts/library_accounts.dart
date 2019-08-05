import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';

class library_accounts extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => library_accounts_State();

}

class library_accounts_State extends State<library_accounts>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _query_library_accounts();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('账目清单                                       ',
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

  List<Widget> library_accounts_list=[];
  List<dynamic> library_accounts_data=[];

  void _query_library_accounts() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String str1=await HttpUtil.library_accounts_query('tszmqdinfo', sharedPreferences.getString('tscookie'));
    if(json.decode(str1)['code'].toString().trim()=='0'){
      library_accounts_data=json.decode(json.encode(json.decode(str1)['data']));
    }
   // print(library_accounts_data);
    loading_table1_data();
  }

  //183052776  200034
  Widget table1(){
    return new Container(
      child: new Column(
        children: library_accounts_list,
      ),
    );
  }

  void loading_table1_data(){
    for(var i=1;i<library_accounts_data.length-1;i++){
      Map<String,Object>tempmap=json.decode(json.encode(library_accounts_data[i]));
      library_accounts_list.add(
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
                    new Text('结算时间',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td1'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    )
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text('结算项目',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td2'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                    new Text('退款',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td3'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                    new Text('缴款',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td4'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text('结算方式',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td5'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                    new Text('票据号',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['td6'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
              ],
            ),
          )
      );
    }
    setState(() {

    });
  }

}
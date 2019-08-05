import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/dataywwx.dart';
import 'package:flutter_app01/Bean/ksdjs.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Learn_teach/learn_teach.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter/services.dart';

class Countdown extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Countdown_State();

}

class Countdown_State extends State<Countdown>{
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  List<Widget>Countdown_ui_list=[];
  //paging value
  num now_page=1;
  num sum_page=0;
  num now_loading_sum=10;

  static const androidplatform = const MethodChannel("test");

  Widget paging_component(){
    return new Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 60),
      child: new Row(
        children: <Widget>[
          new Container(
            child: Expanded(child: new RaisedButton(onPressed:(){
              if(now_page>1){
                setState(() {
                  now_page--;
                  loading_table1_data();
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
                  loading_table1_data();
                });
              }
            },color: Color(int.parse(color2)),child: new Text('下一页',style: TextStyle(color: Color(int.parse(color1)))),),flex: 1,),
          )
        ],
      ),
    );
  }

  Widget table1(){
    return new Container(
      child: new Column(
        children: Countdown_ui_list,
      ),
    );
  }

  void loading_table1_data() async{
    Countdown_ui_list.clear();
    if(ksdjs_list.length>10){
      sum_page=(ksdjs_list.length/10);
      sum_page=int.parse(sum_page.toString().split('.')[0]);
      if(ksdjs_list.length%10!=0){
        sum_page++;
      }
    }else{
      sum_page=1;
    }
    var i=(now_page-1)*10;
    if(now_page==sum_page){
      now_loading_sum=ksdjs_list.length;
    }else{
      now_loading_sum=10*now_page;
    }
    for(i;i<now_loading_sum;i++){
      Map<String,Object>tempmap=json.decode(json.encode(ksdjs_list[i]));
      Countdown_ui_list.add(
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
                    new Text('项目名称',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap['proname']==null?'':tempmap['proname'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    )
                  ],
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: new Row(
                    children: <Widget>[
                      new Text('事件',textAlign: TextAlign.center),
                      Expanded(
                        flex: 1,
                        child: new Text(tempmap['content']==null?'':tempmap['content'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 5,),
                      ),
                    ],
                  ),
                ),
                new Row(
                  children: <Widget>[
                    new Text('剩余时间',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap['time']==null?'':await calculate_date(tempmap['time']),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,
                      style: TextStyle(color:Colors.blue),),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text('发布时间',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap['createdAt']==null?'':tempmap['createdAt'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new GestureDetector(
                    onTap: (){
                      showmodel(context, '系统提示', '你确定删除吗', tempmap);
                    },
                    child: Align(
                      child: new Text('删除',style: TextStyle(color: Colors.blue)),
                      alignment: FractionalOffset.bottomRight,
                    ),
                  ),
                )
              ],
            ),
          )
      );
    }
    setState(() {

    });
  }

  showmodel(BuildContext context,String title,String content,Map<String,Object>tempmap){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text((content)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("删除",style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteSingle(context,tempmap['objectId'],tempmap);
              },
            ),
          ],
        ));
  }

  List<ksdjs>ksdjs_list=[];
  void _query_all(){
    if(login_state==true){
      BmobQuery<ksdjs> query = BmobQuery();
      query.addWhereEqualTo("phone", phone);
      query.queryObjects().then((data) {
        ksdjs_list = data.map((i) => ksdjs.fromJson(i)).toList();
        loading_table1_data();
      }).catchError((e) {
        _Toastmodel(BmobError.convert(e).error, Colors.red);
      });
    }else{
      Toastmodel('请先登陆', Colors.red);
      Navigator.pop(context);
    }
  }

  void _Toastmodel(str,color){
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  String proname,content,time='到期日期';
  TextFormField buildnameTextField(BuildContext context) {
    return TextFormField(
      initialValue: proname,
      onSaved: (String value) => proname = value,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入事件名称';
        }
      },
      decoration: InputDecoration(
          labelText: '事件名称',
          labelStyle: TextStyle(color:Color(int.parse(color4))),
          fillColor: Colors.white,
          filled: dart_model,),
    );
  }

  Widget buildcontentTextField(BuildContext context) {
    return TextFormField(
      initialValue: content,
      maxLines: 5,
      onSaved: (String value) => content = value,
      validator: (String value) {
        if (value.isEmpty) {
          return '请填写事件描述';
        }
      },
      decoration: InputDecoration(
          labelText: '事件描述',
          labelStyle: TextStyle(color:Color(int.parse(color4))),
          fillColor: Colors.white,
          filled: dart_model,),
    );
  }

  Widget date_choose(){
    return new Container(
      child: RaisedButton(
        onPressed: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2018),
            lastDate: DateTime(2030),
          ).then((DateTime val) {
            time=val.toString().split(' ')[0].toString().split(' ')[0];
            Toastmodel('你选择了$time', Colors.blue);
          }).catchError((err) {
            print(err);
          });
        },
        color: Color(int.parse(color2)),
        textColor: Color(int.parse(color1)),
        child: Text(time),
        elevation: 5.0,
      ),
    );
  }

  calculate_date(str1) async{
    int str=await androidplatform.invokeMethod("daysBetween",{"str1":DateTime.now().toString().split(' ')[0].toString(),"str2":str1.toString()});
    if(str>=0){
      return '$str天';
    }else{
      return '已到期';
    }
  }
  
  Align buildFBButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
              '添加',
              style: TextStyle(color: Color(int.parse(color1)),)
          ),
          color: Color(int.parse(color2)),
          onPressed: () {
            if(login_state==true){
              if (_formKey2.currentState.validate()) {
                ///只有输入的内容符合要求通过才会到达此处
                _formKey2.currentState.save();
                _saveSingle(context);
              }
            }else{
              Toastmodel('登陆才可以添加哦', Colors.blue);
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  _saveSingle(BuildContext context) {
    ksdjs kj = ksdjs();
    kj.phone=phone;
    kj.name=username;
    kj.proname=proname;
    kj.time=time;
    kj.content=content;
    kj.save().then((BmobSaved bmobSaved) {
      _query_all();
      Toastmodel('添加成功', Colors.blue);
    }).catchError((e) {
      Toastmodel(BmobError.convert(e).error, Colors.red);
    });
  }

  _deleteSingle(BuildContext context,currentObjectId,Map<String,Object>tempmap) {
    if (currentObjectId != null) {
      ksdjs blog = ksdjs();
      blog.objectId = currentObjectId;
      blog.delete().then((BmobHandled bmobHandled) {
        currentObjectId = null;
        _query_all();
        Toastmodel('删除成功',Colors.blue);
      }).catchError((e) {
        Toastmodel(BmobError.convert(e).error,Colors.blue);
      });
    } else {
     // showError(context, "请先新增一条数据");
    }
  }

  void Toastmodel(str,color){
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('倒计时                                      ',
            textAlign:TextAlign.left,style: TextStyle( color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Color(int.parse(color2))),
          backgroundColor: Color(int.parse(color1)),
          centerTitle: true,
          actions: <Widget>[
            new Container()
          ],
        ),
        resizeToAvoidBottomPadding: true,
        floatingActionButton: new Builder(builder: (BuildContext context) {
          return new Container(
            margin: EdgeInsets.all(5.0),
            child: new FloatingActionButton(
              child: const Icon(Icons.add),
              tooltip: "Hello",
              foregroundColor: Color(int.parse(color1)),
              backgroundColor: Color(int.parse(color2)),
              heroTag: null,
              elevation: 7.0,
              highlightElevation: 14.0,
              onPressed: () {
                Scaffold.of(context).showSnackBar(new SnackBar(
                  duration:Duration(minutes: 10),
                  content: new Container(
                    height: 450,
                    child: Form(
                        key: _formKey2,
                        child:  new ListView(children: <Widget>[
                          buildnameTextField(context),
                          SizedBox(height: 10,),
                          buildcontentTextField(context),
                          SizedBox(height: 10,),
                          date_choose(),
                          SizedBox(height: 20,),
                          buildFBButton(context),
                        ],)),
                  ),
                  action: new SnackBarAction(
                      label: '返回',
                      onPressed: () {
                        //_query_all();
                      }
                  ),
                ));
              },
              mini: false,
              shape: new CircleBorder(),
              isExtended: false,
            ),
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: new Container(
          decoration: BoxDecoration(
            color: Color(int.parse(color1)),
          ),
          child: Form(
              key: _formKey,
              child:  new ListView(children: <Widget>[
                table1(),
                paging_component()
                ],)),
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _query_all();
  }

}
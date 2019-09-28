import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Repairinfo.dart';
import 'package:flutter_app01/Bean/czywwx.dart';
import 'package:flutter_app01/Bean/dataywwx.dart';
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
import 'package:url_launcher/url_launcher.dart';

class Obligation_to_repair extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Obligation_to_repair_State();

}

class Obligation_to_repair_State extends State<Obligation_to_repair>{
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var query_context;
  List<Widget>Obligation_to_repair_ui_list=[];
  //paging value
  num now_page=1;
  num sum_page=0;
  num now_loading_sum=10;

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

  Widget buildSearchTextField() {
    return new Container(
      margin: EdgeInsets.all(5.0),
      child: TextFormField(
        validator: (String value) {
          if(value.isEmpty){
            _query_all();
          }
        },
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: dart_model,
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    ///只有输入的内容符合要求通过才会到达此处
                    _formKey.currentState.save();
                    _query();
                  }
                })),
        onSaved: (String value) => query_context = value,
      ),
    );
  }

  Widget table1(){
    return new Container(
      child: new Column(
        children: Obligation_to_repair_ui_list,
      ),
    );
  }

  void loading_table1_data() async{
    Obligation_to_repair_ui_list.clear();
    if(dataywwx_list.length>10){
      sum_page=(dataywwx_list.length/10);
      sum_page=int.parse(sum_page.toString().split('.')[0]);
      if(dataywwx_list.length%10!=0){
        sum_page++;
      }
    }else{
      sum_page=1;
    }
    var i=(now_page-1)*10;
    if(now_page==sum_page){
      now_loading_sum=dataywwx_list.length;
    }else{
      now_loading_sum=10*now_page;
    }
    for(i;i<now_loading_sum;i++){
      Map<String,Object>tempmap=json.decode(json.encode(dataywwx_list[i]));
      Obligation_to_repair_ui_list.add(
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
                    new Text('用户昵称',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['name'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    )
                  ],
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: new Row(
                    children: <Widget>[
                      new Text('维修详情',textAlign: TextAlign.center),
                      Expanded(
                        flex: 1,
                        child: new Text(tempmap==null?'':tempmap['content'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 5,),
                      ),
                    ],
                  ),
                ),
                new Row(
                  children: <Widget>[
                    new Text('联系方式',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['contact'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text('发布时间',textAlign: TextAlign.center),
                    Expanded(
                      flex: 1,
                      child: new Text(tempmap==null?'':tempmap['createdAt'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new GestureDetector(
                    onTap: (){
                      if(login_state==false){
                        Toastmodel('请先登陆', Colors.red);
                      }else{
                        showmodel(context, '系统提示', '如果你选择帮助，我们将删除这个帖子。以便于其他人能得到帮助。'
                            '(如果对方留下的是qq号可以前往主页发起强制聊天功能)', tempmap);
                      }
                    },
                    child: Align(
                      child: new Text('帮助他/她',style: TextStyle(color: Colors.blue)),
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
              child: new Text("帮助",style: TextStyle(color: Colors.red),),
              onPressed: () {
                _saveSingle_repairinfo(context, tempmap);
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  List<dataywwx>dataywwx_list=[];
  void _query_all(){
    BmobQuery<dataywwx> query = BmobQuery();
    query.addWhereNotEqualTo("name", "12%%%3");
    query.queryObjects().then((data) {
      dataywwx_list = data.map((i) => dataywwx.fromJson(i)).toList();
      loading_table1_data();
    }).catchError((e) {
      _Toastmodel(BmobError.convert(e).error, Colors.red);
    });
  }

  void _query(){
    BmobQuery<dataywwx> query = BmobQuery();
    query.addWhereEqualTo("name", query_context);
    query.queryObjects().then((data) {
      dataywwx_list = data.map((i) => dataywwx.fromJson(i)).toList();
      setState(() {
        loading_table1_data();
      });
    }).catchError((e) {
      _Toastmodel(BmobError.convert(e).error, Colors.red);
    });
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

  String name,content,contact;
  TextFormField buildnameTextField(BuildContext context) {
    return TextFormField(
      initialValue: name,
      onSaved: (String value) => name = value,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入昵称';
        }
      },
      decoration: InputDecoration(
          labelText: '昵称',
          labelStyle: TextStyle(color:Color(int.parse(color4))),
          fillColor: Colors.white,
          filled: dart_model,),
    );
  }

  Widget buildcontentTextField(BuildContext context) {
    return TextFormField(
      initialValue: content,
      maxLines: 10,
      onSaved: (String value) => content = value,
      validator: (String value) {
        if (value.isEmpty) {
          return '请填写维修详情';
        }
      },
      decoration: InputDecoration(
          labelText: '维修详情',
        labelStyle: TextStyle(color:Color(int.parse(color4))),
          fillColor: Colors.white,
          filled: dart_model,),
    );
  }

  TextFormField buildcontactTextField(BuildContext context) {
    return TextFormField(
      initialValue: contact,
      onSaved: (String value) => contact = value,
      validator: (String value) {
        if (value.isEmpty) {
          return '请填写联系方式';
        }
      },
      decoration: InputDecoration(
          labelText: '联系方式',
        labelStyle: TextStyle(color:Color(int.parse(color4))),
          fillColor: Colors.white,
          filled: dart_model,),
    );
  }

  Align buildFBButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
              '发表',
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
              Toastmodel('登陆才可以发表哦', Colors.blue);
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  _saveSingle(BuildContext context) {
    dataywwx dy = dataywwx();
    dy.name=name;
    dy.content=content;
    dy.contact=contact;
    dy.phone=phone;
    dy.save().then((BmobSaved bmobSaved) {
      _query_all();
      Toastmodel('发表成功', Colors.blue);
    }).catchError((e) {
      Toastmodel(BmobError.convert(e).error, Colors.red);
    });
  }

  _saveSingle_repairinfo(BuildContext context,Map<String,Object>tempmap) {
    Repairinfo rf = Repairinfo();
    rf.helpphone=phone;
    rf.behelpphone=tempmap['phone']==null||tempmap['phone']==''?'无':tempmap['phone'];
    rf.content=tempmap['content'];
    rf.save().then((BmobSaved bmobSaved) {
      _deleteSingle(context,tempmap['objectId'],tempmap);
    }).catchError((e) {
      Toastmodel(BmobError.convert(e).error, Colors.red);
    });
  }

  _deleteSingle(BuildContext context,currentObjectId,Map<String,Object>tempmap) {
    if (currentObjectId != null) {
      dataywwx blog = dataywwx();
      blog.objectId = currentObjectId;
      blog.delete().then((BmobHandled bmobHandled) {
        currentObjectId = null;
        _query_all();
        Clipboard.setData(ClipboardData(text: tempmap['contact']));
        Toastmodel('联系方式已复制', Colors.blue);
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
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  List<czywwx>czywwx_list=[];
  List<Widget>czywwx_ui_list=[];
  void _query_czywwx_all(){
    BmobQuery<czywwx> query = BmobQuery();
    query.addWhereNotEqualTo("name", "12%%%3");
    query.queryObjects().then((data) {
      czywwx_list = data.map((i) => czywwx.fromJson(i)).toList();
      loading_czywwx();
    }).catchError((e) {
      _Toastmodel(BmobError.convert(e).error, Colors.red);
    });
  }

  void loading_czywwx(){
    czywwx_ui_list.clear();
    for(var i=0;i<czywwx_list.length;i++){
      if(czywwx_list[i].vis=='true'){
        czywwx_ui_list.add(
            new Row(
              children: <Widget>[
                Expanded(
                  child: Maintenance_personnel_component01(czywwx_list[i].imageurl,czywwx_list[i].name,czywwx_list[i].qq,czywwx_list[i].number,czywwx_list[i].objectId.toString()),
                  flex: 1,
                ),
              ],
            )
        );
      }
    }
    setState(() {

    });
  }

  Widget Maintenance_personnel(){
    return new Container(
      child: new Column(
        children: czywwx_ui_list,
      ),
    );
  }

  Widget Maintenance_personnel_component01(String imageurl,String name,String contact,String number,String objectid){
    return GestureDetector(
      onTap: (){
        launchURL('mqq://im/chat?chat_type=wpa&uin=$contact&version=1&src_type=web');
        _updateSingle(context,objectid,number);
      },
      child: new Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
        decoration: BoxDecoration(
            color: Color(int.parse('0xffBBFFFF')),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: new Container(
          child: new Row(
            children: <Widget>[
              Expanded(
                child: new Container(child: new Image(image: new NetworkImage(imageurl)),margin: EdgeInsets.all(10.0),),
                flex: 1,
              ),
              Expanded(
                child: new Column(
                  children: <Widget>[
                    Text(name,textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse('0xff00C5CD'))),),
                    Text(contact,textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse('0xff00C5CD'))),)
                  ],
                ),
                flex: 3,
              ),
              Expanded(
                child: new Container(child:  Text('已维修$number',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse('0xff00C5CD'))),),margin: EdgeInsets.all(10.0),),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ///修改一条数据
  _updateSingle(BuildContext context,String currentObjectId,String number) {
    czywwx blog = czywwx();
    blog.objectId = currentObjectId;
    blog.number = (int.parse(number)+1).toString();
    blog.update().then((BmobUpdated bmobUpdated) {
      //Toastmodel("修改一条数据成功：${bmobUpdated.updatedAt}",Colors.blue);
//      setState(() {
//        _query_czywwx_all();
//      });
    }).catchError((e) {
      print(BmobError.convert(e).error);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('义务维修                                      ',
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
                          buildcontactTextField(context),
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
                buildSearchTextField(),
                Maintenance_personnel(),
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
    _query_czywwx_all();
  }

}
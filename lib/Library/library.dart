import 'package:flutter/material.dart';
import 'package:flutter_app01/Learn_teach/learn_teach_login.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Library/library_person_info/library_person_info.dart';
import 'package:flutter_app01/Learn_teach/Activity_scores/activity_scores.dart';
import 'package:flutter_app01/Learn_teach/Results_query/results_query.dart';
import 'package:flutter_app01/Learn_teach/Activity_evaluation/activity_evaluation.dart';
import 'package:flutter_app01/Learn_teach/dormitory_knowing/dormitory_knowing.dart';
import 'package:flutter_app01/Library/library_login.dart';
import 'package:flutter_app01/Library/library_query/library_query.dart';
import 'dart:convert';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app01/Library/Borrow_book_history/borrow_book_history.dart';
import 'package:flutter_app01/Library/Now_borrow_book/now_borrow_book.dart';
import 'package:flutter_app01/Library/library_accounts/library_accounts.dart';
import 'package:flutter_app01/Library/Now_booking/now_booking.dart';

class Library extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>new Library_State();
}

class Library_State extends State<Library>{
  var library_state='图书馆未登陆';

  var library_student_name='';
  var library_student_id='';


  void setinitdata() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs.getString('library_student_name')!=null){
        library_student_name=prefs.getString('library_student_name');
      }
      if(prefs.getString('library_student_id')!=null){
        library_student_id=prefs.getString('library_student_id');
      }
      if(prefs.getString('library_data')!=null){
        library_state='图书馆已登陆';
      }
    });
  }

  //Verify that library logins are expired
  void _verify_library_login_expired() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String person_info=await HttpUtil.library_person_information('tsmyinfo',sharedPreferences.getString('tscookie'));
    Map<String, Object>library_maptemp = json.decode(person_info);
    if(library_maptemp['code'].toString().trim()!='0'){
      Fluttertoast.showToast(
          msg: "身份过期,请重新登陆",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        library_state='身份过期,请重新登陆';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setinitdata();
    _verify_library_login_expired();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    setinitdata();
  }

  @override
  Widget build(BuildContext context) {
    //the head module
    //Display avatar and login status
    Widget topmodel(){
      return new GestureDetector(
        child: new Container(
          decoration: new BoxDecoration(
            border: new Border.all(width: 1.0, color: Colors.black12),
            color:  Color(int.parse(color1)),
          ),
          height: 100,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(5.0),
          child: new Row(
            children: <Widget>[
              Expanded(
                child: new Image(image: new NetworkImage('http://xz.jvtc.jx.cn/JVTC_XG/DownLoad/Student/'+library_student_id+'.jpg')),
                flex: 1,
              ),
              Expanded(
                child: new Column(
                  children: <Widget>[
                    Expanded(
                      child: new Text(library_student_name,
                        textAlign:TextAlign.center,style: TextStyle(color:  Color(int.parse(color2))),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: new Text(library_state,
                        textAlign:TextAlign.center,
                        style: TextStyle(
                          color: Color(int.parse(color3)),
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                flex: 3,
              ),
            ],
          ),
        ),
        onTap: (){
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new library_login()));
        },
      );
    }

    _body_model_click(String str){
      print(str);
      switch(str.toString().trim()){
        case '个人信息':
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new library_person_info()));
          break;
        case '书籍查询':
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new library_query()));
          break;
        case '借阅历史':
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new borrow_book_history()));
          break;
        case '当前借阅':
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new now_borrow_book()));
          break;
        case '账目清单':
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new library_accounts()));
          break;
        case '当前预约':
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new now_booking()));
          break;
      }
    }

    Widget body_component01(String imageurl,String label){
       return new Container(
        decoration: new BoxDecoration(
          border: new Border.all(width: 1.0, color: Colors.black12),
          color:  Color(int.parse(color1)),
        ),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(5.0),
        child:  new GestureDetector(
          child: new Row(
            children: <Widget>[
              Expanded(
                child: new Image.asset(imageurl),
                flex: 1,
              ),
              Expanded(
                child: new Text(label,
                  textAlign: TextAlign.left,style: TextStyle(color:  Color(int.parse(color2))),),
                flex: 10,
              ),
              Expanded(
                child: new Image.asset('images/2.0.x/right01.png'),
                flex: 1,
              ),
            ],
          ),
          onTap:(){
            _body_model_click(label);
          },
        ),
      );
    };

    //the body model
    //我的资料 我的素拓得分 成绩查询 活动评价 查寝列表 the five model
    //here are five modules for jump operations
    Widget bodymodel=new Container(
      child: new Column(
        children: [
          body_component01('images/2.0.x/ziliao.png','        个人信息'),
          body_component01('images/2.0.x/ziyuan.png','        书籍查询'),
          body_component01('images/2.0.x/luqufenshubiao.png','        借阅历史'),
          body_component01('images/2.0.x/pingjia.png','        当前借阅'),
          body_component01('images/2.0.x/cq.png','        账目清单'),
          body_component01('images/2.0.x/reservation.png','        当前预约'),
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('图书馆                                       ',
          textAlign:TextAlign.left,style: TextStyle(color:  Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
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
          children: <Widget>[
            topmodel(),
            bodymodel
          ],
        ),
      ),
    );
  }

}
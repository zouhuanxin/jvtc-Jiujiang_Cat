import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/gxinfo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';
import 'package:flutter_app01/home/home.dart';
import 'package:flutter_app01/course/course.dart';
import 'package:flutter_app01/my/my.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:data_plugin/bmob/bmob_query.dart';

class Love_home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Love_home_State();

}

//fb93c0
//b7e1f5
//e9eacd
class Love_home_State extends State<Love_home>{

  Widget top_model(){
    return new GestureDetector(
      child: new Container(
        height: 320,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/2.0.x/test.jpg"),
            fit: BoxFit.fill,
          ),
        ),
          child: new Container(
            margin: EdgeInsets.fromLTRB(20, 200, 0, 0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: new Column(
                children: <Widget>[
                  new Text('你们在一起',style: TextStyle(fontSize: 18,color: Colors.white),),
                  new Text('520',style: TextStyle(fontSize: 30,color: Colors.white),),
                  new Text('天了',style: TextStyle(fontSize: 18,color: Colors.white),),
                ],
              ),
            ),
          ),
      ),
    );
  }
  
  Widget buildButton01(url,label){
    return GestureDetector(
      child: new Container(
        decoration: BoxDecoration(
            color: Color(int.parse('0xffb7e1f5')),
            borderRadius: BorderRadius.circular(3.0)
        ),
        margin: EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            Expanded(
              child: new Container(
                margin: EdgeInsets.all(5.0),
                child: new Image.asset(url,fit: BoxFit.fill),
              ),
              flex: 1,
            ),
            Expanded(
              child: new Text(label,textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse('0xff676b6f'))),),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('情侣首页                                       ',
            textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse('0xffffffff')),fontWeight: FontWeight.w800,fontSize: 25),),
          elevation: 0.0,
          leading: new Container(
            margin: EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: (){

              },
              child: new ClipOval(
                child: new Image.asset('images/2.0.x/couples.png',fit: BoxFit.fill),
              ),
            ),
          ),
          backgroundColor: Color(int.parse('0xfffb93c0')),
          centerTitle: true,
        ),
        body: new Container(
          decoration: BoxDecoration(
            color: Color(int.parse(color1)),
          ),
          child: new ListView(
            children: [
              top_model(),
              new Row(
                children: <Widget>[
                  Expanded(
                    child:new Text(''),
                    flex: 1,
                  ),
                  Expanded(
                    child:new Text(''),
                    flex: 1,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
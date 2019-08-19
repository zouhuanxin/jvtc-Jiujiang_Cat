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

class Love_money extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Love_money_State();

}

class Love_money_State extends State<Love_money>{

  Widget buildTop_Money(){
    return new GestureDetector(
      child: new Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10.0)
        ),
        height: 150,
        child: new Row(
          children: <Widget>[
           Expanded(
             child:  new Column(
               children: <Widget>[
                 Expanded(
                   child:  new Row(
                     children: <Widget>[
                       new Container(
                         margin: EdgeInsets.all(5.0),
                         height:30,
                         width: 30,
                         child: new Image.asset('images/2.0.x/cqg.png'),
                       ),
                       new Text('双方存入',style: TextStyle(color: Colors.white),)
                     ],
                   ),
                   flex: 1,
                 ),
                 Expanded(
                   child: Align(
                     alignment: Alignment.center,
                     child: new Text('￥6668',style: TextStyle(color: Colors.white,fontSize: 30),),
                   ),
                   flex: 1,
                 ),
                 Expanded(
                   child: Align(
                     alignment: Alignment.center,
                     child: new Text(' 此基金取出时需要双方同意',style: TextStyle(color: Colors.white,fontSize: 12),),
                   ),
                   flex: 1,
                 ),
               ],
             ),
             flex: 1,
           ),
            Expanded(
              child: new Column(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: new Text('存款明细',textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: new GestureDetector(
                      child: new Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: 90,
                          margin: EdgeInsets.all(10.0),
                          child: Align(
                              alignment: Alignment.center,
                              child: new Text('存入',textAlign:TextAlign.center,style: TextStyle(color: Colors.blueAccent))),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: new GestureDetector(
                      child: new Container(
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        width: 90,
                        margin: EdgeInsets.all(10.0),
                        child: Align(
                            alignment: Alignment.center,
                            child: new Text('取出',textAlign:TextAlign.center,style: TextStyle(color: Colors.white))),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              flex: 1,
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
          title: new Text('情侣基金                                       ',
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
              color: Color(int.parse(color1))
          ),
          child: new ListView(
            children: [
              buildTop_Money()
            ],
          ),
        ),
      ),
    );
  }

}
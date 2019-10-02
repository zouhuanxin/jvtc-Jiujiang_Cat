import 'dart:convert';
import 'dart:ui' as ui;
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/Bean/competition.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/WebViewPage.dart';

class competition_person extends StatefulWidget{
  final String type;

  const competition_person({Key key, this.type}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return competition_person_State(type);
  }

}

class competition_person_State extends State<competition_person>{
  List<Widget>allui=[];
  String type;

  competition_person_State(value){
    type=value;
    _bmob_get_information();
  }

  void _bmob_get_information(){
    allui.clear();
    BmobQuery<competition> query = BmobQuery();
    query.addWhereEqualTo("phone",phone);
    query.queryObjects().then((data) async {
      setState(() {
        List<competition>templist = data.map((i) => competition.fromJson(i)).toList();
        for(competition cp in templist){
          if(cp.type==type){
            allui.add(card(cp,'0xfff1f1f1'));
          }
        }
      });
    }).catchError((e) {});
  }

  Widget card(competition sf,String color) {
    return new Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Color(int.parse(color)),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap:(){
              if(sf.url==null||sf.url==''){
                return;
              }
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new WebViewPage(
                          url: sf.url,
                          title: '活动详情')));
            },
            child: Column(
              children: <Widget>[
                new Container(
                  child: Image.network(sf.logo,
                    height: MediaQueryData.fromWindow(ui.window).size.height*0.2,),
                ),
                new Container(
                  padding: EdgeInsets.all(5.0),
                  child: Align(
                    child: Text(
                      sf.introduce,
                      style: TextStyle(color: Colors.black, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    alignment: Alignment.topLeft,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.all(5.0),
                  child: Align(
                    child: Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(MediaQueryData.fromWindow(ui.window).size.height*0.005),
                              child: new Align(
                                alignment: FractionalOffset.center,
                                child: new GestureDetector(
                                  child: new ClipOval(
                                    child: new Image.memory(base64.decode(now_login_image_base64),fit: BoxFit.fill,height: 30,width: 30,),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              username,
                              style: TextStyle(
                                  color: Color(int.parse(color2)),
                                  fontWeight: FontWeight.w200,
                                  fontSize: 12),textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                    alignment: Alignment.topLeft,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            child: Align(
              child: Row(
                children: <Widget>[
                  Expanded(child: Container(
                    child: Align(
                      child: Text('获得票数:'+sf.number,style: TextStyle(color: Colors.red),),
                      alignment: Alignment.center,
                    ),
                  ),flex: 1,),
                ],
              ),
              alignment: Alignment.topLeft,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          '个人作品                                       ',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(int.parse(color2)),
              fontWeight: FontWeight.w800,
              fontSize: 17),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(int.parse(color2))),
        backgroundColor: Color(int.parse(color1)),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: <Widget>[new Container()],
      ),
      body: ListView(
        children: <Widget>[
          new Column(
            children: allui,
          )
        ],
      ),
    );
  }

}
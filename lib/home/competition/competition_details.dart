import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/Bean/competition.dart';
import 'package:flutter_app01/Bean/competition_type.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_app01/Utils/WebViewPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'competition_details2.dart';
import 'competition_person.dart';
import 'competition_release.dart';
class competition_details extends StatefulWidget {
  final competition_type ct;

  const competition_details({Key key, this.ct}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return competition_details_State(ct);
  }
}

class competition_details_State extends State<competition_details> {
  List<competition> sfs = [];
  List<QTuser> qts = [];
  competition_type ct;
  String search_str='';

  competition_details_State(competition_type value){
    ct=value;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bmob_get_information();
  }

  void _bmob_get_information(){
    sfs.clear();
    BmobQuery<competition> query = BmobQuery();
    query.addWhereEqualTo("type", ct.text);
    query.setOrder("-number");
    query.queryObjects().then((data) async {
      setState(() {
        sfs = data.map((i) => competition.fromJson(i)).toList();
      });
      for(competition sf in sfs){
        QTuser qTuser=null;
        if(sf.phone!=null&&sf.phone.length>5){
          qTuser=await get_person(sf);
          qts.add(qTuser);
        }else{
          qts.add(qTuser);
        }
      }
      setState(() {

      });
    }).catchError((e) {});
  }

  int jo(i,j){
    double d=i/j;
    String value=d.toString().split('.')[1];
    if(int.parse(value)==5){
      return 1;
    }else{
      return 2;
    }
  }

  Widget card(competition sf,QTuser qTuser,String color) {
    return new Container(
      decoration: BoxDecoration(
          color: Color(int.parse(color)),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Column(
        children: <Widget>[
          new GestureDetector(
            onTap:(){
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new competition_details2(cp: sf,qt: qTuser,)));
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
                                    child: new Image.memory(base64.decode(qTuser!=null?qTuser.imagebase64:default_image),fit: BoxFit.fill,height: 30,width: 30,),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              qTuser!=null?qTuser.username:'匿名',
                              style: TextStyle(
                                  color: Colors.black,
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
                      child: Text(sf.number),
                      alignment: Alignment.center,
                    ),
                  ),flex: 1,),
                  Expanded(child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: GestureDetector(
                      onTap: (){
                        tp(sf);
                      },
                      child: Align(
                        child: Text('投一票',style: TextStyle(color: Colors.white),),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),flex: 1,),
                ],
              ),
              alignment: Alignment.topLeft,
            ),
          ),
          new Offstage(
            offstage: sf.url==null||sf.url==''?true:false,
            child: new GestureDetector(
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
              child: Container(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text('项目链接  ',style: TextStyle(color: Colors.blue),),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget Textinput() {
    return new Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(MediaQueryData.fromWindow(ui.window).size.width*0.05, 0, 0, MediaQueryData.fromWindow(ui.window).size.height*0.01),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: MediaQueryData.fromWindow(ui.window).size.height*0.05,
          width: MediaQueryData.fromWindow(ui.window).size.width*0.60,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey,width: 2)
          ),
          child: new TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '输入手机号',
                hintStyle: TextStyle(color: Color(int.parse(color2))),
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0)
            ),
            textAlign: TextAlign.start,
            onChanged: (T){
              search_str=T;
            },
            autofocus: false,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(MediaQueryData.fromWindow(ui.window).size.width*0.05, 0, MediaQueryData.fromWindow(ui.window).size.width*0.05, MediaQueryData.fromWindow(ui.window).size.height*0.01),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: MediaQueryData.fromWindow(ui.window).size.height*0.05,
          width: MediaQueryData.fromWindow(ui.window).size.width*0.20,
          decoration: BoxDecoration(
            color: Colors.blue
          ),
          child: Align(
            child: GestureDetector(
              onTap: (){
                query_phone(search_str);
              },
              child: new Text(
                '搜索',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,
              ),
            ),
            alignment: Alignment.center,
          ),
        )
      ],
    );
  }

  Widget headImage(){
    return new Container(
      width:MediaQueryData.fromWindow(ui.window).size.width,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        children: <Widget>[
          Image.network(ct.imageurl!=null?ct.imageurl:'https://f12.baidu.com/it/u=3326455251,1388799780&fm=72',height: MediaQueryData.fromWindow(ui.window).size.height*0.3,
              width:MediaQueryData.fromWindow(ui.window).size.width),
          Text(ct.introduce,style: TextStyle(color: Color(int.parse(color2)),fontSize: 15,fontWeight: FontWeight.w400),textAlign: TextAlign.left,)
        ],
      ),
    );
  }

  //获取发表作品用户头像以及姓名信息
  Future<QTuser> get_person(competition sf) async{
    QTuser qTuser;
    BmobQuery<QTuser> query = BmobQuery();
    query.addWhereEqualTo("phone", sf.phone);
    await query.queryObjects().then((data) {
      List<QTuser>list=data.map((i) => QTuser.fromJson(i)).toList();
      qTuser=list[0];
    }).catchError((e) {});
    return qTuser;
  }

  //根据用户手机号来搜索
  void query_phone(String str){
    List<Widget>templist=[];
    for(int i=0;i<sfs.length;i++){
      if(sfs[i].phone==str){
        //card(sfs[i],qts[i],'')
        templist.add(new Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: card(sfs[i],qts[i],'0xfff1f1f1'),
        ));
      }
    }
    if(templist.length<1){
      showTaost('没有找到', Toast.LENGTH_SHORT, Colors.red);
      return;
    }
    _showmodel(templist);
  }

  //投票
  void tp(competition sf){
    bool bol=false;
    if(login_state==false){
      showTaost('请先登陆再投票', Toast.LENGTH_SHORT, Colors.red);
      return;
    }
    BmobQuery<competition> query = BmobQuery();
    query.addWhereEqualTo("objectId", sf.objectId);
    query.queryObjects().then((data) {
      setState(() {
        List<competition>list = data.map((i) => competition.fromJson(i)).toList();
        //判断是否已经点赞当前用户
        if(list[0].numberperson==null){
          list[0].numberperson='';
        }
        var arr=list[0].numberperson.split(',');
        for(int i=0;i<arr.length;i++){
          if(arr[i]==phone){
            bol=true;
          }
        }
        ///修改一条数据
        if(bol==true){
          showTaost('您已经投票了', Toast.LENGTH_SHORT, Colors.red);
          return;
        }
        competition blog = competition();
        blog.objectId = list[0].objectId;
        blog.numberperson=list[0].numberperson+','+phone;
        blog.number = (int.parse(list[0].number)+1).toString();
        blog.update().then((BmobUpdated bmobUpdated) {
          setState(() {
            sf.number=(int.parse(list[0].number)+1).toString();
          });
         // print("修改一条数据成功：${bmobUpdated.updatedAt}");
          showTaost('感谢您的投票', Toast.LENGTH_SHORT, Colors.blue);
        }).catchError((e) {
         // print(BmobError.convert(e).error);
          showTaost(BmobError.convert(e).error, Toast.LENGTH_SHORT, Colors.red);
        });
      });
    }).catchError((e) {});
  }

  void showTaost(msg, type, color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  //弹窗
  _showmodel(List<Widget>list) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            '九职小猫手',
            style: TextStyle(fontSize: 16),
          ),
          content: new ListView(
            children: list,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("关闭"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '活动投票                                       ',
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
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) =>
              <PopupMenuItem<String>>[
                PopupMenuItem<String>(child: Text("报名参赛"), value: "报名参赛",),
                PopupMenuItem<String>(child: Text("我的作品"), value: "我的作品",),
              ],
              onSelected: (String action) {
                switch (action) {
                  case "报名参赛":
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new competition_release()));
                    break;
                  case "我的作品":
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new competition_person(type: ct.text,)));
                    break;
                }
              },
              onCanceled: () {
                print("onCanceled");
              },
            )
          ],
        ),
        body: new Container(
          decoration: BoxDecoration(color: Color(int.parse(color1))),
          child: new Container(
            margin: EdgeInsets.all(MediaQueryData.fromWindow(ui.window).size.height*0.01),
            child: new ListView(
              children: <Widget>[
                headImage(),
                new Column(
                  children: <Widget>[
                    Textinput(),
                    new Container(
                      height: MediaQueryData.fromWindow(ui.window).size.height*0.79,
                      child: GridView.builder(
                        itemCount: sfs.length,
                        itemBuilder: (BuildContext context, int index) {
                          if(index==0){
                            return card(sfs[index],qts.length>1?qts[index]:null,'0xffedeb50');
                          }else if(index==1){
                            return card(sfs[index],qts.length>1?qts[index]:null,'0xffc0c0c0');
                          }else if(index==2){
                            return card(sfs[index],qts.length>1?qts[index]:null,'0xffEED5B7');
                          }else{
                            return card(sfs[index],qts.length>1?qts[index]:null,'0xfff1f1f1');
                          }
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //横轴元素个数
                            crossAxisCount: 2,
                            //纵轴间距
                            mainAxisSpacing: 10.0,
                            //横轴间距
                            crossAxisSpacing: 10.0,
                            //子组件宽高长度比例
                            childAspectRatio: 0.65
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

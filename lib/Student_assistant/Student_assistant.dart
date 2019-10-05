import 'dart:async';
import 'dart:convert';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app01/Bean/learn_assistant.dart';
import 'package:flutter_app01/Bean/learn_assistant02.dart';
import 'package:flutter_app01/Bean/learn_assistant03.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Student_analysis.dart';

class Student_assistant extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Student_assistant_State();
}

class ClockPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    return true;
  }
}
class Student_assistant_State extends State<Student_assistant>{
  static const androidplatform = const MethodChannel("test");
  List<learn_assistant>learn_list=[];
  String today_learn_minutes='0';

  Widget component1(){
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Color(int.parse(color2)),width: 5.0),
        ),
        child: Align(alignment: Alignment.center,child: new Text('$_countdownMinutes.$_countdownNum'.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 50,color: Color(int.parse(color2))),),),
      ),
    );
  }

  Widget component2(){
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.all(60.0),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          //border: Border.all(color: Color(int.parse(color2)),width: 2.0),
        ),
        child: new Column(
          children: <Widget>[
            Align(alignment: Alignment.center,child: new Text('今日已学习$today_learn_minutes分钟',textAlign: TextAlign.center,style: TextStyle(fontSize: 30,color: Color(int.parse(color2))),),),
            Align(alignment: Alignment.center,child: new Text('今日已学习${_Get_hours(today_learn_minutes)}小时',textAlign: TextAlign.center,style: TextStyle(fontSize: 30,color: Color(int.parse(color2))),),)
          ],
        ),
      ),
    );
  }

  _Get_hours(String str){
    double d1=double.parse(str)/60;
    String s1=d1.toString();
    if(s1.length>2){
      return d1.toStringAsFixed(2).toString();
    }else{
      return d1; 
    }
  }

  Widget buildButton01(){
    return Align(
      alignment: Alignment.center,
      child: new Container(
        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
        width: 200,
        height: 50,
        child: RaisedButton(
          textTheme: ButtonTextTheme.accent,
          color: Colors.green,
          highlightColor: Colors.deepPurpleAccent,
          splashColor: Colors.yellow,
          colorBrightness: Brightness.dark,
          elevation: 50.0,
          highlightElevation: 100.0,
          disabledElevation: 20.0,
          onPressed: () {
            button_click(_codeCountdownStr);
          },
          child: Text(
            _codeCountdownStr,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }

  Widget buildButton02(){
    return Align(
      alignment: Alignment.center,
      child: new Container(
        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
        width: 200,
        height: 50,
        child: RaisedButton(
          textTheme: ButtonTextTheme.accent,
          color: Colors.blue,
          highlightColor: Colors.deepPurpleAccent,
          splashColor: Colors.white,
          colorBrightness: Brightness.dark,
          elevation: 50.0,
          highlightElevation: 100.0,
          disabledElevation: 20.0,
          onPressed: () {
            button_click('学习报表');
          },
          child: Text(
            '学习报表',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }

  //控制是否开启沉浸状态
  bool appbar_bol=false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WillPopScope(child: new Scaffold(
        appBar: PreferredSize(child: new Offstage(
          offstage: appbar_bol,
          child: new AppBar(
            title: new Text('学习周期                                       ',
              textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
            elevation: 0.0,
            iconTheme: IconThemeData(color: Color(int.parse(color2))),
            backgroundColor: Color(int.parse(color1)),
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            actions: <Widget>[
              new Container()
            ],
          ),
        ), preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),),
        body: new Container(
          decoration: BoxDecoration(
            color: Color(int.parse(color1)),
          ),
          child: new ListView(
            children: <Widget>[
              component1(),
              buildButton01(),
              buildButton02(),
              component2()
            ],
          ),
        )
    ), onWillPop: (){
      //print("返回键点击了");
    });
  }

  void button_click(String str){
    switch(str){
      case '开始学习':
        showmodel2();
        break;
      case '结束学习':
        if(_countdownMinutes<1){
          Toastmodel('好歹学习一分钟叭', Colors.red);
        }else{
          showmodel();
        }
        break;
      case '学习报表':
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new Student_analysis()));
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _query_all();
  }

  _Subtracting_date(String str1,String str2) async{
    int str=await androidplatform.invokeMethod("daysBetween2",{"str1":str1,"str2":str2});
    return str;
  }

  showmodel(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('学习周期提示'),
          content: Text(('你确认结束此次学习吗')),
          actions: <Widget>[
            new FlatButton(
              child: new Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("结束",style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.pop(context);
                _endtime=DateTime.now().toString().split('.')[0];
                cancel_tzl();
                setState(() {
                  appbar_bol=false;
                  _codeCountdownStr='开始学习';
                  _countdownTimer?.cancel();
                  _countdownTimer = null;
                  _countdownNum=0;
                  _countdownMinutes=0;
                  _loading_data();
                });
              },
            ),
          ],
        ));
  }

  showmodel2(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('系统提示'),
          content: Text(('开启学习模式以后请不要退出此界面(即不要再玩手机)否则可能会使学习时长无效')),
          actions: <Widget>[
            new FlatButton(
              child: new Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("开始",style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.pop(context);
                start_noti("0");
                appbar_bol=true;
                _starttime=DateTime.now().toString().split('.')[0];
                _codeCountdownStr='结束学习';
                reGetCountdown();
              },
            ),
          ],
        ));
  }

  void _loading_data() async{
    int i=_check_date(learn_list);
    if(i!=-1){
      int number=0;
      learn_assistant03 la03=new learn_assistant03();
      la03.starttime=_starttime;
      la03.endtime=_endtime;
      int tempstr=await _Subtracting_date(_starttime, _endtime);
      la03.sum=tempstr.toString();
      number=number+tempstr;
      List<learn_assistant03>templist03=[];
      List<dynamic>list=json.decode(json.encode(learn_list[i].learn02))['learn03_list'];
      for(var n=0;n<list.length;n++){
        learn_assistant03 la03=new learn_assistant03();
        la03.starttime=json.decode(json.encode(list[n]))['starttime'];
        la03.endtime=json.decode(json.encode(list[n]))['endtime'];
        la03.sum=json.decode(json.encode(list[n]))['sum'];
        templist03.add(la03);
        number=number+int.parse(json.decode(json.encode(list[n]))['sum']);
      }
      templist03.add(la03);
      learn_assistant02 la02=new learn_assistant02();
      la02.sum=number.toString();
      la02.learn03_list=templist03;
      learn_list[i].learn02=la02;
      _updateSingle(context,learn_list[i]);
    }else{
      learn_assistant03 la03=new learn_assistant03();
      la03.starttime=_starttime;
      la03.endtime=_endtime;
      int tempstr=await _Subtracting_date(_starttime, _endtime);
      la03.sum=tempstr.toString();
      learn_assistant02 la02=new learn_assistant02();
      la02.sum=la03.sum;
      List<learn_assistant03>templist03=[];
      templist03.add(la03);
      la02.learn03_list=templist03;
      learn_assistant la01=new learn_assistant();
      la01.phone=phone;
      String str=DateTime.now().toString().split(' ')[0];
      la01.time_phone='$str\and$phone';
      la01.time=DateTime.now().toString().split(' ')[0];
      la01.learn02=la02;
      _saveSingle(context,la01);
    }
  }

  _check_date(List<learn_assistant>list){
    int m=-1;
    String str=DateTime.now().toString().split(' ')[0];
    for(var i=0;i<list.length;i++){
      if(list[i].time_phone=='$str\and$phone'){
        m=i;
      }
    }
    return m;
  }

  void _query_all(){
    if(login_state==true){
      String str=DateTime.now().toString().split(' ')[0].toString().trim();
      BmobQuery<learn_assistant> query = BmobQuery();
      query.addWhereEqualTo("time_phone", '$str\and$phone');
      query.queryObjects().then((data) {
        learn_list = data.map((i) => learn_assistant.fromJson(i)).toList();
        setState(() {
          today_learn_minutes=json.decode(json.encode(learn_list[0].learn02))['sum'].toString();
        });
      }).catchError((e) {
        print(BmobError.convert(e).error);
        Toastmodel(BmobError.convert(e).error, Colors.red);
      });
    }else{
      Toastmodel('请先登陆', Colors.red);
      Navigator.pop(context);
    }
  }

  _saveSingle(BuildContext context,learn_assistant la) {
    la.save().then((BmobSaved bmobSaved) {
      _query_all();
      Toastmodel('放松一下叭', Colors.blue);
    }).catchError((e) {
      print(BmobError.convert(e).error);
      Toastmodel(BmobError.convert(e).error, Colors.red);
    });
  }

  _updateSingle(BuildContext context,learn_assistant la) {
    la.update().then((BmobUpdated bmobUpdated) {
      _query_all();
      Toastmodel("放松一下叭",Colors.blue);
    }).catchError((e) {
      print(BmobError.convert(e).error);
      Toastmodel(BmobError.convert(e).error,Colors.red);
    });
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

  Timer _countdownTimer;
  String _codeCountdownStr = '开始学习';
  int _countdownMinutes = 0;
  int _countdownNum = 0;
  String _starttime='';
  String _endtime='';
  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      _countdownTimer =
      new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if(_countdownNum==59){
            _countdownMinutes++;
            start_noti(_countdownMinutes.toString());
            _countdownNum=0;
          }
          _countdownNum++;
        });
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  //开启时间通知
  void start_noti(String time) async{
    List<String>list=[];
    list.add("此次你已经学习"+time+"分钟");
    await androidplatform.invokeMethod("androidpush2", {"list": list});
  }
  //cancelNotification
  void cancel_tzl() async{
    await androidplatform.invokeMethod("cancelNotification", {"id":2});
  }

}

/**

    {
    "data": [{
    "2019-08-04": {
    "sum": 120,
    "details": [{
    "sum": 60,
    "starttime": "2019-08-04 15:00:00",
    "endtime": "2019-08-04 16:00:00"
    }, {
    "sum": 60,
    "starttime": "2019-08-04 15:00:00",
    "endtime": "2019-08-04 16:00:00"
    }]
    }
    },
    {
    "2019-08-05": {
    "sum": 120,
    "details": [{
    "sum": 60,
    "starttime": "2019-08-04 15:00:00",
    "endtime": "2019-08-04 16:00:00"
    }, {
    "sum": 60,
    "starttime": "2019-08-04 15:00:00",
    "endtime": "2019-08-04 16:00:00"
    }]
    }
    }
    ]
    }

**/
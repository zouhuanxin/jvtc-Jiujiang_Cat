import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Animation_list.dart';
import 'package:flutter_app01/index/index.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/my/my_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app01/Learn_teach/learn_teach_login.dart';

import 'Ui_course2.dart';

class CoursPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CoursePageState();
}

class CoursePageState extends State<CoursPage> {
  //采用单例模式设计保证初始化取到对象的唯一性 确保在外调用里面函数对象的准确性
  // 工厂模式
  factory CoursePageState() => _getInstance();

  static CoursePageState get instance => _getInstance();
  static CoursePageState _instance;

  CoursePageState._internal() {
    // 初始化
  }

  static CoursePageState _getInstance() {
    if (_instance == null) {
      _instance = new CoursePageState._internal();
    }
    return _instance;
  }

  void disdl(){
    _instance=null;
  }

  //课程ui对象集合
  List<Widget> course_ui_data = [];

  //课程数据集合
  List<String> course_data = [];

  //当前选择日期
  String now_choose_date =
      new DateTime.now().toString().split(' ')[0].toString();

  var login_number = 0;

  int xia = 1;

  void course_click(index) {
    //print(course_data);
    //0-7 9 16 24 32 40 48
    if (index > 7 &&
        index != 8 &&
        index != 16 &&
        index != 24 &&
        index != 32 &&
        index != 40 &&
        index != 48) {
      _showmodel('课程信息',
          course_data[index].split('kcdescribe:')[1].split('kcname:')[0]);
    } else if (index > 0 && index < 8) {
      setState(() {
        xia = index;
        load_data();
      });
    }
  }

  //给外面调用的抛出的方法
  void resh_course_data(BuildContext context) async {
    //print('resh_course_data');
    load_data();
    await _query_course_data(now_choose_date, context);
  }

  _query_course_data(String date, context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('jwcookie') != null) {
      String str1 = await HttpUtil.query_course(
          'kcinfo', sharedPreferences.getString('jwcookie'), date);
      if (int.parse(json.decode(str1)['code'].toString().trim()) == 0) {
        _string_turn_list(str1);
      } else if (login_number < 1) {
        login_number = 1;
        if (await HttpUtil.Automatic_landing() == '0') {
          _query_course_data(date, context);
        } else {
          showmodel('请先登录学教平台', Colors.red);
        }
      } else {
        showmodel('无课程信息,请选择有效日期', Colors.red);
      }
    } else {
      if (resh_state == 1) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new learn_teach_login()));
        showmodel('请先登录学教平台', Colors.red);
      }
    }
  }

  void showmodel(String str, var color) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _string_turn_list(String str) {
    course_ui_data.clear();
    course_data.clear();
    Map<String, dynamic> maptemp = json.decode(str);
    String temp = maptemp['data'];
    var arr = json.decode(temp);
    for (var i = 0; i < arr.length; i++) {
      course_data.add(arr[i].toString());
    }
    setState(() {
      load_data();
    });
  }

  //弹窗
  _showmodel(String title, String content) {
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
                  child: new Text("确定"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Widget course_grid_ui2() {
    return new Container(
      //padding: const EdgeInsets.all(20.0),
      child: new Container(
        height: 600,
        child: new ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            new Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: course_ui_data,
            )
          ],
        ),
      ),
    );
  }

  //第二版本ui设计装载数据
  void load_data() {
    List<String> course_data2 = [];
    var arr2 = json.decode(course_default_str);
    for (var i = 0; i < arr2.length; i++) {
      course_data2.add(arr2[i].toString());
    }
    course_ui_data.clear();
    for (var i = 0; i < 7; i++) {
      course_ui_data.add(new Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn_ui2(
              course_data.length < 5
                  ? course_data2[i * 8].toString()
                  .split('kcname:')[1]
                  .split('}')[0]
                  .toString()
                  .trim()
                  : course_data[i * 8]
                      .toString()
                      .split('kcname:')[1]
                      .split('}')[0]
                      .toString()
                      .trim(),
              Color(int.parse(color1)),
              i * 8,
              xia,now_choose_date),
          buildButtonColumn_ui2(
              course_data.length < 5
                  ? course_data2[i * 8 + 1].toString()
                  .split('kcname:')[1]
                  .split('}')[0]
                  .toString()
                  .trim()
                  : course_data[i * 8 + 1]
                      .toString()
                      .split('kcname:')[1]
                      .split('}')[0]
                      .toString()
                      .trim(),
              i == 0 ? Color(int.parse(color1)) : dart_model==true?Colors.transparent:Color(int.parse('0xffEFCEE8')),
              i * 8 + 1,
              xia,now_choose_date),
          buildButtonColumn_ui2(
              course_data.length < 5
                  ? course_data2[i * 8 + 2].toString()
                  .split('kcname:')[1]
                  .split('}')[0]
                  .toString()
                  .trim()
                  : course_data[i * 8 + 2]
                      .toString()
                      .split('kcname:')[1]
                      .split('}')[0]
                      .toString()
                      .trim(),
              i == 0 ? Color(int.parse(color1)) : dart_model==true?Colors.transparent:Color(int.parse('0xffF3D7B5')),
              i * 8 + 2,
              xia,now_choose_date),
          buildButtonColumn_ui2(
              course_data.length < 5
                  ? course_data2[i * 8 + 3].toString()
                  .split('kcname:')[1]
                  .split('}')[0]
                  .toString()
                  .trim()
                  : course_data[i * 8 + 3]
                      .toString()
                      .split('kcname:')[1]
                      .split('}')[0]
                      .toString()
                      .trim(),
              i == 0 ? Color(int.parse(color1)) : dart_model==true?Colors.transparent:Color(int.parse('0xffFDFFDF')),
              i * 8 + 3,
              xia,now_choose_date),
          buildButtonColumn_ui2(
              course_data.length < 5
                  ? course_data2[i * 8 + 4].toString()
                  .split('kcname:')[1]
                  .split('}')[0]
                  .toString()
                  .trim()
                  : course_data[i * 8 + 4]
                      .toString()
                      .split('kcname:')[1]
                      .split('}')[0]
                      .toString()
                      .trim(),
              i == 0 ? Color(int.parse(color1)) : dart_model==true?Colors.transparent:Color(int.parse('0xffDAF9CA')),
              i * 8 + 4,
              xia,now_choose_date),
          buildButtonColumn_ui2(
              course_data.length < 5
                  ? course_data2[i * 8 + 5].toString()
                  .split('kcname:')[1]
                  .split('}')[0]
                  .toString()
                  .trim()
                  : course_data[i * 8 + 5]
                      .toString()
                      .split('kcname:')[1]
                      .split('}')[0]
                      .toString()
                      .trim(),
              i == 0 ? Color(int.parse(color1)) : dart_model==true?Colors.transparent:Color(int.parse('0xffC7B3E5')),
              i * 8 + 5,
              xia,now_choose_date),
          buildButtonColumn_ui2(
              course_data.length < 5
                  ? course_data2[i * 8 + 6].toString()
                  .split('kcname:')[1]
                  .split('}')[0]
                  .toString()
                  .trim()
                  : course_data[i * 8 + 6]
                      .toString()
                      .split('kcname:')[1]
                      .split('}')[0]
                      .toString()
                      .trim(),
              i == 0 ? Color(int.parse(color1)) : dart_model==true?Colors.transparent:Color(int.parse('0xffEDE387')),
              i * 8 + 6,
              xia,now_choose_date),
          buildButtonColumn_ui2(
              course_data.length < 5
                  ? course_data2[i * 8 + 7].toString()
                  .split('kcname:')[1]
                  .split('}')[0]
                  .toString()
                  .trim()
                  : course_data[i * 8 + 7]
                      .toString()
                      .split('kcname:')[1]
                      .split('}')[0]
                      .toString()
                      .trim(),
              i == 0 ? Color(int.parse(color1)) : dart_model==true?Colors.transparent:Color(int.parse('0xffFF534D')),
              i * 8 + 7,
              xia,now_choose_date),
        ],
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    //print('initstate');
    load_data();
    _query_course_data(now_choose_date, context);
  }

  @override
  Widget build(BuildContext context) {
    //2.0.2之前使用
//    Column buildButtonColumn(String label, int color, int index) {
//      return new Column(
//        mainAxisSize: MainAxisSize.min,
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: [
//          new Container(
//            decoration: new BoxDecoration(
//                border: new Border.all(
//                    width: color == -1 ? 0.0 : 2.0,
//                    color: color == -1
//                        ? Color(int.parse(color1))
//                        : (color == 0 ? Colors.cyan : Colors.blue)),
//                color: color == -1
//                    ? Color(int.parse(color1))
//                    : (color == 0 ? Colors.cyan : Colors.blue),
//                borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
//            height: 60,
//            width: 50,
//            padding: const EdgeInsets.all(5.0),
//            margin: const EdgeInsets.only(top: 8.0, left: 2.0, right: 2.0),
//            alignment: Alignment.center,
//            child: new GestureDetector(
//              child: new Text(
//                label,
//                textAlign: TextAlign.center,
//                style: new TextStyle(
//                  fontSize: 8.5,
//                  fontWeight: FontWeight.w400,
//                  color: Colors.black,
//                ),
//              ),
//              onTap: () {
//                course_click(index);
//              },
//            ),
//          ),
//        ],
//      );
//    };

    //判断课程是否为空 即这个时间段有没有课
    //-1为空表示无课全白表示 0为课表说明 0-7 9 16 24 32 40 48
    // 1-2学分黄色#FFBB4A  1 2-4学分蓝色#4683FF  2 4以上红色#1CCCBE 均配白色字体#F1F1F1  3
//    _judge_course(String str, int index) {
//      if (str == '') {
//        return -1;
//      } else {
//        if (index >= 0 && index <= 7) {
//          return 0;
//        } else {
//          return 1;
//        }
//      }
//    }

    //数据写入  第一版本课表ui使用装载数据
//    course_ui_data.clear();
//    for(var i=0;i<7;i++){
//      course_ui_data.add( new Row(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children:[
//          Expanded(
//            child: buildButtonColumn(course_data.length<5?
//            '':course_data[i*8].toString().split('kcname:')[1].split('}')[0].toString().trim(),
//                course_data.length<5?-1:
//                _judge_course(course_data[i*8].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8),i*8),
//            flex: 1,
//          ),
//          Expanded(
//            child: buildButtonColumn(course_data.length<5?
//            '':course_data[i*8+1].toString().split('kcname:')[1].split('}')[0].toString().trim(),
//                course_data.length<5?-1:
//                _judge_course(course_data[i*8+1].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+1),i*8+1),
//            flex: 1,
//          ),
//          Expanded(
//            child: buildButtonColumn(course_data.length<5?
//            '':course_data[i*8+2].toString().split('kcname:')[1].split('}')[0].toString().trim(),
//                course_data.length<5?-1:
//                _judge_course(course_data[i*8+2].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+2),i*8+2),
//            flex: 1,
//          ),
//          Expanded(
//            child: buildButtonColumn(course_data.length<5?
//            '':course_data[i*8+3].toString().split('kcname:')[1].split('}')[0].toString().trim(),
//                course_data.length<5?-1:
//                _judge_course(course_data[i*8+3].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+3),i*8+3),
//            flex: 1,
//          ),
//          Expanded(
//            child: buildButtonColumn(course_data.length<5?
//            '':course_data[i*8+4].toString().split('kcname:')[1].split('}')[0].toString().trim(),
//                course_data.length<5?-1:
//                _judge_course(course_data[i*8+4].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+4),i*8+4),
//            flex: 1,
//          ),
//          Expanded(
//            child: buildButtonColumn(course_data.length<5?
//            '':course_data[i*8+5].toString().split('kcname:')[1].split('}')[0].toString().trim(),
//                course_data.length<5?-1:
//                _judge_course(course_data[i*8+5].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+5),i*8+5),
//            flex: 1,
//          ),
//          Expanded(
//            child: buildButtonColumn(course_data.length<5?
//            '':course_data[i*8+6].toString().split('kcname:')[1].split('}')[0].toString().trim(),
//                course_data.length<5?-1:
//                _judge_course(course_data[i*8+6].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+6),i*8+6),
//            flex: 1,
//          ),
//          Expanded(
//            child: buildButtonColumn(course_data.length<5?
//            '':course_data[i*8+7].toString().split('kcname:')[1].split('}')[0].toString().trim(),
//                course_data.length<5?-1:
//                _judge_course(course_data[i*8+7].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+7),i*8+7),
//            flex: 1,
//          ),
//        ],
//      ));
//    }

//    Widget course_grid = new Container(
//      padding: const EdgeInsets.all(20.0),
//      child: new Column(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: course_ui_data,
//      ),
//    );

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '课程                                       ',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color(int.parse(color2)),
                fontWeight: FontWeight.w800,
                fontSize: 25),
          ),
          elevation: 0.0,
          leading: new Container(
            margin: EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new my_login()));
              },
              child: new ClipOval(
                child: new Image.memory(base64.decode(now_login_image_base64),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh, color: Color(int.parse(color2))),
              onPressed: () {
                disdl();
                Navigator.pushAndRemoveUntil(
                    context,
                    CustomRouteJianBian(Index(
                      index: 1,
                    )),
                    (check) => false);
                //Navigator.push(context, CustomRouteJianBian(HomePage()));
              },
            ),
          ],
          backgroundColor: Color(int.parse(color1)),
          centerTitle: true,
        ),
        body: new Container(
          decoration: BoxDecoration(
            color: Color(int.parse(color1)),
          ),
          child: new ListView(
            children: <Widget>[
              new Container(
                  //color:Color(int.parse('0xffF1F1F1')),
                  padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0,bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:  Container(
                          //color:Color(int.parse('0xffF1F1F1')),
                          child: Text(now_choose_date,style: TextStyle(color: Color(int.parse(color2))),textAlign: TextAlign.center,),
                        ),
                        flex: 5,
                      ),
                      Expanded(
                        child: GestureDetector(
                            child: new Icon(Icons.date_range,color: Color(int.parse(color2))),
                            onTap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.parse(now_choose_date),
                                  firstDate: DateTime(2018),
                                  lastDate: DateTime(2030),
                                  builder: (BuildContext context, Widget child) {
                                    return Localizations(
                                        locale: const Locale('zh'),
                                        child: child,
                                        delegates: <LocalizationsDelegate>[
                                          GlobalMaterialLocalizations.delegate,
                                          GlobalWidgetsLocalizations.delegate,
                                        ]);
                                  }).then((DateTime val) {
                                //print(val.toString().split(' ')[0].toString());
                                now_choose_date =
                                    val.toString().split(' ')[0].toString();
                                xia=int.parse(DateTime.parse(now_choose_date).weekday.toString());
                                _query_course_data(
                                    val.toString().split(' ')[0].toString(),
                                    context); // 2018-07-12 00:00:00.000
                              }).catchError((err) {
                                print(err);
                              });
                            }),
                        flex: 1,
                      ),
                    ],
                  )),
              course_grid_ui2(),
            ],
          ),
        ),
      ),
    );
  }

}

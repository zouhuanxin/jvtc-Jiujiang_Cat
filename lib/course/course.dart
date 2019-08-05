import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/my/my_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app01/Learn_teach/learn_teach_login.dart';

class CoursPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _CoursePageState();

}


class _CoursePageState extends State<CoursPage> {
  //课程ui对象集合
  List<Widget>course_ui_data=[];
  //课程数据集合
  List<String>course_data=[];
  //当前选择日期
  String now_choose_date=new DateTime.now().toString().split(' ')[0].toString();

  var login_number=0;

  _course_click(index){
    print(index);
    //0-7 9 16 24 32 40 48
    if(index>7&&index!=8&&index!=16&&index!=24&&index!=32&&index!=40&&index!=48){
      _showmodel('课程信息', course_data[index].split('kcdescribe:')[1].split('kcname:')[0]);
    }
  }

  _query_course_data(String date) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    if(sharedPreferences.getString('jwcookie')!=null){
      String str1=await HttpUtil.query_course('kcinfo',sharedPreferences.getString('jwcookie'),date);
      if(int.parse(json.decode(str1)['code'].toString().trim())==0){
        _string_turn_list(str1);
      }else if(login_number<1){
        login_number=1;
        if(await HttpUtil.Automatic_landing()=='0'){
          _query_course_data(date);
        }else{
          showmodel('请先登录学教平台', Colors.red);
        }
      }else{
       showmodel('无课程信息,请选择有效日期', Colors.red);
      }
    }else{
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new learn_teach_login()));
      showmodel('请先登录学教平台', Colors.red);
    }
  }

  void showmodel(String str,var color){
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

  _string_turn_list(String str){
     course_ui_data.clear();
     course_data.clear();
     Map<String, dynamic> maptemp = json.decode(str);
     String temp=maptemp['data'];
     var arr=json.decode(temp);
     for(var i=0;i<arr.length;i++){
       course_data.add(arr[i].toString());
     }
     setState(() {

     });
  }

  //弹窗
  _showmodel(String title,String content){
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print('initstate');
    _query_course_data(now_choose_date);
  }

  @override
  Widget build(BuildContext context) {

    Column buildButtonColumn(String label,int color,int index) {
      return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Container(
            decoration: new BoxDecoration(
              border: new Border.all(width: color==-1?0.0:2.0, color: color==-1?Color(int.parse(color1)):(color==0?Colors.cyan:Colors.blue)),
              color: color==-1?Color(int.parse(color1)):(color==0?Colors.cyan:Colors.blue),
              borderRadius: new BorderRadius.all(new Radius.circular(10.0))
            ),
            height: 60,
            width: 50,
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.only(top: 8.0,left: 2.0,right: 2.0),
            alignment: Alignment.center,
            child: new GestureDetector(
              child: new Text(
                label,
                textAlign:TextAlign.center,
                style: new TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              onTap: (){
                _course_click(index);
              },
            ),
          ),
        ],
      );
    };

    //判断课程是否为空 即这个时间段有没有课
    //-1为空表示无课全白表示 0为课表说明 0-7 9 16 24 32 40 48
    // 1-2学分黄色#FFBB4A  1 2-4学分蓝色#4683FF  2 4以上红色#1CCCBE 均配白色字体#F1F1F1  3
    _judge_course(String str,int index){
      if(str==''){
        return -1;
      }else{
        if(index>=0&&index<=7){
          return 0;
        }else{
          return 1;
        }
      }
    }
    //数据写入
    for(var i=0;i<7;i++){
      course_ui_data.add( new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          Expanded(
            child: buildButtonColumn(course_data.length<5?
            '':course_data[i*8].toString().split('kcname:')[1].split('}')[0].toString().trim(),
                course_data.length<5?-1:
                _judge_course(course_data[i*8].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8),i*8),
            flex: 1,
          ),
          Expanded(
            child: buildButtonColumn(course_data.length<5?
            '':course_data[i*8+1].toString().split('kcname:')[1].split('}')[0].toString().trim(),
                course_data.length<5?-1:
                _judge_course(course_data[i*8+1].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+1),i*8+1),
            flex: 1,
          ),
          Expanded(
            child: buildButtonColumn(course_data.length<5?
            '':course_data[i*8+2].toString().split('kcname:')[1].split('}')[0].toString().trim(),
                course_data.length<5?-1:
                _judge_course(course_data[i*8+2].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+2),i*8+2),
            flex: 1,
          ),
          Expanded(
            child: buildButtonColumn(course_data.length<5?
            '':course_data[i*8+3].toString().split('kcname:')[1].split('}')[0].toString().trim(),
                course_data.length<5?-1:
                _judge_course(course_data[i*8+3].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+3),i*8+3),
            flex: 1,
          ),
          Expanded(
            child: buildButtonColumn(course_data.length<5?
            '':course_data[i*8+4].toString().split('kcname:')[1].split('}')[0].toString().trim(),
                course_data.length<5?-1:
                _judge_course(course_data[i*8+4].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+4),i*8+4),
            flex: 1,
          ),
          Expanded(
            child: buildButtonColumn(course_data.length<5?
            '':course_data[i*8+5].toString().split('kcname:')[1].split('}')[0].toString().trim(),
                course_data.length<5?-1:
                _judge_course(course_data[i*8+5].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+5),i*8+5),
            flex: 1,
          ),
          Expanded(
            child: buildButtonColumn(course_data.length<5?
            '':course_data[i*8+6].toString().split('kcname:')[1].split('}')[0].toString().trim(),
                course_data.length<5?-1:
                _judge_course(course_data[i*8+6].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+6),i*8+6),
            flex: 1,
          ),
          Expanded(
            child: buildButtonColumn(course_data.length<5?
            '':course_data[i*8+7].toString().split('kcname:')[1].split('}')[0].toString().trim(),
                course_data.length<5?-1:
                _judge_course(course_data[i*8+7].toString().split('kcname:')[1].split('}')[0].toString().trim(),i*8+7),i*8+7),
            flex: 1,
          ),
        ],
      ));
    }

    Widget course_grid = new Container(
      padding: const EdgeInsets.all(20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: course_ui_data,
      ),
    );

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('课程                                       ',
            textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 25),),
          elevation: 0.0,
          leading: new Container(
            margin: EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: (){
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new my_login()));
              },
              child: new ClipOval(
                child: new Image.memory(base64.decode(now_login_image_base64),fit: BoxFit.fill),
              ),
            ),
          ),
          backgroundColor: Color(int.parse(color1)),
          centerTitle: true,
        ),
        body: new Container(
          decoration: BoxDecoration(
            color: Color(int.parse(color1))
          ),
          child: new ListView(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 5.0,left: 10.0,right: 10.0),
                child: RaisedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2030),
                        builder: (BuildContext context, Widget child) {
                          return Localizations(
                              locale: const Locale('zh'),
                              child: child,
                              delegates: <LocalizationsDelegate>[
                                GlobalMaterialLocalizations.delegate,
                                GlobalWidgetsLocalizations.delegate,
                              ]
                          );
                        }
                    ).then((DateTime val) {
                      //print(val.toString().split(' ')[0].toString());
                      now_choose_date=val.toString().split(' ')[0].toString();
                      _query_course_data(val.toString().split(' ')[0].toString()); // 2018-07-12 00:00:00.000
                    }).catchError((err) {
                      print(err);
                    });
                  },
                  color: Colors.lightBlueAccent,
                  textColor: Colors.white,
                  child: Text(now_choose_date),
                  elevation: 5.0,
                ),
              ),
              course_grid,
            ],
          ),
        ),
      ),
    );
  }
}
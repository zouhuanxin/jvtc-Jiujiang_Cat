import 'package:flutter/material.dart';
import 'package:flutter_app01/Learn_teach/learn_teach_login.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Learn_teach/person_center/person_center.dart';
import 'package:flutter_app01/Learn_teach/Activity_scores/activity_scores.dart';
import 'package:flutter_app01/Learn_teach/Results_query/results_query.dart';
import 'package:flutter_app01/Learn_teach/Activity_evaluation/activity_evaluation.dart';
import 'package:flutter_app01/Learn_teach/dormitory_knowing/dormitory_knowing.dart';

class learn_tach extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>new learn_teach_State();
}

class learn_teach_State extends State<learn_tach>{
  var learn_state='学工平台未登陆';
  var teach_state='教务平台未登陆';

  var learn_teach_student_name='';
  var learn_teach_student_id='';


  void setinitdata() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs.getString('learn_teach_student_name')!=null){
        learn_teach_student_name=prefs.getString('learn_teach_student_name');
      }
      if(prefs.getString('learn_teach_student_id')!=null){
        learn_teach_student_id=prefs.getString('learn_teach_student_id');
      }
      if(prefs.getString('learn_teach_data')!=null){
        learn_state='学工平台已登陆';
        teach_state='教务平台已登陆';
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setinitdata();
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
            color: Color(int.parse(color1)),
          ),
          height: 100,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(5.0),
          child: new Row(
            children: <Widget>[
              Expanded(
                child: new Image(image: new NetworkImage('http://xz.jvtc.jx.cn/JVTC_XG/DownLoad/Student/'+learn_teach_student_id+'.jpg')),
                flex: 1,
              ),
              Expanded(
                child: new Column(
                  children: <Widget>[
                    Expanded(
                      child: new Text(learn_teach_student_name,
                        textAlign:TextAlign.center,style: TextStyle(color: Color(int.parse(color2)),),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: new Text(learn_state,
                        textAlign:TextAlign.center,
                        style: TextStyle(
                          color: Color(int.parse(color3)),
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: new Text(teach_state,
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
              new MaterialPageRoute(builder: (context) => new learn_teach_login()));
        },
      );
    }

    _body_model_click(String str){
      print(str);
      switch(str.toString().trim()){
        case '我的资料':
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new PersonPage()));
          break;
        case '我的素拓得分':
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new activity_scores()));
          break;
        case '成绩查询':
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new results_query()));
          break;
        case '活动评价':
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new activity_evaluation()));
          break;
        case '查寝列表':
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new dormitory_knowing()));
          break;
      }
    }

    Widget body_component01(String imageurl,String label){
       return new Container(
        decoration: new BoxDecoration(
          border: new Border.all(width: 1.0, color: Color(int.parse(color1))),
          color: Color(int.parse(color1)),
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
                  textAlign: TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),),),
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
          body_component01('images/2.0.x/ziliao.png','        我的资料'),
          body_component01('images/2.0.x/ziyuan.png','        我的素拓得分'),
          body_component01('images/2.0.x/luqufenshubiao.png','        成绩查询'),
          body_component01('images/2.0.x/pingjia.png','        活动评价'),
          body_component01('images/2.0.x/cq.png','        查寝列表'),
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('学教平台                                            ',
          textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
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
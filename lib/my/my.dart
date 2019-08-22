import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Animation_list.dart';
import 'package:flutter_app01/Utils/WebViewPage.dart';
import 'package:flutter_app01/course/course.dart';
import 'package:meta/meta.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter_app01/Bean/lunbo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'dart:convert';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/my/my_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/index/index.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'upload_password.dart';

class my extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>my_State();

}

class my_State extends State<my>{
  SharedPreferences sharedPreferences;

  //Data initialization
  void _load_data() async{
    sharedPreferences=await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load_data();
  }

  void component02_click(String str){
    switch(str){
      case '修改密码':
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new upload_password()));
        break;
      case '检查更新':
        IndexState().bmob_get_app_Version_information(context,'my');
        break;
      case '免责声明':
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new WebViewPage(url:'http://47.94.255.154:8080/zhxword/九职小猫手免责声明.html',title:'免责声明')));
        break;
      case '退出登陆':
        _showmodel_cancel_login_stystem('退出登陆','你确定退出登陆吗?');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('个人中心                                       ',
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh,color: Color(int.parse(color2))),
              onPressed: (){
                CoursePageState cp=new CoursePageState();
                cp.disdl();
                Navigator.pushAndRemoveUntil(context, CustomRouteJianBian(Index(index: 2,)), (check) => false);
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
                topimage(),
                SizedBox(height: 30,),
                new Align(
                  alignment: FractionalOffset.center,
                  child: new Text(username,textAlign: TextAlign.center,style: TextStyle(color:Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 30),),
                ),
                SizedBox(height: 30,),
                body_component01('images/2.0.x/dark_model.png', '暗黑模式'),
                body_component02('images/2.0.x/uploadpassword.png',40, '修改密码'),
                body_component02('images/2.0.x/app_update.png',45, '检查更新'),
                body_component02('images/2.0.x/mzsm.png',45, '免责声明'),
                body_component02('images/2.0.x/cancel_stystem.png',35, '退出登陆'),
                SizedBox(height: 10,)
              ],
            ),
          ),
      ),
    );
  }

  //top
  Widget topimage(){
    return new Container(
      margin: EdgeInsets.all(10.0),
      child: new Align(
        alignment: FractionalOffset.center,
        child: new GestureDetector(
          child: new ClipOval(
            child: new Image.memory(base64.decode(now_login_image_base64),fit: BoxFit.fill,height: 100,width: 100,),
          ),
        ),
      ),
    );
  }

  Widget body_component01(String imageurl,String label){
    return new Container(
      decoration: new BoxDecoration(
        border: new Border.all(width: 1.0, color: Color(int.parse(color1))),
        color: Color(int.parse(color1)),
      ),
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
      //margin: const EdgeInsets.all(5.0),
      child:  new GestureDetector(
        child: new Row(
          children: <Widget>[
            Expanded(
              child: new ImageIcon(AssetImage(imageurl),size: 45,color: Color(int.parse(color2)),),
              flex: 2,
            ),
            Expanded(
              child: new Text(label,
                textAlign: TextAlign.left,style: TextStyle(fontSize: 20,color: Color(int.parse(color2)),),),
              flex: 10,
            ),
            Expanded(
              child: new Switch(
                value: dart_model,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                onChanged: (bool value) {
                  setState(() {
                    dart_model=value;
                    if(dart_model==true){
                      sharedPreferences.setString('color1', '0xff000000');
                      sharedPreferences.setString('color2', '0xffFFFAFA');
                    }else{
                      sharedPreferences.setString('color1', '0xffFFFAFA');
                      sharedPreferences.setString('color2', '0xff000000');
                    }
                    sharedPreferences.setString('dart_model', dart_model.toString());
                    color1=sharedPreferences.getString('color1');
                    color2=sharedPreferences.getString('color2');
                    bus.emit("dart_event", (arg){});
                  });
                },
              ),
              flex: 1,
            ),
          ],
        ),
        onTap:(){
          
        },
      ),
    );
  }

  Widget body_component02(String imageurl,double imagesize,String label){
    return new Container(
      decoration: new BoxDecoration(
        border: new Border.all(width: 1.0, color: Color(int.parse(color1))),
        color: Color(int.parse(color1)),
      ),
      padding: const EdgeInsets.all(10.0),
     // margin: const EdgeInsets.all(5.0),
      child:  new GestureDetector(
        child: new Row(
          children: <Widget>[
            Expanded(
              child: new ImageIcon(AssetImage(imageurl),size: imagesize,color: Color(int.parse(color2)),),
              flex: 2,
            ),
            Expanded(
              child: new Text(label,
                textAlign: TextAlign.left,style: TextStyle(fontSize: 20,color: Color(int.parse(color2)),),),
              flex: 10,
            ),
            Expanded(
              child: new Text(''),
              flex: 1,
            ),
          ],
        ),
        onTap:(){
          component02_click(label);
        },
      ),
    );
  }

   //弹窗
  _showmodel_cancel_login_stystem(String title,String content){
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
                _cancel_login_stystem();
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }


  void _cancel_login_stystem(){
    Fluttertoast.showToast(
        msg: "你已退出",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );

    sharedPreferences.setString('now_login_image_base64', '');
    sharedPreferences.setString('username', '');
    sharedPreferences.setString('phone', '');
    sharedPreferences.setString('login_state', 'false');

    now_login_image_base64=default_image;
    username='未登陆';
    phone='未登陆';
    login_state=false;

    setState(() {

    });
  }
}
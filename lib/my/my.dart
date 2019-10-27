import 'dart:async';
import 'dart:io';

import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Animation_list.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/Utils/WebViewPage.dart';
import 'package:flutter_app01/common/Loading_Toast.dart';
import 'package:flutter_app01/course/course.dart';
import 'package:flutter_app01/home/LostandFound/lf_my.dart';
import 'package:flutter_app01/home/LostandFound/lf_mylose.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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
import 'BindStudentid/View/bind_stu_view.dart';
import 'my_password.dart';
import 'upload_password.dart';

class my extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>my_State();

}

class my_State extends State<my>{
  SharedPreferences sharedPreferences;
  static const androidplatform = const MethodChannel("test");

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

  void _showmodel(mes, var type, var color) {
    Fluttertoast.showToast(
        msg: mes,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void component02_click(String str){
    switch(str){
      case '修改密码':
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new my_password()));
        break;
      case '拾取物品':
        if(login_state==true){
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new lf_my()));
        }else{
          _showmodel('请先登陆',Toast.LENGTH_SHORT,Colors.red);
        }
        break;
      case '遗失物品':
        if(login_state==true){
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new lf_mylose()));
        }else{
          _showmodel('请先登陆',Toast.LENGTH_SHORT,Colors.red);
        }
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
      case '更换头像':
        _showmodel2();
        break;
      case '绑定学号':
        if(login_state==true){
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new bind_stu_view()));
        }else{
          _showmodel('请先登陆',Toast.LENGTH_SHORT,Colors.red);
        }
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
                if(login_state==false){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new my_login()));
                }else{
                  _showmodel('你已登陆', Toast.LENGTH_SHORT, Colors.red);
                }
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
            PopupMenuButton(
              icon: Icon(Icons.add,color: Color(int.parse(color2))),
              itemBuilder: (BuildContext context) =>
              <PopupMenuItem<String>>[
                PopupMenuItem<String>(child: Container(
                  width:ScreenUtil().setWidth(245),
                  child: Row(
                    children: <Widget>[
                      Image.asset('images/2.2.1.x/xuesheng.png',height: ScreenUtil().setHeight(100),),
                      Text("学生版",style: TextStyle(color: ui_model=='学生版'?Colors.blue:Colors.black26),)
                    ],
                  ),
                ), value: "学生版",),
                PopupMenuItem<String>(child: Container(
                  width:ScreenUtil().setWidth(245),
                  child: Row(
                    children: <Widget>[
                      Image.asset('images/2.2.1.x/jiaoshijie.png',height: ScreenUtil().setHeight(100),),
                      Text("教师版",style: TextStyle(color: ui_model=='教师版'?Colors.blue:Colors.black26))
                    ],
                  ),
                ), value: "教师版",),
              ],
              onSelected: (String action) {
                switch (action) {
                  case "学生版":
                    setState(() {
                      ui_model='学生版';
                      Util.open_zbui(context);
                    });
                    sharedPreferences.setString('ui_model', ui_model);
                    break;
                  case "教师版":
                    setState(() {
                      ui_model='教师版';
                      Util.open_zbui(context);
                    });
                    sharedPreferences.setString('ui_model', ui_model);
                    break;
                }
              },
              onCanceled: () {
                print("onCanceled");
              },
            )
          ],
          backgroundColor: Color(int.parse(color1)),
          centerTitle: true,
        ),
          body: new Container(
            decoration: BoxDecoration(
              color: Color(int.parse(color1)),
            ),
            child: ui_model=='学生版'?lb1():lb2(),
          ),
      ),
    );
  }

  Widget lb1(){
    return new ListView(
      children: <Widget>[
        topimage(),
        SizedBox(height: 30,),
        new Align(
          alignment: FractionalOffset.center,
          child: new Text(username,textAlign: TextAlign.center,style: TextStyle(color:Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 30),),
        ),
        SizedBox(height: 30,),
        body_component01('images/2.2.1.x/ahms.png', '暗黑模式'),
        course_tzl('images/2.2.1.x/kbtzl.png', '课表通知栏'),
        body_component02('images/2.2.1.x/sdxh.png',40, '绑定学号'),
        body_component02('images/2.2.1.x/xgmm.png',40, '修改密码'),
        body_component02('images/2.2.1.x/ghtx.png',35, '更换头像'),
        body_component02('images/2.2.1.x/sqwp.png',40, '拾取物品'),
        body_component02('images/2.2.1.x/yswp.png',40, '遗失物品'),
        // body_component02('images/2.0.x/myzlxg.png',40, '资料修改'),
        body_component02('images/2.2.1.x/jcgx.png',45, '检查更新'),
        body_component02('images/2.2.1.x/mzsm.png',45, '免责声明'),
        body_component02('images/2.2.1.x/tcdl.png',35, '退出登陆'),
        SizedBox(height: 10,)
      ],
    );
  }

  Widget lb2(){
    return new ListView(
      children: <Widget>[
        topimage(),
        SizedBox(height: 30,),
        new Align(
          alignment: FractionalOffset.center,
          child: new Text(username,textAlign: TextAlign.center,style: TextStyle(color:Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 30),),
        ),
        SizedBox(height: 30,),
        body_component01('images/2.2.1.x/ahms.png', '暗黑模式'),
        course_tzl('images/2.2.1.x/kbtzl.png', '课表通知栏'),
        body_component02('images/2.2.1.x/sdxh.png',40, '绑定学号'),
        body_component02('images/2.2.1.x/xgmm.png',40, '修改密码'),
        body_component02('images/2.2.1.x/ghtx.png',35, '更换头像'),
        // body_component02('images/2.0.x/myzlxg.png',40, '资料修改'),
        body_component02('images/2.2.1.x/jcgx.png',45, '检查更新'),
        body_component02('images/2.2.1.x/mzsm.png',45, '免责声明'),
        body_component02('images/2.2.1.x/tcdl.png',35, '退出登陆'),
        SizedBox(height: 10,)
      ],
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

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    String temp=image.toString().split(':')[1].trim();
    //print('image:${temp.substring(1,temp.length-1)}');
    _imagetobase64(temp.substring(1,temp.length-1));
  }
  void _imagetobase64(String value) async {
    String path = await androidplatform.invokeMethod("getFile", {"path": value});
    File file = new File(path);
    List bytes = await file.readAsBytes();
    String bs64=base64Encode(bytes);
    if (bs64.length > 180000) {
      bs64 = null;
      _showmodel('图片过大,请重新选择头像', Toast.LENGTH_SHORT, Colors.blue);
    }else{
      _uploadimage(bs64);
    }
  }

  //更新头像数据
  void _uploadimage(String image){
    //由于要适配老版本所以这里不能直接使用objectid 应该通过当前登陆手机号码去查询objectid
    BmobQuery<QTuser> query = BmobQuery();
    query.addWhereEqualTo("phone", phone);
    query.queryObjects().then((data) {
      List<QTuser>templist = data.map((i) => QTuser.fromJson(i)).toList();
      QTuser blog = QTuser();
      blog.objectId = templist[0].objectId;
      blog.imagebase64=image;
      blog.update().then((BmobUpdated bmobUpdated) {
        // print("修改一条数据成功：${bmobUpdated.updatedAt}");
        _showmodel('修改头像成功，正在更新。', Toast.LENGTH_SHORT, Colors.blue);
        get_image();
      }).catchError((e) {
        _showmodel('稍后重试', Toast.LENGTH_SHORT, Colors.red);
      });
    }).catchError((e) {});
  }
  //请求头像数据
  void get_image(){
    BmobQuery<QTuser> query = BmobQuery();
    query.addWhereEqualTo("phone", phone);
    query.queryObjects().then((data) {
      setState(() {
        List<QTuser>templist = data.map((i) => QTuser.fromJson(i)).toList();
        now_login_image_base64=templist[0].imagebase64;
        sharedPreferences.setString('now_login_image_base64', now_login_image_base64);
      });
    }).catchError((e) {});
  }

  Widget body_component01(String imageurl,String label){
    return new Container(
      decoration: new BoxDecoration(
        border: new Border.all(width: 1.0, color: Color(int.parse(color1))),
        color: Color(int.parse(color1)),
      ),
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
      //margin: const EdgeInsets.all(5.0),
      child:  new GestureDetector(
        child: new Row(
          children: <Widget>[
            new ClipOval(
              child: new Image(
                image: new AssetImage(imageurl),
                height: 50,
                width: 50,
              ),
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

  Widget course_tzl(String imageurl,String label){
    return new Container(
      decoration: new BoxDecoration(
        border: new Border.all(width: 1.0, color: Color(int.parse(color1))),
        color: Color(int.parse(color1)),
      ),
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
      //margin: const EdgeInsets.all(5.0),
      child:  new GestureDetector(
        child: new Row(
          children: <Widget>[
            new ClipOval(
              child: new Image(
                image: new AssetImage(imageurl),
                height: 50,
                width: 50,
              ),
            ),
            Expanded(
              child: new Text(label,
                textAlign: TextAlign.left,style: TextStyle(fontSize: 20,color: Color(int.parse(color2)),),),
              flex: 10,
            ),
            Expanded(
              child: new Switch(
                value: course_bol,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                onChanged: (bool value) {
                  setState(() {
                    course_bol=value;
                    if(course_bol==true){
                      _query_course_data(new DateTime.now().toString().split(' ')[0].toString(),context);
                    }else{
                      cancel_tzl();
                    }
                    sharedPreferences.setString('course_bol', course_bol.toString());
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
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
     // margin: const EdgeInsets.all(5.0),
      child:  new GestureDetector(
        child: new Row(
          children: <Widget>[
            new ClipOval(
              child: new Image(
                image: new AssetImage(imageurl),
                height: 50,
                width: 50,
              ),
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
              child: new Text("确定",style: TextStyle(color: Colors.red),),
              onPressed: () {
                _cancel_login_stystem();
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  //弹窗
  _showmodel2(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('系统提示'),
          content: Text(('确定更换头像嘛')),
          actions: <Widget>[
            new FlatButton(
              child: new Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("确定",style: TextStyle(color: Colors.red),),
              onPressed: () {
                _openGallery();
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
    sharedPreferences.setString('objectid', '');
    sharedPreferences.setString('login_state', 'false');

    now_login_image_base64=default_image;
    username='点击左上角登陆';
    phone='未登陆';
    login_state=false;

    setState(() {

    });
  }

  var login_number = 0;
  //访问课程信息
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
          //showmodel('请先登录学教平台', Colors.red);
        }
      } else {
        //showmodel('无课程信息,请选择有效日期', Colors.red);
      }
    } else {
      _showmodel('请先登录学教平台', Toast.LENGTH_SHORT,Colors.red);
      setState(() {
        course_bol=false;
      });
    }
  }
  //课程数据集合
  List<String> course_data = [];
  _string_turn_list(String str) async{
    print(str);
    course_data.clear();
    Map<String, dynamic> maptemp = json.decode(str);
    String temp = maptemp['data'];
    var arr = json.decode(temp);
    for (var i = 0; i < arr.length; i++) {
      course_data.add(arr[i].toString());
    }
    //数据准备完毕开启通知栏
    await androidplatform.invokeMethod("course_tzl", {"list": course_data});
    //_showmodel('开启成功', Toast.LENGTH_SHORT,Colors.blue);
  }
  //cancelNotification
  void cancel_tzl() async{
    await androidplatform.invokeMethod("cancelNotification", {"id":1});
  }
}
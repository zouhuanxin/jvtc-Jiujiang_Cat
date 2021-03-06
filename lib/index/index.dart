import 'dart:async';
import 'dart:convert';

import 'package:data_plugin/bmob/realtime/change.dart';
import 'package:data_plugin/bmob/realtime/client.dart';
import 'package:data_plugin/bmob/realtime/real_time_data_manager.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app01/Bean/Daily_activity.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/Bean/gxinfo.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/Utils/WebViewPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'navigation_icon_view.dart';
import 'package:flutter_app01/home/home.dart';
import 'package:flutter_app01/course/course.dart';
import 'package:flutter_app01/my/my.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:data_plugin/bmob/bmob_query.dart';

// 创建一个 带有状态的 Widget Index
class Index extends StatefulWidget {
  //  固定的写法
  final int index;

  const Index({Key key, this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    //resh_state=index;
    IndexState indexState = new IndexState();
    indexState.currentIndex = index == null ? 0 : index;
    return indexState;
  }
}

// 要让主页面 Index 支持动效，要在它的定义中附加mixin类型的对象TickerProviderStateMixin
class IndexState extends State<Index> with TickerProviderStateMixin {
  static const androidplatform = const MethodChannel("test");

  @override
  void dispose() {
    super.dispose();

    bus.off("dart_event"); //移除广播机制
//    if (_streamSubscription != null) {
//      _streamSubscription.cancel();
//      _streamSubscription = null;
//    }
  }

  int currentIndex = 0; // 当前界面的索引值
  List<NavigationIconView> _navigationViews; // 底部图标按钮区域
  List<StatefulWidget> _pageList; // 用来存放我们的图标对应的页面
  StatefulWidget _currentPage; // 当前的显示页面

  //与安卓原生进行通信
  static const EventChannel _eventChannelPlugin = EventChannel("EventChannelPlugin");
  StreamSubscription _streamSubscription;

  // 定义一个空的设置状态值的方法
  void _rebuild() {
    setState(() {});
  }

  //通知栏点击启动打开浏览器监听
  void _onToDart(message) {
    //print(message);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new WebViewPage(
                url: message,
                title: '推广')));
  }
  //当native出错时，发送的数据
  void _onToDartError(error) {    print(error);  }
  //当native发送数据完成时调用的方法，每一次发送完成就会调用
  void _onDone() {    print("消息传递完毕");  }

  @override
  void initState() {
    super.initState();
    if (widget.index == null) {
      bmob_get_app_Version_information(context, 'index');
    }
    _load_bottom();
    _load_default_color();
    //监听登录事件
    bus.on("dart_event", (arg) {
      setState(() {
        currentIndex = 2;
        _load_bottom();
      });
    });

    _streamSubscription = _eventChannelPlugin
        .receiveBroadcastStream()
        .listen(_onToDart, onError: _onToDartError, onDone: _onDone);
  }

  void _load_bottom() {
    // 初始化导航图标
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
          icon: new Icon(
            Icons.assessment,
            color: Color(int.parse(color2)),
            size: 30,
          ),
          title: new Text(
            currentIndex == 0 ? '___' : '',
            style: TextStyle(color: Color(int.parse(color2))),
          ),
          vsync: this), // vsync 默认属性和参数
      new NavigationIconView(
          icon: new Icon(Icons.grid_on,
              color: Color(int.parse(color2)), size: 30),
          title: new Text(
            currentIndex == 1 ? '___' : '',
            style: TextStyle(color: Color(int.parse(color2))),
          ),
          vsync: this),
      new NavigationIconView(
          icon: new Icon(Icons.face, color: Color(int.parse(color2)), size: 30),
          title: new Text(
            currentIndex == 2 ? '___' : '',
            style: TextStyle(color: Color(int.parse(color2))),
          ),
          vsync: this)
    ];

    // 给每一个按钮区域加上监听
    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    // 将我们 bottomBar 上面的按钮图标对应的页面存放起来，方便我们在点击的时候
    _pageList = <StatefulWidget>[new HomePage(), new CoursPage(), new my()];
    _currentPage = _pageList[currentIndex];
  }

  SharedPreferences sharedPreferences;
  //Load default color
  void _load_default_color() async {
    // print('_load_default_color');
    sharedPreferences = await SharedPreferences.getInstance();
    //添加活跃度信息
    bmob_add_Daily_activity();

    //dart model and light model setting
    if (sharedPreferences.getString('startnumber') == null) {
      sharedPreferences.setString('color1', '0xffFFFAFA');
      sharedPreferences.setString('color2', '0xff000000');
//      sharedPreferences.setString('color3', '0xff0000FF');
//      sharedPreferences.setString('color4', '0xffBEBEBE');

      sharedPreferences.setString('startnumber', '1');
    }
    color1 = sharedPreferences.getString('color1');
    color2 = sharedPreferences.getString('color2');
//    color3=sharedPreferences.getString('color3');
//    color4=sharedPreferences.getString('color4');
    //暗黑模式
    if (sharedPreferences.getString('dart_model') == 'true') {
      dart_model = true;
    } else {
      dart_model = false;
    }

    //课程表通知是否开启
    if (sharedPreferences.getString('course_bol') == 'true') {
      course_bol = true;
      _query_course_data(new DateTime.now().toString().split(' ')[0].toString(),context);
    } else {
      course_bol = false;
    }

    //login state setting
    if (sharedPreferences.getString('login_state') == 'true') {
      login_state = true;
      heduishefen();
    } else {
      login_state = false;
    }

    //ui版本模式检测
    if(sharedPreferences.getString('ui_model')!=null){
      ui_model=sharedPreferences.getString('ui_model');
    }

    setState(() {
      _load_bottom();
    });
  }

  //Check the app version update
  bmob_get_app_Version_information(BuildContext context, note) {
    BmobQuery<gxinfo> query = BmobQuery();
    query.addWhereNotEqualTo("url", "12%%%3");
    query.queryObjects().then((data) {
      List<gxinfo> sfs = data.map((i) => gxinfo.fromJson(i)).toList();
      if (app_version.toString().trim() !=
          sfs[sfs.length - 1].gxversion.toString().trim()) {
        showmodel(
            context,
            '程序更新啦',
            sfs[sfs.length - 1].text,
            sfs[sfs.length - 1].url,
            sfs[sfs.length - 1].url2,
            sfs[sfs.length - 1].url3);
      } else {
        if (note == 'my') {
          Fluttertoast.showToast(
              msg: "已经是最新版本，当前版本号:$app_version",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIos: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }).catchError((e) {});
  }

  //增加活跃度
  bmob_add_Daily_activity() async{
    String date=new DateTime.now().toString().split(' ')[0].toString();
    if(sharedPreferences.getString('date')!=null){
      String sharedate=await sharedPreferences.getString('date');
      if(sharedate==date){
        return;
      }
    }
    BmobQuery<Daily_activity> query = BmobQuery();
    query.addWhereEqualTo("date", date);
    query.queryObjects().then((data) {
      List<Daily_activity> templist = data.map((i) => Daily_activity.fromJson(i)).toList();
      Daily_activity blog = Daily_activity();
      if(templist.length==0){
        //添加
        blog.date=date;
        blog.number='1';
        blog.save().then((BmobSaved bmobSaved) {}).catchError((e) {});
      }else{
        //修改
        blog.objectId=templist[0].objectId;
        blog.number=(int.parse(templist[0].number)+1).toString();
        blog.update().then((BmobUpdated bmobUpdated) {}).catchError((e) {});
      }
      sharedPreferences.setString('date',date);
    }).catchError((e) {});
  }

  void heduishefen() async{
    BmobQuery<QTuser> query = BmobQuery();
    query.addWhereEqualTo("phone",await sharedPreferences.getString('phone'));
    query.queryObjects().then((data) {
      List<QTuser> templist = data.map((i) => QTuser.fromJson(i)).toList();
      setState(() {
        username=templist[0].username;
        phone=templist[0].phone;
        objectid=templist[0].objectId;
        now_studentid=templist[0].studentid;
        now_login_image_base64 = templist[0].imagebase64;
        _load_bottom();
      });
      sharedPreferences.setString('username', username);
      sharedPreferences.setString('phone', phone);
      sharedPreferences.setString('objectid', objectid);
      sharedPreferences.setString('now_studentid', now_studentid);
      sharedPreferences.setString('now_login_image_base64', templist[0].imagebase64);
    }).catchError((e) {});
  }

  //Prompt to update the application winod
  showmodel(BuildContext context, String title, String content, String url,
      String url2, String url3) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text((content)),
              actions: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        new FlatButton(
                          child: new Text("取消"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        new Offstage(
                          offstage: url != '' ? false : true,
                          child: new FlatButton(
                            child: new Text(
                              "${url != '' ? '线路一' : ''}",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              launchURL(url);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        new Offstage(
                          offstage: url2 != '' ? false : true,
                          child: new FlatButton(
                            child: new Text(
                              "${url2 != '' ? '线路二' : ''}",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              launchURL(url2);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        new Offstage(
                          offstage: url3 != '' ? false : true,
                          child: new FlatButton(
                            child: new Text(
                              "${url3 != '' ? '线路三' : ''}",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              launchURL(url3);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ));
  }

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
        if (await Util.auto_login3() == 0) {
          _query_course_data(date, context);
        } else {
          //showmodel('请先登录学教平台', Colors.red);
        }
      } else {
        //showmodel('无课程信息,请选择有效日期', Colors.red);
      }
    }
  }
  //课程数据集合
  List<String> course_data = [];
  _string_turn_list(String str) async{
    //print(str);
    course_data.clear();
    Map<String, dynamic> maptemp = json.decode(str);
    String temp = maptemp['data'];
    var arr = json.decode(temp);
    for (var i = 0; i < arr.length; i++) {
      course_data.add(arr[i].toString());
    }
    //数据准备完毕开启通知栏
    await androidplatform.invokeMethod("course_tzl", {"list": course_data});
  }

  @override
  Widget build(BuildContext context) {
    // 方式一：默认设置宽度1080px，高度1920px
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    // 声明定义一个 底部导航的工具栏
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      backgroundColor: Color(int.parse(color1)),
      items: _navigationViews
          .map((NavigationIconView navigationIconView) =>
              navigationIconView.item)
          .toList(),
      // 添加 icon 按钮
      currentIndex: currentIndex,
      // 当前点击的索引值
      type: BottomNavigationBarType.fixed,
      // 设置底部导航工具栏的类型：fixed 固定
      onTap: (int index) {
        //为了方便判断是自启动还是手动点击课表 当手动点击课表时候才自动跳转登陆界面在没有登陆的情况下  启动程序与刷新课表界面不跳出自动登陆
        resh_state = index;
        if (index == 1) {
          CoursePageState cp = new CoursePageState();
          cp.resh_course_data(context);
        }
        // 添加点击事件
        setState(() {
          // 点击之后，需要触发的逻辑事件
          _navigationViews[currentIndex].controller.reverse();
          currentIndex = index;
          _navigationViews[currentIndex].controller.forward();
          _currentPage = _pageList[currentIndex];
          _load_bottom();
        });
      },
    );

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: _pageList,
        ),
        //new Center(child: _currentPage // 动态的展示我们当前的页面
        //            )
        bottomNavigationBar: bottomNavigationBar, // 底部工具栏
      ),
      theme: new ThemeData(
        primarySwatch: Colors.blue, // 设置主题颜色
      ),
    );
  }
}

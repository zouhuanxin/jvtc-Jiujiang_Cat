import 'package:data_plugin/bmob/realtime/change.dart';
import 'package:data_plugin/bmob/realtime/client.dart';
import 'package:data_plugin/bmob/realtime/real_time_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/gxinfo.dart';
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
  @override
  State<StatefulWidget> createState() => new IndexState();
}

// 要让主页面 Index 支持动效，要在它的定义中附加mixin类型的对象TickerProviderStateMixin
class IndexState extends State<Index> with TickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
    bus.off("icon"); //移除广播机制
  }

  int _currentIndex = 0; // 当前界面的索引值
  List<NavigationIconView> _navigationViews; // 底部图标按钮区域
  List<StatefulWidget> _pageList; // 用来存放我们的图标对应的页面
  StatefulWidget _currentPage; // 当前的显示页面

  // 定义一个空的设置状态值的方法
  void _rebuild() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    bmob_get_app_Version_information(context, 'index');
    _load_bottom();
    _load_default_color();
    //监听登录事件
    bus.on("dart_event", (arg) {
      setState(() {
        _currentIndex = 2;
        _load_bottom();
      });
    });
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
            _currentIndex == 0 ? '___' : '',
            style: TextStyle(color: Color(int.parse(color2))),
          ),
          vsync: this), // vsync 默认属性和参数
      new NavigationIconView(
          icon: new Icon(Icons.grid_on,
              color: Color(int.parse(color2)), size: 30),
          title: new Text(
            _currentIndex == 1 ? '___' : '',
            style: TextStyle(color: Color(int.parse(color2))),
          ),
          vsync: this),
      new NavigationIconView(
          icon: new Icon(Icons.face, color: Color(int.parse(color2)), size: 30),
          title: new Text(
            _currentIndex == 2 ? '___' : '',
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
    _currentPage = _pageList[_currentIndex];
  }

  //Load default color
  void _load_default_color() async {
    // print('_load_default_color');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

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
    if (sharedPreferences.getString('dart_model') == 'true') {
      dart_model = true;
    } else {
      dart_model = false;
    }

    //login state setting
    if (sharedPreferences.getString('login_state') == 'true') {
      login_state = true;
      now_login_image_base64 =
          sharedPreferences.getString('now_login_image_base64');
      phone = sharedPreferences.getString('phone');
      username = sharedPreferences.getString('username');
    } else {
      login_state = false;
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
        showmodel(context, '程序更新啦', sfs[sfs.length - 1].text,
            sfs[sfs.length - 1].url);
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

  //Prompt to update the application winod
  showmodel(BuildContext context, String title, String content, String url) {
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
                  child: new Text(
                    "更新",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    launchURL(url);
                    Navigator.of(context).pop();
                  },
                ),
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

  @override
  Widget build(BuildContext context) {
    // 声明定义一个 底部导航的工具栏
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      backgroundColor: Color(int.parse(color1)),
      items: _navigationViews
          .map((NavigationIconView navigationIconView) =>
              navigationIconView.item)
          .toList(),
      // 添加 icon 按钮
      currentIndex: _currentIndex,
      // 当前点击的索引值
      type: BottomNavigationBarType.fixed,
      // 设置底部导航工具栏的类型：fixed 固定
      onTap: (int index) {
        // 添加点击事件
        setState(() {
          // 点击之后，需要触发的逻辑事件
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
          _currentPage = _pageList[_currentIndex];
          _load_bottom();
        });
      },
    );

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        body: new Center(child: _currentPage // 动态的展示我们当前的页面
            ),
        bottomNavigationBar: bottomNavigationBar, // 底部工具栏
      ),
      theme: new ThemeData(
        primarySwatch: Colors.blue, // 设置主题颜色
      ),
    );
  }
}

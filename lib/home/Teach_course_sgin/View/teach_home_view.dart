
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/LostandFound/lf_release.dart';
import 'package:flutter_app01/home/Teach_course_sgin/View/teach_class_view.dart';
import 'package:flutter_app01/home/Teach_course_sgin/View/teach_history_view.dart';
import 'package:flutter_app01/home/Teach_course_sgin/View/teach_view_main.dart';
import 'package:flutter_app01/home/Teach_course_sgin/ViewModel/teach_view_main_viewmodel.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';
import 'package:provide/provide.dart';

class teach_home_view extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_home_view_State();
  }

}

class teach_home_view_State extends State<teach_home_view> with TickerProviderStateMixin{
  int currentIndex = 0; // 当前界面的索引值
  List<NavigationIconView> _navigationViews; // 底部图标按钮区域
  List<StatefulWidget> _pageList; // 用来存放我们的图标对应的页面
  StatefulWidget _currentPage; // 当前的显示页面

  // 定义一个空的设置状态值的方法
  void _rebuild() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load_bottom();
    //监听广播事件
    bus.on("fb", (arg) {
      setState(() {
        _navigationViews[currentIndex].controller.reverse();
        currentIndex = 0;
        _navigationViews[currentIndex].controller.forward();
        _currentPage = _pageList[currentIndex];
        _load_bottom();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bus.off("fb"); //移除广播机制
  }

  void _load_bottom() {
    // 初始化导航图标
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
          icon: new Icon(
            Icons.border_color,
            color: Color(int.parse(color2)),
            size: 30,
          ),
          title: new Text(
            currentIndex == 0 ? '___' : '',
            style: TextStyle(color: Color(int.parse(color2))),
          ),
          vsync: this), // vsync 默认属性和参数
      new NavigationIconView(
          icon: new Icon(Icons.storage,
              color: Color(int.parse(color2)), size: 30),
          title: new Text(
            currentIndex == 1 ? '___' : '',
            style: TextStyle(color: Color(int.parse(color2))),
          ),
          vsync: this),
    ];

    // 给每一个按钮区域加上监听
    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    // 将我们 bottomBar 上面的按钮图标对应的页面存放起来，方便我们在点击的时候
    _pageList = <StatefulWidget>[new teach_class_view(), new teach_history_view()];
    _currentPage = _pageList[currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // 声明定义一个 底部导航的工具栏
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      backgroundColor: Color(int.parse(color1)),
      items: _navigationViews
          .map((NavigationIconView navigationIconView) =>
      navigationIconView.item)
          .toList(),
      // 添加 icon 按钮
      currentIndex: currentIndex,
      // 当前点击的索引值8
      type: BottomNavigationBarType.fixed,
      // 设置底部导航工具栏的类型：fixed 固定
      onTap: (int index) {
        //为了方便判断是自启动还是手动点击课表 当手动点击课表时候才自动跳转登陆界面在没有登陆的情况下  启动程序与刷新课表界面不跳出自动登陆
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

    return new Scaffold(
      body: Center(
        child: _currentPage,
      ),
      bottomNavigationBar: bottomNavigationBar,
      primary: true,
    );
  }

}
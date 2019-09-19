import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/Lose_HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'lf_search.dart';
import 'dart:math';

//失物招领

class lf_home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => lf_home_State();
}

class lf_home_State extends State<lf_home> {
  //搜索方式有俩种
  //一种以图搜图
  //一种特征搜索
  //上次提交时需要提交图片库同时进行特征识别以及文字识别

  String str; //综合搜索内容
  String drop_str = '特征'; //下拉框选择
  var _imageFile, bs64; //图片
  String date_str; //时间

  List<String> colors=['0xffB0E2FF','0xffEEEE00','0xff63B8FF','0xffFF6EB4','0xffEEDFCC','0xffFFA500'];

  int currentPage=0; //当前页数
  int linesize=10; //一页多少条数据
  List<dynamic> alllosebdata=[]; //得到loseball的总数据

  void _handleTapBoxBChanged(String value) {
    str = value;
  }

  void _dropTapChanged(T) {
    setState(() {
      drop_str = T;
    });
  }

  void _click_search() {
    print('_click_search');
    print(drop_str);
    print(str);
  }

  void _selectedImage() async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  void base64_callback(T) {
    bs64 = T;
    print('bs64:$bs64');
  }

  void date_callback(T) {
    setState(() {
      date_str = T.toString();
    });
  }

  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
      child: new Text('特征'),
      value: '特征',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('地点'),
      value: '地点',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('图片'),
      value: '图片',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('时间'),
      value: '时间',
    );
    items.add(dropdownMenuItem);
    return items;
  }

  //身体中间分类
  Widget bodytype() {
    return new Container(
      decoration: BoxDecoration(
          color: Color(int.parse('0xff4EEE94')),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      height: MediaQueryData.fromWindow(ui.window).size.height * 0.24,
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(
          MediaQueryData.fromWindow(ui.window).size.height * 0.01),
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: type_child1('images/2.2.x/yifu.png', '衣物'),
                flex: 1,
              ),
              Expanded(
                child: type_child1('images/2.2.x/icon-test.png', '运动装备'),
                flex: 1,
              ),
              Expanded(
                child: type_child1('images/2.2.x/qiapian.png', '卡片'),
                flex: 1,
              ),
              Expanded(
                child: type_child1('images/2.2.x/shu.png', '书籍'),
                flex: 1,
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: type_child1('images/2.2.x/yuechi.png', '钥匙'),
                flex: 1,
              ),
              Expanded(
                child: type_child1('images/2.2.x/ebook.png', '电子设备'),
                flex: 1,
              ),
              Expanded(
                child: type_child1('images/2.2.x/xzbd.png', '丢失物品'),
                flex: 1,
              ),
              Expanded(
                child: type_child1('images/2.2.x/qita.png', '其他'),
                flex: 1,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget type_child1(image, text) {
    return new Container(
      height: MediaQueryData.fromWindow(ui.window).size.height * 0.1,
      child: new Column(
        children: <Widget>[
          Container(
            child: Image(
              image: new AssetImage(image),
              height: MediaQueryData.fromWindow(ui.window).size.height * 0.06,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  //瀑布流显示
  Widget pbl() {
    return new Container(
      margin: EdgeInsets.all(10.0),
      height: MediaQueryData.fromWindow(ui.window).size.height * 0.43,
      child: new GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            crossAxisCount: 2,
            childAspectRatio: 1.0),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              color: Color(int.parse(colors[Random().nextInt(6)])),
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: new Image.network(
                    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=15335368'
                    '41326&di=682e2e7c3810ac92be325e62e173c0ea&imgtype=0&src=http%3A%2F%2Fs6.si'
                    'naimg.cn%2Fmw690%2F006LDoUHzy7auXEaYER25%26690',
                    fit: BoxFit.cover,
                  ),
                  flex: 8,
                ),
                Expanded(
                  child: new Container(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      '详情介艰苦拉萨的放假啦空手道分厘卡是的房间里点十六分的世界里绍',
                      style: TextStyle(color: Colors.black,fontSize: 11),
                      overflow: TextOverflow.ellipsis,maxLines: 2,
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: new Container(
                    padding: EdgeInsets.fromLTRB(5.0,0,5.0,5.0),
                    child: Align(
                      child: Text(
                        '来自:阿邹',
                        style: TextStyle(color: Colors.green,fontSize: 11),
                        overflow: TextOverflow.ellipsis,maxLines: 1,
                      ),
                      alignment: Alignment.bottomLeft,
                    ),
                  ),
                  flex: 2,
                )
              ],
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }

  //获取数据
  void getallloseb() async{
    String str1 = await Lose_HttpUtil.get_loseb('loseb_router/getloseb',(currentPage - 1) * linesize,linesize);
    alllosebdata=json.decode(str1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getallloseb();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          '失物招领-首页                                       ',
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
        actions: <Widget>[new Container()],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(int.parse(color1)),
        ),
        height: MediaQueryData.fromWindow(ui.window).size.height,
        child: ListView(
          children: <Widget>[
            Search(
              list1: getListData(),
              onChanged: _handleTapBoxBChanged,
              drop_value: drop_str,
              onChanged_drop: _dropTapChanged,
              res: _click_search,
              imageFile: _imageFile,
              selectimage: _selectedImage,
              base64_callback: base64_callback,
              date_str: date_str,
              date_callback: date_callback,
            ),
            bodytype(),
            pbl()
          ],
        ),
      ),
    );
  }
}

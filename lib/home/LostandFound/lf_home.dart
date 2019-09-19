import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/Lose_HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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

  List<String> colors = [
    '0xffB0E2FF',
    '0xffEEEE00',
    '0xff63B8FF',
    '0xffFF6EB4',
    '0xffEEDFCC',
    '0xffFFA500'
  ];

  int currentPage = 1; //当前页数
  int linesize = 5; //一页多少条数据
  List<dynamic> alllosebdata = []; //得到loseball的总数据
  List<Widget> allui = []; //总数据  不分类
  bool _body_loading = false;
  String nullimage =
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=15335368'
      '41326&di=682e2e7c3810ac92be325e62e173c0ea&imgtype=0&src=http%3A%2F%2Fs6.si'
      'naimg.cn%2Fmw690%2F006LDoUHzy7auXEaYER25%26690'; //空图片
  //初始化滚动监听器，加载更多使用
  ScrollController _controller = new ScrollController();

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

  //加载
  Widget loading() {
    return new Offstage(
      offstage: _body_loading,
      child: new Container(
        margin: EdgeInsets.all(10.0),
        height: MediaQueryData.fromWindow(ui.window).size.height * 0.43,
        child: new LoadingDialog(
          text: '加载数据中...',
        ),
      ),
    );
  }

  MovieListState({Key key}) {
    //固定写法，初始化滚动监听器，加载更多使用
    _controller.addListener(() {
      print('_controller');
    });
  }
  /**
   * 加载更多进度条
   */
  String loadMoreText='没有更多数据';
  Widget _buildProgressMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Text(loadMoreText, style: new TextStyle(color: const Color(0xFF999999), fontSize: 14.0)),
      ),
    );
  }
  bool dataNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      //下滑到最底部
      if (notification.metrics.extentAfter == 0.0) {
        print('======下滑到最底部======');
        if(alllosebdata.length<2){
          setState(() {
            loadMoreText='没有更多数据';
          });
        }else{
          setState(() {
            loadMoreText='加载中...';
            currentPage++;
            getallloseb(currentPage);
          });
        }
      }
      //滑动到最顶部
      if (notification.metrics.extentBefore == 0.0) {
        print('======滑动到最顶部======');
        setState(() {
          currentPage = 1;
          allui.clear();
          _body_loading=false;
          getallloseb(currentPage);
        });
      }
    }
    return true;
  }
  //瀑布流显示
  Widget pbl() {
    return new Offstage(
      offstage: !_body_loading,
      child: new Container(
        margin: EdgeInsets.all(10.0),
        height: MediaQueryData.fromWindow(ui.window).size.height * 0.43,
        child: new NotificationListener(
          onNotification: dataNotification,
          child: new ListView(
            children: <Widget>[
              Column(
                children: allui,
              ),
              _buildProgressMoreIndicator()
            ],
          ),
        ),
      ),
    );
  }

  Widget card(
      String image1, String image2, String image3, String text, String name) {
    return new Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Color(int.parse('0xfff1f1f1')),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap:(){
                    image1.indexOf('null') == -1?_showmodel(name,image1):'';
                  },
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: image1.indexOf('null') == -1
                        ? new Image.memory(
                      base64.decode(image1),
                      fit: BoxFit.fill,
                      height:
                      MediaQueryData.fromWindow(ui.window).size.height *
                          0.17,
                      width: MediaQueryData.fromWindow(ui.window).size.width *
                          0.25,
                    )
                        : Text(''),
                  ),
                ),
                GestureDetector(
                  onTap:(){
                    image2.indexOf('null') == -1?_showmodel(name,image2):'';
                  },
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: image2.indexOf('null') == -1
                        ? new Image.memory(
                      base64.decode(image2),
                      fit: BoxFit.fill,
                      height:
                      MediaQueryData.fromWindow(ui.window).size.height *
                          0.17,
                      width: MediaQueryData.fromWindow(ui.window).size.width *
                          0.25,
                    )
                        : Text(''),
                  ),
                ),
                GestureDetector(
                  onTap:(){
                    image3.indexOf('null') == -1?_showmodel(name,image3):'';
                  },
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: image3.indexOf('null') == -1
                        ? new Image.memory(
                      base64.decode(image3),
                      fit: BoxFit.fill,
                      height:
                      MediaQueryData.fromWindow(ui.window).size.height *
                          0.17,
                      width: MediaQueryData.fromWindow(ui.window).size.width *
                          0.25,
                    )
                        : Text(''),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.all(5.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: 11),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          new Container(
            padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 5.0),
            child: Align(
              child: Text(
                '来自:$name',
                style: TextStyle(color: Colors.green, fontSize: 11),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              alignment: Alignment.bottomLeft,
            ),
          )
        ],
      ),
    );
  }

  //获取数据
  getallloseb(currentPage) async {
    String str1 = await Lose_HttpUtil.get_loseb(
        'loseb_router/getloseb', (currentPage - 1) * linesize, linesize);
    alllosebdata = json.decode(str1);
    _load_data();
  }

  //装载数据
  void _load_data() {
    setState(() {
      for (int i = 0; i < alllosebdata.length; i++) {
        Map<String, dynamic> map = json.decode(json.encode(alllosebdata[i]));
        String images = map['image']
            .toString()
            .substring(1, map['image'].toString().length - 1);
        String image1 = images.split(',')[0].toString().trim();
        String image2 = images.split(',')[1].toString().trim();
        String image3 = images.split(',')[2].toString().trim();
        String introduce = map['introduce'].toString().trim();
        String address = map['address'].toString().trim();
        String time = map['time'].toString().trim();
        String userphone = map['userphone'].toString().trim();
        allui.add(card(image1, image2, image3, introduce, userphone));
      }
      _body_loading = true;
    });
  }

  //弹窗
  _showmodel(String name,String content) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('九职小猫手-$name',style: TextStyle(fontSize: 16),),
          content: new Image.memory(
            base64.decode(content),
            fit: BoxFit.fill,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("关闭"),
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
    currentPage=1;
    getallloseb(currentPage);
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
            pbl(),
            loading()
          ],
        ),
      ),
    );
  }
}

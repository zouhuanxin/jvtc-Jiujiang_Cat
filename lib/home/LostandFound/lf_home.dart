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
import 'lf_details.dart';
import 'lf_details2.dart';
import 'lf_search.dart';
import 'dart:math';
import 'dart:convert' as convert;

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
  int linesize = 2; //一页多少条数据
  List<dynamic> alllosebdata = []; //得到loseball的总数据
  List<Widget> allui = []; //总数据  不分类
  bool _body_loading = false; //控制加载与总数据显示界面的切换
  bool _search_all_data = false; //控制搜索结果与总数据界面的切换
  String nullimage =
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=15335368'
      '41326&di=682e2e7c3810ac92be325e62e173c0ea&imgtype=0&src=http%3A%2F%2Fs6.si'
      'naimg.cn%2Fmw690%2F006LDoUHzy7auXEaYER25%26690'; //空图片
  //初始化滚动监听器，加载更多使用
  ScrollController _controller = new ScrollController();

  List<dynamic> search_data = []; //得到搜索结果集合数据
  List<Object> search_tp_data = []; //得到图片搜索结果集合数据
  List<Widget> search_allui = []; //搜索结果集合

  void _handleTapBoxBChanged(String value) {
    str = value;
    if (str == '') {
      setState(() {
        _search_all_data = false;
      });
    }
  }

  void _dropTapChanged(T) {
    setState(() {
      drop_str = T;
    });
  }

  void _click_search() {
    print('_click_search');
    print(drop_str);
    setState(() {
      _search_all_data = true;
      search_tp_data.clear();
      search_allui.clear();
      search_loadMoreText = '搜索中...';
    });
    if (str != null && str != '' && str.length > 0) {
      switch (drop_str) {
        case '特征':
          setState(() {
            currentPage = 1;
            search_allui.clear();
            tz_search(str);
          });
          break;
        case '地点':
          setState(() {
            currentPage = 1;
            search_allui.clear();
            address_search(str);
          });
          break;
      }
    } else if (drop_str == '时间') {
      setState(() {
        currentPage = 1;
        search_allui.clear();
        time_search(date_str);
      });
    } else if (drop_str == '图片') {
      setState(() {
        currentPage = 1;
        search_allui.clear();
        tp_bdsearch();
      });
    }
  }

  //特征搜索
  void tz_search(str) async {
    String str1 = await Lose_HttpUtil.get_loseb2('loseb_router/getloseb2', str,
        str, str, (currentPage - 1) * linesize, 2);
    search_data = json.decode(str1);
    _load_data(search_data, search_allui);
  }

  //地址搜索
  void address_search(str) async {
    String str1 = await Lose_HttpUtil.get_loseb3(
        'loseb_router/getloseb3', str, (currentPage - 1) * linesize, 2);
    search_data = json.decode(str1);
    _load_data(search_data, search_allui);
  }

  //时间搜索
  void time_search(str) async {
    String str1 = await Lose_HttpUtil.get_loseb4(
        'loseb_router/getloseb4', date_str, (currentPage - 1) * linesize, 2);
    search_data = json.decode(str1);
    _load_data(search_data, search_allui);
  }

  //图片百度服务器相似搜索
  void tp_bdsearch() async {
    String str1 = await Lose_HttpUtil.get_bdtoken();
    String str2 = await Lose_HttpUtil.get_bdimage(
        convert.jsonDecode(str1)['access_token'], bs64);
    //print(json.decode(str2)['result_num']);
    if (int.parse(json.decode(str2)['result_num'].toString()) > 0) {
      search_tp_data = json.decode(json.encode(json.decode(str2)['result']));
//      if(int.parse(json.decode(str2)['result_num'].toString())>2) tp_search(json.decode(json.encode(search_tp_data[2]))['brief']);
//      if(int.parse(json.decode(str2)['result_num'].toString())>1) tp_search(json.decode(json.encode(search_tp_data[1]))['brief']);
      tp_search(json.decode(json.encode(search_tp_data[0]))['brief']);
    } else {
      search_loadMoreText = '没有更多数据';
    }
  }

  //图片自己服务器搜索
  void tp_search(str) async {
    String str1 = await Lose_HttpUtil.get_loseb5(
        'loseb_router/getloseb5', str, (currentPage - 1) * linesize, 2);
    //print('tp_search:$str1');
    search_data = json.decode(str1);
    _load_data(search_data, search_allui);
  }

  void _selectedImage() async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  void base64_callback(T) {
    bs64 = T;
    // print('bs64:$bs64');
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
          color: Color(int.parse('0xff8EE5EE')),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      height: MediaQueryData.fromWindow(ui.window).size.height * 0.24,
      margin: EdgeInsets.all(MediaQueryData.fromWindow(ui.window).size.height*0.01),
      padding: EdgeInsets.all(
          MediaQueryData.fromWindow(ui.window).size.height * 0.01),
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new lf_details(
                                    type: '衣物',
                                  )));
                    });
                  },
                  child: type_child1('images/2.2.x/yifu.png', '衣物'),
                ),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new lf_details(
                                    type: '运动装备',
                                  )));
                    });
                  },
                  child: type_child1('images/2.2.x/icon-test.png', '运动装备'),
                ),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new lf_details(
                                    type: '卡片',
                                  )));
                    });
                  },
                  child: type_child1('images/2.2.x/qiapian.png', '卡片'),
                ),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new lf_details(
                                    type: '书籍',
                                  )));
                    });
                  },
                  child: type_child1('images/2.2.x/shu.png', '书籍'),
                ),
                flex: 1,
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new lf_details(
                                    type: '钥匙',
                                  )));
                    });
                  },
                  child: type_child1('images/2.2.x/yuechi.png', '钥匙'),
                ),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new lf_details(
                                    type: '电子设备',
                                  )));
                    });
                  },
                  child: type_child1('images/2.2.x/ebook.png', '电子设备'),
                ),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new lf_details(
                                    type: '遗失物品',
                                  )));
                    });
                  },
                  child: type_child1('images/2.2.x/xzbd.png', '遗失物品'),
                ),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new lf_details(
                                    type: '其他',
                                  )));
                    });
                  },
                  child: type_child1('images/2.2.x/qita.png', '其他'),
                ),
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
        margin: EdgeInsets.all(MediaQueryData.fromWindow(ui.window).size.height*0.01),
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
  String loadMoreText = '没有更多数据';

  Widget _buildProgressMoreIndicator() {
    return new Container(
      height: 35,
      child: new Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: new Center(
          child: new Text(loadMoreText,
              style:
              new TextStyle(color: const Color(0xFF999999), fontSize: 14.0)),
        ),
      ),
    );
  }

  //搜索界面专用
  String search_loadMoreText = '没有更多数据';

  Widget _search_buildProgressMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Text(search_loadMoreText,
            style:
                new TextStyle(color: const Color(0xFF999999), fontSize: 14.0)),
      ),
    );
  }

  bool dataNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      //下滑到最底部
      if (notification.metrics.extentAfter == 0.0) {
        // print('======下滑到最底部======');
        if (alllosebdata.length < linesize) {
          setState(() {
            loadMoreText = '没有更多数据';
          });
        } else {
          setState(() {
            loadMoreText = '加载中...';
            currentPage++;
            getallloseb(currentPage);
          });
        }
      }
      //滑动到最顶部
//      if (notification.metrics.extentBefore == 0.0) {
//     //   print('======滑动到最顶部======');
//        setState(() {
//          currentPage = 1;
//          allui.clear();
//          _body_loading=false;
//          getallloseb(currentPage);
//        });
//      }
    }
    return true;
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 3), () {
      setState(() {
        currentPage = 1;
        allui.clear();
        getallloseb(currentPage);
      });
    });
  }

  //搜索界面专用
  bool search_dataNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      //下滑到最底部
      if (notification.metrics.extentAfter == 0.0) {
        //  print('======下滑到最底部======');
        if (search_data.length < 2) {
          setState(() {
            search_loadMoreText = '没有更多数据';
          });
        } else {
          if (drop_str == '特征') {
            setState(() {
              search_loadMoreText = '加载中...';
              currentPage++;
              tz_search(str);
            });
          } else if (drop_str == '地点') {
            setState(() {
              search_loadMoreText = '加载中...';
              currentPage++;
              address_search(str);
            });
          } else if (drop_str == '时间') {
            setState(() {
              search_loadMoreText = '加载中...';
              currentPage++;
              time_search(drop_str);
            });
          }
        }
      }
    }
    return true;
  }

  //瀑布流显示
  Widget pbl() {
    return new Offstage(
      offstage: !_body_loading,
      child: new Container(
        margin: EdgeInsets.all(MediaQueryData.fromWindow(ui.window).size.height*0.01),
        height: MediaQueryData.fromWindow(ui.window).size.height * 0.71,
        child: new NotificationListener(
          onNotification: dataNotification,
          child: new RefreshIndicator(
              child: new ListView(
                children: <Widget>[
                  bodytype(),
                  Column(
                    children: allui,
                  ),
                  _buildProgressMoreIndicator()
                ],
              ),
              onRefresh: _onRefresh
          ),
        ),
      ),
    );
  }

  Widget search_pbl() {
    return new Container(
      margin: EdgeInsets.all(MediaQueryData.fromWindow(ui.window).size.height*0.01),
      width: MediaQueryData.fromWindow(ui.window).size.width,
      height: MediaQueryData.fromWindow(ui.window).size.height * 0.8,
      child: new NotificationListener(
        onNotification: search_dataNotification,
        child: new ListView(
          children: <Widget>[
            Column(
              children: search_allui,
            ),
            _search_buildProgressMoreIndicator()
          ],
        ),
      ),
    );
  }

  Widget card(String id, String image1, String image2, String image3,
      String text, String address, String time, String name, String type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new lf_details2(
                      id: id,
                    )));
      },
      child: new Container(
        margin:EdgeInsets.all(MediaQueryData.fromWindow(ui.window).size.height*0.01),
        decoration: BoxDecoration(
            color: Color(int.parse('0xfff1f1f1')),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Column(
          children: <Widget>[
            new Container(
              height: image1.indexOf('null') == -1 ||
                      image2.indexOf('null') == -1 ||
                      image3.indexOf('null') == -1
                  ? MediaQueryData.fromWindow(ui.window).size.height * 0.18
                  : 0,
              padding: EdgeInsets.all(5.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      image1.indexOf('null') == -1
                          ? _showmodel(name, image1)
                          : '';
                    },
                    child: Container(
                      margin: EdgeInsets.all(MediaQueryData.fromWindow(ui.window).size.height*0.005),
                      child: image1.indexOf('null') == -1
                          ? new Image.memory(
                              base64.decode(image1),
                              fit: BoxFit.fill,
                              height: image1.indexOf('null') == -1
                                  ? MediaQueryData.fromWindow(ui.window)
                                          .size
                                          .height *
                                      0.17
                                  : 0,
                              width: image1.indexOf('null') == -1
                                  ? MediaQueryData.fromWindow(ui.window)
                                          .size
                                          .width *
                                      0.25
                                  : 0,
                            )
                          : Text(''),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      image2.indexOf('null') == -1
                          ? _showmodel(name, image2)
                          : '';
                    },
                    child: Container(
                      margin: EdgeInsets.all(MediaQueryData.fromWindow(ui.window).size.height*0.005),
                      child: image2.indexOf('null') == -1
                          ? new Image.memory(
                              base64.decode(image2),
                              fit: BoxFit.fill,
                              height: image2.indexOf('null') == -1
                                  ? MediaQueryData.fromWindow(ui.window)
                                          .size
                                          .height *
                                      0.17
                                  : 0,
                              width: image2.indexOf('null') == -1
                                  ? MediaQueryData.fromWindow(ui.window)
                                          .size
                                          .width *
                                      0.25
                                  : 0,
                            )
                          : Text(''),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      image3.indexOf('null') == -1
                          ? _showmodel(name, image3)
                          : '';
                    },
                    child: Container(
                      margin: EdgeInsets.all(MediaQueryData.fromWindow(ui.window).size.height*0.005),
                      child: image3.indexOf('null') == -1
                          ? new Image.memory(
                              base64.decode(image3),
                              fit: BoxFit.fill,
                              height: image3.indexOf('null') == -1
                                  ? MediaQueryData.fromWindow(ui.window)
                                          .size
                                          .height *
                                      0.17
                                  : 0,
                              width: image3.indexOf('null') == -1
                                  ? MediaQueryData.fromWindow(ui.window)
                                          .size
                                          .width *
                                      0.25
                                  : 0,
                            )
                          : Text(''),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.all(5.0),
              child: Align(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 5.0),
              child: Align(
                child: Text(
                  '拾取位置:$address',
                  style: TextStyle(color: Colors.green, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                alignment: Alignment.bottomLeft,
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 5.0),
              child: Align(
                child: Text(
                  '分类:$type    时间$time',
                  style: TextStyle(color: Colors.green, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                alignment: Alignment.bottomLeft,
              ),
            )
          ],
        ),
      ),
    );
  }

  //获取数据
  getallloseb(currentPage) async {
    String str1 = await Lose_HttpUtil.get_loseb(
        'loseb_router/getloseb', (currentPage - 1) * linesize, linesize);
    alllosebdata = json.decode(str1);
    _load_data(alllosebdata, allui);
  }

  //装载数据
  void _load_data(List<dynamic> list, List<Widget> uilist) {
    setState(() {
      for (int i = 0; i < list.length; i++) {
        Map<String, dynamic> map = json.decode(json.encode(list[i]));
        String images = map['image']
            .toString()
            .substring(1, map['image'].toString().length - 1);
        String image1 = images.split(',')[0].toString().trim();
        String image2 = images.split(',')[1].toString().trim();
        String image3 = images.split(',')[2].toString().trim();
        String introduce = map['introduce'].toString().trim();
        String address = map['address'].toString().trim();
        String time = map['time'].toString().trim();
        String type = map['type'].toString().trim();
        String userphone = map['userphone'].toString().trim();
        String id = map['id'].toString().trim();
        uilist.add(card(id, image1, image2, image3, introduce, address, time,
            userphone, type));
      }
      _body_loading = true;
      search_loadMoreText = '没有更多数据';
    });
  }

  //弹窗
  _showmodel(String name, String content) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                '九职小猫手-$name',
                style: TextStyle(fontSize: 16),
              ),
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

  //搜索结果界面
  Widget search_result() {
    return new Container(
      margin: EdgeInsets.all(MediaQueryData.fromWindow(ui.window).size.height*0.005),
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '   搜索结果',
                style: TextStyle(
                    color: Color(int.parse(color2)),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal),
              ),
              Text(
                '   $drop_str',
                style: TextStyle(
                  color: Color(int.parse(color2)),
                  fontSize: 10,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _search_all_data = false;
                  });
                },
                child: Text(
                  '   关闭',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          search_pbl()
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPage = 1;
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
            new Offstage(
              offstage: _search_all_data,
              child: Column(
                children: <Widget>[pbl(), loading()],
              ),
            ),
            new Offstage(
              offstage: !_search_all_data,
              child: search_result(),
            )
          ],
        ),
      ),
    );
  }
}

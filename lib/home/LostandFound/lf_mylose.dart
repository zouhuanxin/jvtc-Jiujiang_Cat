import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/Lose_HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;
import 'lf_details2.dart';
import 'lf_detailslose.dart';
import 'lf_search.dart';
import 'dart:math';
import 'dart:convert' as convert;
import 'dart:convert';

//失物招领

class lf_mylose extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => lf_mylose_State();
}

class lf_mylose_State extends State<lf_mylose> {
  int currentPage = 1; //当前页数
  int linesize = 5; //一页多少条数据
  List<dynamic> alllosebdata = []; //得到loseball的总数据
  List<Widget> allui = []; //总数据  不分类

  Widget card(
      String id,String image1, String image2, String image3, String text,String address,String time, String name,String type) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new lf_detailslose(id: id,)));
      },
      child: new Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Color(int.parse('0xfff1f1f1')),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Column(
          children: <Widget>[
            new Container(
              height:image1.indexOf('null')==-1||image2.indexOf('null')==-1||image3.indexOf('null')==-1?
              MediaQueryData.fromWindow(ui.window).size.height *
                  0.18:0,
              padding: EdgeInsets.all(5.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
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
                        height:image1.indexOf('null')==-1?
                        MediaQueryData.fromWindow(ui.window).size.height *
                            0.17:0,
                        width: image1.indexOf('null')==-1?MediaQueryData.fromWindow(ui.window).size.width *
                            0.25:0,
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
                        height:image2.indexOf('null')==-1?
                        MediaQueryData.fromWindow(ui.window).size.height *
                            0.17:0,
                        width: image2.indexOf('null')==-1?MediaQueryData.fromWindow(ui.window).size.width *
                            0.25:0,
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
                        height:image3.indexOf('null')==-1?
                        MediaQueryData.fromWindow(ui.window).size.height *
                            0.17:0,
                        width: image3.indexOf('null')==-1?MediaQueryData.fromWindow(ui.window).size.width *
                            0.25:0,
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
                  '奖励金:$type    时间$time',
                  style: TextStyle(color: Colors.green, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                alignment: Alignment.bottomLeft,
              ),
            ),
            new GestureDetector(
              onTap:(){
                delect(id);
              },
              child: new Container(
                padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 5.0),
                child: Align(
                  child: Text(
                    ' 删除   ',
                    style: TextStyle(color: Colors.red, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  alignment: Alignment.bottomRight,
                ),
              ),
            )
          ],
        ),
      ),
    );
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
  /**
   * 刷新进度条
   */
  String headloadMoreText='下拉可刷新哦';
  Widget _headbuildProgressMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(1.0),
      child: new Center(
        child: new Text(headloadMoreText, style: new TextStyle(color: const Color(0xFF999999), fontSize: 14.0)),
      ),
    );
  }
  bool dataNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      //下滑到最底部
      if (notification.metrics.extentAfter == 0.0) {
        // print('======下滑到最底部======');
        if(alllosebdata.length<linesize){
          setState(() {
            loadMoreText='没有更多数据';
          });
        }else{
          setState(() {
            loadMoreText='加载中...';
            currentPage++;
            getall(currentPage,phone);
          });
        }
      }
      //滑动到最顶部
//      if (notification.metrics.extentBefore == 0.0) {
//        //   print('======滑动到最顶部======');
//        setState(() {
//          headloadMoreText='刷新中...';
//          currentPage = 1;
//          allui.clear();
//          getall(currentPage,phone);
//        });
//      }
    }
    return true;
  }
  //瀑布流显示
  Widget pbl() {
    return  new Container(
      margin: EdgeInsets.all(0.0),
      height: MediaQueryData.fromWindow(ui.window).size.height * 0.8,
      child: new NotificationListener(
        onNotification: dataNotification,
        child: new ListView(
          children: <Widget>[
            //_headbuildProgressMoreIndicator(),
            Column(
              children: allui,
            ),
            _buildProgressMoreIndicator()
          ],
        ),
      ),
    );
  }

  //获取数据
  getall(currentPage,str) async {
    String str1 = await Lose_HttpUtil.get_losea2('losea_router/getlosea',str, (currentPage - 1) * linesize, linesize);
    if(str1=='[]'){
      loadMoreText='没有更多数据';
    }
    alllosebdata = json.decode(str1);
    _load_data(alllosebdata,allui);
  }

  //删除数据
  delect(str) async {
    String str1 = await Lose_HttpUtil.delect_losea('losea_router/delectlosea', str);
    if(int.parse(str1)==1){
      _Toast('删除成功', Toast.LENGTH_SHORT, Colors.blue);
      alllosebdata.clear();
      allui.clear();
      currentPage=1;
      getall(currentPage,phone);
    }else{
      _Toast('删除失败', Toast.LENGTH_SHORT, Colors.red);
    }
  }
  void _Toast(mes, var type, var color) {
    Fluttertoast.showToast(
        msg: mes,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  //装载数据
  void _load_data(List<dynamic>list,List<Widget>uilist) {
    setState(() {
      for (int i = 0; i < list.length; i++) {
        Map<String, dynamic> map = json.decode(json.encode(list[i]));
        String images = map['image'].toString().substring(1, map['image'].toString().length - 1);
        String image1 = images.split(',')[0].toString().trim();
        String image2 = images.split(',')[1].toString().trim();
        String image3 = images.split(',')[2].toString().trim();
        String introduce = map['introduce'].toString().trim();
        String address = map['address'].toString().trim();
        String time = map['time'].toString().trim();
        String type = map['reward_money'].toString().trim();
        String userphone = map['userphone'].toString().trim();
        String id = map['id'].toString().trim();
        uilist.add(card(id,image1, image2, image3, introduce,address ,time, userphone,type));
      }
      headloadMoreText='下拉可刷新哦';
    });
  }

  //分类界面
  Widget type_result(){
    return new Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          pbl()
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loadMoreText='加载中...';
    });
    alllosebdata.clear();
    allui.clear();
    currentPage=1;
    getall(currentPage,phone);
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          '遗失物品                                      ',
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
      body: type_result(),
    );
  }
}

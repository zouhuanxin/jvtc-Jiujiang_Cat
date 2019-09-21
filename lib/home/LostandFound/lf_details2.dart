import 'dart:convert';
import 'dart:ui' as ui;
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/HttpUtil/Lose_HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

//失物招领

class lf_details2 extends StatefulWidget {
  final String id;

  const lf_details2({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => lf_details2_State(id);
}

class lf_details2_State extends State<lf_details2> {
  String id = '';
  int currentPage = 1; //当前页数
  int linesize = 5; //一页多少条数据
  List<dynamic> alllosebdata = []; //得到loseball的总数据

  String userphone = '九职小猫手',
      introduce = '加载中...',
      address = '加载中...',
      type = '加载中...',
      image1 = '',
      image2 = '',
      image3 = '';
  String headimage=default_image; //头像
  String username='加载中...'; //用户名称

  lf_details2_State(str) {
    id = str;
  }

  void tp_search(str) async {
    String str1 = await Lose_HttpUtil.get_loseb5(
        'loseb_router/getloseb5', str, (currentPage - 1) * linesize, 2);
    alllosebdata = json.decode(str1);
    setState(() {
      userphone = json.decode(json.encode(alllosebdata[0]))['userphone'];
      introduce = json.decode(json.encode(alllosebdata[0]))['introduce'];
      address = json.decode(json.encode(alllosebdata[0]))['address'];
      type = json.decode(json.encode(alllosebdata[0]))['type'];
      String images = json.decode(json.encode(alllosebdata[0]))['image'].toString().substring(1, json.decode(json.encode(alllosebdata[0]))['image'].toString().length - 1);
      image1 = images.split(',')[0].toString().trim();
      image2 = images.split(',')[1].toString().trim();
      image3 = images.split(',')[2].toString().trim();
      _bmob_get_QTuser_password_information(userphone);
    });
  }

  Align buildButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '复制联系',
            style: TextStyle(color: Color(int.parse(color1))),
          ),
          color: Color(int.parse(color2)),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: userphone));
            Toastmodel('联系已复制', Toast.LENGTH_SHORT, Colors.blue);
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
      alignment: Alignment.center,
    );
  }

  void Toastmodel(str,type,color){
    Fluttertoast.showToast(
        msg: str,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tp_search(id);
  }
  void _bmob_get_QTuser_password_information(String phone) async {
    BmobQuery<QTuser> query = BmobQuery();
    query.addWhereEqualTo("phone", phone.toString().trim());
    query.queryObjects().then((data) {
      List<QTuser> sfs = data.map((i) => QTuser.fromJson(i)).toList();
      setState(() {
        headimage = sfs[0].imagebase64;
        username = sfs[0].username;
      });
//      phone = sfs[0].phone;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          '失物招领-介绍                                       ',
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
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                child: new Align(
                  alignment: FractionalOffset.center,
                  child: new GestureDetector(
                    child: new ClipOval(
                      child: new Image.memory(base64.decode(headimage),fit: BoxFit.fill,height: 80,width: 80,),
                    ),
                  ),
                ),
              ),
              Text(
                username,
                style: TextStyle(
                    color: Color(int.parse(color2)),
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            introduce,
            style: TextStyle(
                color: Color(int.parse(color2)),
                fontWeight: FontWeight.w100,
                fontSize: 12),
            maxLines: 15,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '地址：${address}',
            style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.w100, fontSize: 12),
          ),
          Text(
            '分类：${type}',
            style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.w100, fontSize: 12),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: image1.indexOf('null') == -1
                ? new Image.memory(
                    base64.decode(image1),
                    fit: BoxFit.fill,
                    height: image1.indexOf('null') == -1 ? 200 : 0,
                    width: image1.indexOf('null') == -1
                        ? MediaQueryData.fromWindow(ui.window).size.width * 0.9
                        : 0,
                  )
                : Text(''),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: image2.indexOf('null') == -1
                ? new Image.memory(
              base64.decode(image2),
              fit: BoxFit.fill,
              height: image2.indexOf('null') == -1 ? 200 : 0,
              width: image2.indexOf('null') == -1
                  ? MediaQueryData.fromWindow(ui.window).size.width * 0.9
                  : 0,
            )
                : Text(''),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: image3.indexOf('null') == -1
                ? new Image.memory(
              base64.decode(image3),
              fit: BoxFit.fill,
              height: image3.indexOf('null') == -1 ? 200 : 0,
              width: image3.indexOf('null') == -1
                  ? MediaQueryData.fromWindow(ui.window).size.width * 0.9
                  : 0,
            )
                : Text(''),
          ),
          SizedBox(height: 10,),
          buildButton()
        ],
      ),
    );
  }
}

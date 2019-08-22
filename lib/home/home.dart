import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Animation_list.dart';
import 'package:flutter_app01/course/course.dart';
import 'package:flutter_app01/index/index.dart';
import 'package:meta/meta.dart';
import 'package:flutter_app01/Learn_teach/learn_teach.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter_app01/Bean/lunbo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:flutter_app01/Library/library.dart';
import 'package:flutter_app01/Word_rest_time/word_rest_time.dart';
import 'dart:convert';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/my/my_login.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Obligation_to_repair/Obligation_to_repair.dart';
import 'package:flutter_app01/Countdown/Countdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app01/Results_analysis/Results_analysis.dart';
import 'package:flutter_app01/Student_assistant/Student_assistant.dart';
import 'package:flutter_app01/Lovers_space/Lovers_space.dart';
import 'package:flutter_app01/Utils/WebViewPage.dart';
import 'package:flutter_app01/common/System_notice.dart';
import 'JZ_association/Collection.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Store information of rotation chart file
  List<String> imageList = List();
  String qqnumber = '';

  void _model_click(String str) {
    //print(str);
    switch (str) {
      case '学教平台':
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new learn_tach()));
        break;
      case '图书馆':
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new Library()));
        break;
      case '成绩分析':
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Results_analysis()));
        break;
      case '作息时间':
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new word_rest_time()));
        break;
      case '义务维修':
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Obligation_to_repair()));
        break;
      case '倒计时':
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new Countdown()));
        break;
      case '强制qq聊天':
        Scaffold.of(context).showSnackBar(new SnackBar(
          duration: Duration(minutes: 1),
          content: new Container(
            child: new TextField(
                decoration: InputDecoration(
                    labelText: '对方qq号码',
                    fillColor: Colors.white,
                    filled: dart_model,
                    suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Color(int.parse(color4)),
                        ),
                        onPressed: () {
                          launchURL(
                              'mqq://im/chat?chat_type=wpa&uin=$qqnumber&version=1&src_type=web');
                        })),
                // 当 value 改变的时候，触发
                onChanged: (val) {
                  print(val);
                  qqnumber = val;
                }),
          ),
          action: new SnackBarAction(
              label: '返回',
              onPressed: () {
                //_query_all();
              }),
        ));
        break;
      case '学习周期':
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Student_assistant()));
        break;
      case '情侣空间':
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new Lovers_space()));
        break;
      case '软件协会官方网站':
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new WebViewPage(
                    url: 'http://47.94.255.154:8080/software2.0/index.html',
                    title: '软件协会官方网站')));
        break;
      case '协会收款':
        if (login_state == true) {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new Collection()));
        } else {
          _showmodel('请先登陆九职小猫手', Toast.LENGTH_SHORT, Colors.red);
        }
        break;
    }
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

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<lunbo> sfs = [];

  void _bmob_get_Shuffing_figure_information() {
    sfs.clear();
    BmobQuery<lunbo> query = BmobQuery();
    query.addWhereNotEqualTo("imageurl", "12%%%3");
    query.queryObjects().then((data) {
      imageList.clear();
      sfs = data.map((i) => lunbo.fromJson(i)).toList();
      for (lunbo sf in sfs) {
        if (sf != null) {
          setState(() {
            imageList.add(sf.imageurl);
          });
        }
      }
    }).catchError((e) {});
  }

  @override
  void initState() {
    super.initState();
    //https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=4010497054,3899149768&fm=26&gp=0.jpg
    imageList.add(
        'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=4010497054,3899149768&fm=26&gp=0.jpg');
    _bmob_get_Shuffing_figure_information();
  }

  void _lunbo_click(index){
    if(sfs[index].url!=''){
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new WebViewPage(
                  url: sfs[index].url,
                  title: '详情内容')));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _swiperBuilder(BuildContext context, int index) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageList[index]),
                fit: BoxFit.fill,
              )),
        ),
      );
    }

    Widget SwiperView() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        margin: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Swiper(
          layout: SwiperLayout.DEFAULT,
          itemCount: imageList.length,
          itemBuilder: _swiperBuilder,
          viewportFraction: 0.8,
          scale: 0.8,
          pagination: SwiperPagination(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
              builder: FractionPaginationBuilder(
                  color: Colors.white,
                  activeColor: Colors.redAccent,
                  activeFontSize: 40)),
          controller: SwiperController(),
          scrollDirection: Axis.horizontal,
          autoplay: true,
          onTap: (index) {
            _lunbo_click(index);
          },
        ),
      );
    }

    Widget buildButtonColumn(IconData icon, String label1, label2) {
      Color color = Color(int.parse(color2));
      return new Container(
        margin: EdgeInsets.all(5.0),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: new GestureDetector(
                child: new Icon(
                  icon,
                  color: color,
                  size: 37.0,
                ),
                onTap: () {
                  _model_click(label1);
                },
              ),
              flex: 1,
            ),
            Expanded(
              child: new Align(
                alignment: FractionalOffset.bottomLeft,
                child: new GestureDetector(
                  child: new Column(
                    children: <Widget>[
                      new Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: new Text(
                          label1,
                          style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                      new Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: new Text(
                          label2,
                          style: new TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w100,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    _model_click(label1);
                  },
                ),
              ),
              flex: 3,
            ),
          ],
        ),
      );
    }

    ;

    Widget buildButtonColumn2(String imageurl, String label1, label2) {
      Color color = Color(int.parse(color2));
      return new Container(
        margin: EdgeInsets.all(5.0),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: new GestureDetector(
                child: new Image(
                  image: new AssetImage(imageurl),
                  height: 40,
                  width: 40,
                ),
                onTap: () {
                  _model_click(label1);
                },
              ),
              flex: 1,
            ),
            Expanded(
              child: new Align(
                alignment: FractionalOffset.bottomLeft,
                child: new GestureDetector(
                  child: new Column(
                    children: <Widget>[
                      new Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: new Text(
                          label1,
                          style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                      new Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: new Text(
                          label2,
                          style: new TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w100,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    _model_click(label1);
                  },
                ),
              ),
              flex: 3,
            ),
          ],
        ),
      );
    }

    ;

    //校园功能模块
    Widget campus_funcation_text = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        '校园功能',
        softWrap: true,
        style: new TextStyle(
          color: Color(int.parse(color2)),
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    Widget campus_funcation_button = new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButtonColumn(
                  Icons.account_balance, '学教平台', '学生信息，成绩查询，活动评价，素拓分查询，寝室情况查询'),
              buildButtonColumn(
                  Icons.book, '图书馆', '包含图书馆个人信息查看，书籍查询，预约书籍，取消预约，书籍续借，缴费信息等功能'),
              buildButtonColumn(Icons.data_usage, '成绩分析', '数据分析仅供参考,邀测中。'),
              buildButtonColumn(Icons.av_timer, '作息时间', '当今可以查看夏季作息时间表'),
            ],
          ),
        ],
      ),
    );

    //校园生活模块
    Widget campus_life_text = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        '校园生活',
        softWrap: true,
        style: new TextStyle(
          color: Color(int.parse(color2)),
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    Widget campus_life_button = new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.work, '义务维修', '电脑，平板，手机，系统重装，需要请发表'),
          buildButtonColumn(Icons.timer_10, '倒计时', '帮助你记录重要的事情'),
        ],
      ),
    );

    //工具箱模块
    Widget campus_toolkit_text = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        '工具箱',
        softWrap: true,
        style: new TextStyle(
          color: Color(int.parse(color2)),
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    Widget campus_toolkit_button = new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.library_books, '学习周期',
              '不拼命久了，学习一个小时你觉得自己在拼命！记录你的学习时间,采集你学习周期时间给予建议，并用数据告诉你自己有没有拼命学习。'),
          buildButtonColumn(Icons.chat, '强制qq聊天',
              '输入对方qq号可以强制拉起qq与对方进行交流,如果对方没有打开在线咨询则无法发送消息,你可以直接加为好友。'),
          //buildButtonColumn(Icons.supervisor_account, '情侣空间','你和对象的私人空间.'), //no open
        ],
      ),
    );

    //协会模块
    Widget campus_xh_text = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        '九职协会',
        softWrap: true,
        style: new TextStyle(
          color: Color(int.parse(color2)),
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    Widget campus_xh_button = new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn2('images/2.0.x/rjxh.jpg', '软件协会官方网站', '软件协会欢迎您!'),
          buildButtonColumn2('images/2.0.x/sk.png', '协会收款',
              '九职协会收款助手，帮助协会活动招新收款项目的整理以及归纳，谨慎交钱，开心你我他。'),
          //buildButtonColumn(Icons.supervisor_account, '情侣空间','你和对象的私人空间.'), //no open
        ],
      ),
    );

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '首页                                       ',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color(int.parse(color2)),
                fontWeight: FontWeight.w800,
                fontSize: 25),
          ),
          elevation: 0.0,
          leading: new Container(
            margin: EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new my_login()));
              },
              child: new ClipOval(
                child: new Image.memory(base64.decode(now_login_image_base64),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications, color: Color(int.parse(color2))),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new System_notice()));
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: Color(int.parse(color2))),
              onPressed: () {
                CoursePageState cp=new CoursePageState();
                cp.disdl();
                Navigator.pushAndRemoveUntil(
                    context,
                    CustomRouteJianBian(Index(
                      index: 0,
                    )),
                    (check) => false);
                //Navigator.push(context, CustomRouteJianBian(HomePage()));
              },
            ),
          ],
          backgroundColor: Color(int.parse(color1)),
          centerTitle: true,
        ),
        body: new Container(
          decoration: BoxDecoration(color: Color(int.parse(color1))),
          child: new ListView(
            children: [
              SwiperView(),
              campus_funcation_text,
              campus_funcation_button,
              campus_life_text,
              campus_life_button,
              campus_toolkit_text,
              campus_toolkit_button,
              campus_xh_text,
              campus_xh_button,
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

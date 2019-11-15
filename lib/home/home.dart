import 'dart:async';

import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/Bean/System_Notice.dart';
import 'package:flutter_app01/Bean/home_blog.dart';
import 'package:flutter_app01/Utils/Animation_list.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/course/course.dart';
import 'package:flutter_app01/home/Student_course_sgin/View/student_home_view.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/View/teach_home_view.dart';
import 'package:flutter_app01/home/Teach_XG/View/teach_xg_main_view.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app01/Results_analysis/Results_analysis.dart';
import 'package:flutter_app01/Student_assistant/Student_assistant.dart';
import 'package:flutter_app01/Lovers_space/Lovers_space.dart';
import 'package:flutter_app01/Utils/WebViewPage.dart';
import 'package:flutter_app01/common/System_notice.dart';
import 'JZ_association/Collection.dart';
import 'Group_ck/group_ck.dart';
import 'LostandFound/lf_main.dart';
import 'Teach_JW/View/teach_jw_main_view.dart';
import 'Teach_Student_UploadPass/View/teach_student_uploadpass_view.dart';
import 'competition/competition_entrance.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Store information of rotation chart file
  List<String> imageList = List();
  String qqnumber = '';

  //当前未读通知数量
  String unread='';

  void _bmob_get_System_Notice_size() async{
    if(login_state==false){
      return;
    }
    BmobQuery<System_Notice> query = BmobQuery();
    query.addWhereNotEqualTo("imageurl", "12%%%3");
    query.queryObjects().then((data) {
      List<System_Notice> list1 = data.map((i) => System_Notice.fromJson(i)).toList();
      BmobQuery<QTuser> query = BmobQuery();
      query.addWhereEqualTo("phone", phone.toString().trim());
      query.queryObjects().then((data) {
        List<QTuser> list2 = data.map((i) => QTuser.fromJson(i)).toList();
        setState(() {
          if(list2[0].notice!=null&&list2[0].notice.length!=0){
            if(int.parse(list2[0].notice.toString())<list1.length){
              unread=(list1.length-int.parse(list2[0].notice.toString())).toString();
            }else{
              unread='';
            }
          }else{
            unread=list1.length.toString();
          }
        });

      }).catchError((e) {});
    }).catchError((e) {
      print(BmobError.convert(e).error);
      _showmodel('获取通知信息失败', Toast.LENGTH_SHORT,Colors.red);
    });
  }
  //修改用户浏览系统通知
  _updatenotify() async{
    if(login_state==false){
      return;
    }
    BmobQuery<QTuser> query = BmobQuery();
    query.addWhereEqualTo("phone", phone);
    await query.queryObjects().then((data) {
      List<QTuser>templist = data.map((i) => QTuser.fromJson(i)).toList();
      QTuser blog = QTuser();
      blog.objectId = templist[0].objectId;
      if(templist[0].notice==null||templist[0].notice.length==0){
        blog.notice=unread;
      }else{
        blog.notice=(int.parse(unread)+int.parse(templist[0].notice)).toString();
      }
      blog.update().then((BmobUpdated bmobUpdated) {
        _bmob_get_System_Notice_size();
      }).catchError((e) {
        Util.showTaost('稍后重试', Toast.LENGTH_SHORT, Colors.red);
      });
    }).catchError((e) {});
  }


  void _model_click(String str) {
    if(login_state==false){
      Util.showTaost('请先登陆小猫手', Toast.LENGTH_SHORT, Colors.red);
      return;
    }
    if(now_studentid==null||now_studentid.length<2){
      Util.showTaost('请先绑定学号', Toast.LENGTH_SHORT, Colors.red);
      return;
    }
    //print(str);
    switch (str) {
      case '学教平台':
        if(now_studentid.length!=9){
          Util.showTaost('你不是学生，暂无权限。', Toast.LENGTH_SHORT, Colors.grey);
          return;
        }
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
                  //print(val);
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
                    url: 'http://dyzuis.cn:8080/software2.0/index.html',
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
      case '协会群号码':
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new group_ck()));
        break;
      case '碰碰球':
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new WebViewPage(
                    url: 'http://dyzuis.cn:8080/PPball/index.html',
                    title: '碰碰球')));
        break;
      case '失物招领':
        if (login_state == true) {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new lf_main()));
        } else {
          _showmodel('请先登陆九职小猫手', Toast.LENGTH_SHORT, Colors.red);
        }
        break;
      case '社团活动':
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new competition_entrance()));
        break;
      case '教师上课签到记录':
        if(now_studentid.length!=5){
          Util.showTaost('你不是教师，暂无权限。', Toast.LENGTH_SHORT, Colors.grey);
          return;
        }
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new teach_home_view()));
        break;
      case '教师教务系统':
        if(now_studentid.length!=5){
          Util.showTaost('你不是教师，暂无权限。', Toast.LENGTH_SHORT, Colors.grey);
          return;
        }
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new teach_jw_main_view()));
        break;
      case '教师学工平台':
        if(now_studentid.length!=5){
          Util.showTaost('你不是教师，暂无权限。', Toast.LENGTH_SHORT, Colors.grey);
          return;
        }
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new teach_xg_main_view()));
        break;
      case '学生上课签到':
        if(now_studentid.length!=9){
          Util.showTaost('你不是学生，暂无权限。', Toast.LENGTH_SHORT, Colors.grey);
          return;
        }
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new student_home_view()));
        break;
      case '教师学教密码修改':
        if(now_studentid.length!=5){
          Util.showTaost('你不是教师，暂无权限。', Toast.LENGTH_SHORT, Colors.grey);
          return;
        }
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new teach_student_uploadpass_view()));
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
      _bmob_get_System_Notice_size();
    }).catchError((e) {});
  }

  void _check_student() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //是否有未结束的学习周期计时任务
    if (sharedPreferences.getBool('appbar_bol')) {
      if (login_state == true) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Student_assistant()));
      } else {
        _showmodel('请先登陆九职小猫手', Toast.LENGTH_SHORT, Colors.red);
      }
    }
  }

  void _lunbo_click(index) {
    if (sfs[index].url != '' && sfs[index].url != null) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
                  new WebViewPage(url: sfs[index].url, title: '详情内容')));
    }
  }

  List<home_blog> blog_list = [];
  List<Widget> blog_button_list=[];
  void _bmob_get_blog_information() {
    BmobQuery<home_blog> query = BmobQuery();
    query.addWhereEqualTo("vis", "true");
    query.queryObjects().then((data) {
      blog_list = data.map((i) => home_blog.fromJson(i)).toList();
      for(home_blog hb in blog_list){
        blog_button_list.add(buildButtonColumn3(hb.blog_image,
            hb.blog_name!=null?hb.blog_name:'',hb.blog_introduce!=null?hb.blog_introduce:'',hb));
      }
      //print('blog_list:$blog_list');
    }).catchError((e) {});
  }

//  Widget buildButtonColumn(IconData icon, String label1, label2) {
//    Color color = Color(int.parse(color2));
//    return new Container(
//      margin: EdgeInsets.all(5.0),
//      child: new Row(
//        mainAxisSize: MainAxisSize.min,
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: [
//          Expanded(
//            child: new GestureDetector(
//              child: new Icon(
//                icon,
//                color: color,
//                size: 37.0,
//              ),
//              onTap: () {
//                _model_click(label1);
//              },
//            ),
//            flex: 1,
//          ),
//          Expanded(
//            child: new Align(
//              alignment: FractionalOffset.bottomLeft,
//              child: new GestureDetector(
//                child: new Column(
//                  children: <Widget>[
//                    new Align(
//                      alignment: FractionalOffset.bottomLeft,
//                      child: new Text(
//                        label1,
//                        style: new TextStyle(
//                          fontSize: 15.0,
//                          fontWeight: FontWeight.w600,
//                          color: color,
//                        ),
//                      ),
//                    ),
//                    new Align(
//                      alignment: FractionalOffset.bottomLeft,
//                      child: new Text(
//                        label2,
//                        style: new TextStyle(
//                          fontSize: 10.0,
//                          fontWeight: FontWeight.w100,
//                          color: color,
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//                onTap: () {
//                  _model_click(label1);
//                },
//              ),
//            ),
//            flex: 3,
//          ),
//        ],
//      ),
//    );
//  }


  Widget buildButtonColumn2(String imageurl, String label1, label2) {
    Color color = Color(int.parse(color2));
    return new Container(
      margin: EdgeInsets.all(3.0),
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(''),flex: 1,),
          new GestureDetector(
            child: new ClipOval(
              child: new Image(
                image: imageurl.indexOf('http')==-1?new AssetImage(imageurl):new NetworkImage(imageurl),
                height: MediaQueryData.fromWindow(ui.window).size.height*0.09,
                width: MediaQueryData.fromWindow(ui.window).size.height*0.09,
              ),
            ),
            onTap: () {
              _model_click(label1);
            },
          ),
          Expanded(child: Text(''),flex: 1,),
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
            flex: 23,
          ),
        ],
      ),
    );
  }

  Widget buildButtonColumn3(String imageurl, String label1, label2,home_blog hb) {
    if(imageurl==null){
      imageurl='';
    }
    Color color = Color(int.parse(color2));
    return new Container(
      margin: EdgeInsets.all(5.0),
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(''),flex: 1,),
          new ClipOval(
            child: new Image(
                image: imageurl.length<1?new AssetImage('images/2.2.x/loading01.png'):new NetworkImage(imageurl),
                height: MediaQueryData.fromWindow(ui.window).size.height*0.07,
                width: MediaQueryData.fromWindow(ui.window).size.height*0.07,
                fit: BoxFit.fill
            ),
          ),
          Expanded(child: Text(''),flex: 1,),
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
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new WebViewPage(
                              url: hb.blog_url,
                              title: hb.blog_name)));
                },
              ),
            ),
            flex: 16,
          ),
        ],
      ),
    );
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
          layout: SwiperLayout.STACK,
          itemCount: imageList.length,
          itemBuilder: _swiperBuilder,
          itemWidth: MediaQueryData.fromWindow(ui.window).size.width*0.9,
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

    //校园功能模块
    Widget campus_funcation_text = new Container(
      padding: const EdgeInsets.fromLTRB(32, 10, 32, 15),
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
              buildButtonColumn2(
                  'images/2.2.1.x/tug.png', '图书馆', '包含图书馆个人信息查看，书籍查询，预约书籍，取消预约，书籍续借，缴费信息等功能'),
              buildButtonColumn2('images/2.2.1.x/zxsj.png', '作息时间', '可以查看作息时间表'),
            ],
          ),
        ],
      ),
    );

    //校园功能模块
    Widget campus_student_text = new Container(
      padding: const EdgeInsets.fromLTRB(32, 10, 32, 15),
      child: new Text(
        '学生功能',
        softWrap: true,
        style: new TextStyle(
          color: Color(int.parse(color2)),
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    Widget campus_student_button = new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButtonColumn2(
                  'images/2.2.1.x/xjpt.png', '学教平台', '学生信息，成绩查询，活动评价，素拓分查询，寝室情况查询'),
              buildButtonColumn2('images/2.2.1.x/xsqd.png', '学生上课签到', '学生可以在此签到!'),
              buildButtonColumn2('images/2.2.1.x/cjfx.png', '成绩分析', '数据分析仅供参考。'),
            ],
          ),
        ],
      ),
    );

    //校园生活模块
    Widget campus_life_text = new Container(
      padding: const EdgeInsets.fromLTRB(32, 10, 32, 15),
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
          buildButtonColumn2(
              'images/2.2.1.x/swzl.png', '失物招领', '采用AI识别技术帮助你尽可能的准确快速找到你的物品'),
          buildButtonColumn2('images/2.2.1.x/sthd.png', '社团活动', '社团活动投票，投票需谨慎。'),
          buildButtonColumn2('images/2.2.1.x/ywwx.png', '义务维修', '电脑，平板，手机，系统重装，需要请发表'),
          buildButtonColumn2('images/2.2.1.x/djs.png', '倒计时', '帮助你记录重要的事情'),
        ],
      ),
    );

    //工具箱模块
    Widget campus_toolkit_text = new Container(
      padding: const EdgeInsets.fromLTRB(32, 10, 32, 15),
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
          buildButtonColumn2('images/2.2.1.x/xxzq.png', '学习周期',
              '不拼命久了，学习一个小时你觉得自己在拼命！记录你的学习时间,采集你学习周期时间给予建议，并用数据告诉你自己有没有拼命学习。'),
          buildButtonColumn2('images/2.2.1.x/qzqqlt.png', '强制qq聊天',
              '输入对方qq号可以强制拉起qq与对方进行交流,如果对方没有打开在线咨询则无法发送消息,你可以直接加为好友。'),
          //buildButtonColumn(Icons.supervisor_account, '情侣空间','你和对象的私人空间.'), //no open
        ],
      ),
    );

    //协会模块
    Widget campus_xh_text = new Container(
      padding: const EdgeInsets.fromLTRB(32, 10, 32, 15),
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
          buildButtonColumn2('images/2.2.1.x/rjxh.png', '软件协会官方网站', '软件协会欢迎您!'),
          buildButtonColumn2('images/2.2.1.x/xhsk.png', '协会收款',
              '九职协会收款助手，帮助协会活动招新收款项目的整理以及归纳，谨慎交钱，开心你我他。'),
          buildButtonColumn2(
              'images/2.2.1.x/xhqhm.png', '协会群号码', '输入你的学号然后就会出现相应你加入的协会群号码。'),
          //buildButtonColumn(Icons.supervisor_account, '情侣空间','你和对象的私人空间.'), //no open
        ],
      ),
    );

    //娱乐模块
    Widget entertainment_text = new Container(
      padding: const EdgeInsets.fromLTRB(32, 10, 32, 15),
      child: new Text(
        '娱乐休闲',
        softWrap: true,
        style: new TextStyle(
          color: Color(int.parse(color2)),
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    Widget entertainment_button = new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn2('images/2.2.1.x/ppball.png', '碰碰球', '来吧，拼酒量，拼手速吧!'),
        ],
      ),
    );

    //博客模块
    Widget blog_text = new Offstage(
      offstage: blog_list.length==0?true:false,
      child: new Container(
        padding: const EdgeInsets.fromLTRB(32, 10, 32, 15),
        child: new Text(
          '个人博客',
          softWrap: true,
          style: new TextStyle(
            color: Color(int.parse(color2)),
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
    Widget blog_button = new Offstage(
      offstage: blog_list.length==0?true:false,
      child: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: blog_button_list,
        ),
      ),
    );

    //教师端模块
    Widget teach_text = new Container(
      padding: const EdgeInsets.fromLTRB(32, 10, 32, 15),
      child: new Text(
        '教师功能',
        softWrap: true,
        style: new TextStyle(
          color: Color(int.parse(color2)),
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    Widget teach_button = new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn2('images/2.2.1.x/jsxg.png', '教师教务系统', '课表查看需登陆此平台!'),
          buildButtonColumn2('images/2.2.1.x/jsjw.png', '教师学工平台', '请假审批，困难学生认证，销假，学生密码修改等!'),
          buildButtonColumn2('images/2.2.1.x/jsqd.png', '教师上课签到记录', '教师可以在此查看签到记录!'),
          buildButtonColumn2('images/2.2.1.x/jsxjmmxg.png', '教师学教密码修改', '教师在这里进行教务系统，学工平台的密码统一修改!'),
        ],
      ),
    );

    Widget student_ui(){
      return new ListView(
        children: [
          SwiperView(),
          campus_student_text,
          campus_student_button,
          campus_funcation_text,
          campus_funcation_button,
          campus_life_text,
          campus_life_button,
          campus_toolkit_text,
          campus_toolkit_button,
          blog_text,
          blog_button,
          entertainment_text,
          entertainment_button,
          campus_xh_text,
          campus_xh_button,
          SizedBox(
            height: 30,
          ),
        ],
      );
    }

    Widget teach_ui(){
      return new ListView(
        children: [
          SwiperView(),
          teach_text,
          teach_button,
          campus_funcation_text,
          campus_funcation_button,
          blog_text,
          blog_button,
          SizedBox(
            height: 30,
          ),
        ],
      );
    }

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
                if (login_state == false) {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new my_login()));
                } else {
                  _showmodel('你已登陆', Toast.LENGTH_SHORT, Colors.red);
                }
              },
              child: new ClipOval(
                child: new Image.memory(base64.decode(now_login_image_base64),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: MediaQueryData.fromWindow(ui.window).size.height*0.005,),
                        IconButton(
                          icon: Icon(Icons.notifications, color: Color(int.parse(color2))),
                          onPressed: () {
                            _updatenotify();
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new System_notice()));
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQueryData.fromWindow(ui.window).size.width*0.11,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('\n'+unread,style: TextStyle(fontSize: MediaQueryData.fromWindow(ui.window).size.height*0.018,fontWeight: FontWeight.bold, color: Colors.red,),textAlign: TextAlign.right,),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: Color(int.parse(color2))),
              onPressed: () {
                CoursePageState cp = new CoursePageState();
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
          child: ui_model=='学生版'?student_ui():teach_ui(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=4010497054,3899149768&fm=26&gp=0.jpg
    imageList.add(
        'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=4010497054,3899149768&fm=26&gp=0.jpg');
    _bmob_get_Shuffing_figure_information();
    _bmob_get_blog_information();
    //检查是否有学习周期任务未结束
    _check_student();
    //广播
    bus.on("dart_event", (arg) {
      setState(() {
        blog_button_list.clear();
        for(home_blog hb in blog_list){
          blog_button_list.add(buildButtonColumn3(hb.blog_image,
              hb.blog_name!=null?hb.blog_name:'',hb.blog_introduce!=null?hb.blog_introduce:'',hb));
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off("dart_event"); //移除广播机制
  }
}

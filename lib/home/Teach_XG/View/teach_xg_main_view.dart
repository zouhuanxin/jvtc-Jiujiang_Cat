import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_login_model.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_main_model.dart';
import 'package:flutter_app01/home/Teach_XG/View/teach_xg_login_view.dart';
import 'package:flutter_app01/home/Teach_XG/ViewModel/teach_xg_login_viewmodel.dart';
import 'package:flutter_app01/home/Teach_XG/ViewModel/teach_xg_main_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class teach_xg_main_view extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_xg_main_view_State();
  }

}

class teach_xg_main_view_State extends State<teach_xg_main_view>{
  var providers = Providers();
  //如果俩个不同界面需要使用同一个数据模型 需要保证俩者使用数据模型的唯一性
  //现在解决方案如下 第一 单例模式 第二 传对象
  var txmm,txmv,txlm,txlv;
  void _loading(){
    txmm= teach_xg_main_model();
    txmv= teach_xg_main_viewmodel(txmm);
    txlm = teach_xg_login_model();
    txlv = teach_xg_login_viewmodel(txlm);
    providers
        ..provide(Provider<teach_xg_main_viewmodel>.value(txmv))
        ..provide(Provider<teach_xg_login_viewmodel>.value(txlv));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  //头部框
  Widget head_Card(){
    return GestureDetector(
        child: Container(
          margin: const EdgeInsets.all(5.0),
          height: ScreenUtil().setHeight(300),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              border: new Border.all(width: 1.0, color: Colors.black12),
              color: Colors.white,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Provide<teach_xg_main_viewmodel>(builder: (context,child,value){
                    return new GestureDetector(
                      onTap: (){
                        value.jump(context, new teach_xg_login_view(value: txlv,));
                      },
                      child: Container(
                        child: new Image(image: new NetworkImage(value.defaul_image)),
                        padding: EdgeInsets.all(10.0),
                      ),
                    );
                  }),
                  flex: 1,
                ),
                Expanded(child: Provide<teach_xg_login_viewmodel>(builder: (context,child,value){
                  return Column(
                    children: <Widget>[
                      Expanded(child: Align(child: Text(value.username,style: TextStyle(fontSize:ScreenUtil(allowFontScaling: true).setSp(44),),),alignment: Alignment.center,),flex: 1,),
                      Expanded(child: Text(value.login_state,style: TextStyle(fontSize:ScreenUtil(allowFontScaling: true).setSp(44),)),flex: 1,),
                    ],
                  );
                }),flex: 3,)
              ],
            ),
          ),
        ),
      );
  }

  //身体部分
  Widget body_Card(url,text){
    return new Provide<teach_xg_main_viewmodel>(builder: (context,child,value){
      return GestureDetector(
        onTap: (){
          value.onclick_jump(text,context);
        },
        child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.all(5.0),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: new Border.all(width: 1.0, color: Colors.black12),
              color: Colors.white,
            ),
            height: ScreenUtil().setHeight(150),
            width: ScreenUtil().setWidth(540),
            child:new Row(
              children: <Widget>[
                Expanded(
                  child: new Image.asset(url),
                  flex: 1,
                ),
                Expanded(
                  child: Align(child: Text(text,style: TextStyle(fontSize:ScreenUtil(allowFontScaling: true).setSp(44),),textAlign: TextAlign.center,)),
                  flex: 10,
                ),
                Expanded(
                  child: new Image.asset('images/2.0.x/right01.png'),
                  flex: 1,
                ),
              ],
            )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProviderNode(
      providers: providers,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(
            '教师学工平台                                       ',
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
        body: new Container(
          decoration: BoxDecoration(color: Color(int.parse(color1))),
          child: ListView(
            children: <Widget>[
              head_Card(),
              body_Card('images/teach/geren.png','个人信息'),
              body_Card('images/teach/mima.png','学生密码修改'),
              body_Card('images/teach/shenhe.png','日常请假审核'),
              body_Card('images/teach/leasingcloud_xiaojiashenqing.png','日常销假管理'),
              body_Card('images/teach/icon-.png','密码修改'),
//              Row(
//                children: <Widget>[
//                  body_Card('https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=374032065,1076888434&fm=26&gp=0.jpg','节日请假审核'),
//                  body_Card('https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=374032065,1076888434&fm=26&gp=0.jpg','节日销假管理'),
//                ],
//              ),
            ],
          ),
        ),
      ),
    );
  }

}
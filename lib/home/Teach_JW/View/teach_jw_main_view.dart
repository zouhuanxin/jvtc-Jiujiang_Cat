import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_login_model.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_main_model.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_login_view.dart';
import 'package:flutter_app01/home/Teach_JW/ViewModel/teach_jw_login_viewmodel.dart';
import 'package:flutter_app01/home/Teach_JW/ViewModel/teach_jw_main_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class teach_jw_main_view extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_jw_main_view_State();
  }

}

class teach_jw_main_view_State extends State<teach_jw_main_view>{
  var providers = Providers();
  //如果俩个不同界面需要使用同一个数据模型 需要保证俩者使用数据模型的唯一性
  //现在解决方案如下 第一 单例模式 第二 传对象
  var tjmm,tjmv,tjlm,tjlv;
  void _loading(){
    tjmm= teach_jw_main_model();
    tjmv= teach_jw_main_viewmodel(tjmm);
    tjlm = teach_jw_login_model();
    tjlv = teach_jw_login_viewmodel(tjlm);
    providers
        ..provide(Provider<teach_jw_main_viewmodel>.value(tjmv))
        ..provide(Provider<teach_jw_login_viewmodel>.value(tjlv));
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
          height: ScreenUtil().setHeight(300),
          margin: const EdgeInsets.all(5.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              //borderRadius: BorderRadius.circular(10),
              border: new Border.all(width: 1.0, color: Colors.black12),
              color: Colors.white,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Provide<teach_jw_main_viewmodel>(builder: (context,child,value){
                    return new GestureDetector(
                      onTap: (){
                        value.jump(context, new teach_jw_login_view(value: tjlv,));
                      },
                      child: Container(
                        child: new Image(image: new NetworkImage(value.defaul_image)),
                        padding: EdgeInsets.all(10.0),
                      ),
                    );
                  }),
                  flex: 1,
                ),
                Expanded(child: Provide<teach_jw_login_viewmodel>(builder: (context,child,value){
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
    return new Provide<teach_jw_main_viewmodel>(builder: (context,child,value){
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
          child: new Row(
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
          ),),
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
            '教师教务系统                                       ',
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
              body_Card('images/teach/wj-mc.png','班级花名册'),
              body_Card('images/teach/kebiaochaxun.png','教师课表查询'),
              body_Card('images/teach/jiaoshi.png','教室课表查询'),
              body_Card('images/teach/lunkuodasan-.png','密码修改'),
            ],
          ),
        ),
      ),
    );
  }

}
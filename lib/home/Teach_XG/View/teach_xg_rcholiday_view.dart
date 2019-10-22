
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_XG/Model/teach_xg_rcholiday_model.dart';
import 'package:flutter_app01/home/Teach_XG/ViewModel/teach_xg_rcholiday_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class teach_xg_rcholiday_view extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_xg_rcholiday_view_State();
  }

}

class teach_xg_rcholiday_view_State extends State<teach_xg_rcholiday_view>{
  var providers = Providers();

  void _loading() async{
    var txrm= teach_xg_rcholiday_model();
    var txrv= teach_xg_rcholiday_viewmodel(txrm);
    providers.provide(Provider<teach_xg_rcholiday_viewmodel>.value(txrv));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  //日期选择框
  Widget drop1() {
    return new Align(
      alignment: Alignment.center,
      child: Provide<teach_xg_rcholiday_viewmodel>(builder:(context,child,value){
        return DropdownButton(
          items: value.items1,
          hint: new Text('日期', textAlign: TextAlign.center),
          //当没有默认值的时候可以设置的提示
          value: value.TermNo,
          //下拉菜单选择完之后显示给用户的值
          onChanged: (T) {
            value.set_TermNo(T);
          },
          elevation: 20,
          underline: Container(),
          //设置阴影的高度
          style: new TextStyle(
            //设置文本框里面文字的样式
              color: Colors.black),
          isDense: false,
          iconSize: 20.0, //设置三角标icon的大小
        );
       }),
    );
  }

  //状态选择框
  Widget drop2() {
    return new Align(
      alignment: Alignment.center,
      child: Provide<teach_xg_rcholiday_viewmodel>(builder:(context,child,value){
      return DropdownButton(
        items: value.items2,
        hint: new Text('状态', textAlign: TextAlign.center),
        //当没有默认值的时候可以设置的提示
        value: value.Status,
        //下拉菜单选择完之后显示给用户的值
        onChanged: (T) {
          value.set_Status(T);
        },
        elevation: 20,
        underline: Container(),
        //设置阴影的高度
        style: new TextStyle(
          //设置文本框里面文字的样式
            color: Colors.black),
        isDense: false,
        iconSize: 20.0, //设置三角标icon的大小
      );
     }),
    );
  }

  //查询按钮
  Widget search_button(){
    return new Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
      child: Provide<teach_xg_rcholiday_viewmodel>(builder: (context,child,value){return new RaisedButton(onPressed: (){
        value.search_data();
      },child: new Text('查询',style: TextStyle(color: Colors.white),),color: Colors.blue,);}),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProviderNode(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(
            '日常请假审批                                       ',
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
          child: Provide<teach_xg_rcholiday_viewmodel>(builder: (context,child,value){
            return ListView(
              padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: drop1(),flex: 2,),
                    Expanded(child: drop2(),flex: 2,),
                    Expanded(child: search_button(),flex: 1,),
                  ],
                ),
                Container(decoration: BoxDecoration(color: Color(int.parse(color2))),height: 1,),
                Column(
                  children: value.ui_list,
                )
              ],
            );
          }),
        ),
      ),
      providers: providers,
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_studentinfo_model.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_teachcourse_model.dart';
import 'package:flutter_app01/home/Teach_JW/Utils/Teach_JW_Util.dart';
import 'package:flutter_app01/home/Teach_JW/ViewModel/teach_jw_studentinfo_viewmodel.dart';
import 'package:flutter_app01/home/Teach_JW/ViewModel/teach_jw_teachcourse_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class teach_jw_teachcourse_view extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_jw_teachcourse_view_State();
  }

}

class teach_jw_teachcourse_view_State extends State<teach_jw_teachcourse_view>{
  Teach_JW_Util tju=Teach_JW_Util();

  var providers = Providers();
  void _loading() {
    var tjtm = teach_jw_teachcourse_model();
    var tjtv = teach_jw_teachcourse_viewmodel(tjtm,context);
    providers.provide(Provider<teach_jw_teachcourse_viewmodel>.value(tjtv));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  //学年学期选择框
  Widget drop1() {
    return new Align(
      alignment: Alignment.center,
      child: Provide<teach_jw_teachcourse_viewmodel>(builder:(context,child,value){
        return DropdownButton(
          items: value.getListData1(),
          hint: new Text('学年学期', textAlign: TextAlign.center),
          //当没有默认值的时候可以设置的提示
          value: value.xnxqh,
          //下拉菜单选择完之后显示给用户的值
          onChanged: (T) {
            value.set_drop_data('xnxqh',T);
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

  //上课院系选择框
  Widget drop2() {
    return new Align(
      alignment: Alignment.center,
      child: Provide<teach_jw_teachcourse_viewmodel>(builder:(context,child,value){
        return DropdownButton(
          items: value.getListData2(),
          hint: new Text('上课院系', textAlign: TextAlign.center),
          //当没有默认值的时候可以设置的提示
          value: value.skyx,
          //下拉菜单选择完之后显示给用户的值
          onChanged: (T) {
            value.set_drop_data('skyx',T);
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

  //授课教师输入框
  Widget skjs_input(){
    return new Container(
      margin: EdgeInsets.all(ScreenUtil().setHeight(20)),
      padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
      child: Provide<teach_jw_teachcourse_viewmodel>(builder: (context,child,value){
        return Column(
          children: <Widget>[
            TextField(
              maxLines: 1,
              decoration:  InputDecoration(
                hintText: '教师名称',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0)
              ),
              onChanged: (T){
                value.set_drop_data('skjs',T);
              },
              autofocus: false,
            ),
            Container(
              color: Color(int.parse(color2)),
              height: 1,
              margin: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(5), 0, 0),
            )
          ],
        );
      }),
    );
  }

  //周次选择框
  Widget drop3_1() {
    return new Align(
      alignment: Alignment.center,
      child: Provide<teach_jw_teachcourse_viewmodel>(builder:(context,child,value){
        return DropdownButton(
          items: tju.getzcData(),
          hint: new Text('周次start', textAlign: TextAlign.center),
          //当没有默认值的时候可以设置的提示
          value: value.zc1,
          //下拉菜单选择完之后显示给用户的值
          onChanged: (T) {
            value.set_drop_data('zc1',T);
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

  Widget drop3_2() {
    return new Align(
      alignment: Alignment.center,
      child: Provide<teach_jw_teachcourse_viewmodel>(builder:(context,child,value){
        return DropdownButton(
          items: tju.getzcData(),
          hint: new Text('周次end', textAlign: TextAlign.center),
          //当没有默认值的时候可以设置的提示
          value: value.zc2,
          //下拉菜单选择完之后显示给用户的值
          onChanged: (T) {
            value.set_drop_data('zc2',T);
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

  //星期选择框
  Widget drop4_1() {
    return new Align(
      alignment: Alignment.center,
      child: Provide<teach_jw_teachcourse_viewmodel>(builder:(context,child,value){
        return DropdownButton(
          items: tju.getxqData(),
          hint: new Text('星期start', textAlign: TextAlign.center),
          //当没有默认值的时候可以设置的提示
          value: value.skxq1,
          //下拉菜单选择完之后显示给用户的值
          onChanged: (T) {
            value.set_drop_data('skxq1',T);
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

  Widget drop4_2() {
    return new Align(
      alignment: Alignment.center,
      child: Provide<teach_jw_teachcourse_viewmodel>(builder:(context,child,value){
        return DropdownButton(
          items: tju.getxqData(),
          hint: new Text('星期end', textAlign: TextAlign.center),
          //当没有默认值的时候可以设置的提示
          value: value.skxq2,
          //下拉菜单选择完之后显示给用户的值
          onChanged: (T) {
            value.set_drop_data('skxq2',T);
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

  //节次选择框
  Widget drop5_1() {
    return new Align(
      alignment: Alignment.center,
      child: Provide<teach_jw_teachcourse_viewmodel>(builder:(context,child,value){
        return DropdownButton(
          items: tju.getjcData(),
          hint: new Text('节次start', textAlign: TextAlign.center),
          //当没有默认值的时候可以设置的提示
          value: value.jc1,
          //下拉菜单选择完之后显示给用户的值
          onChanged: (T) {
            value.set_drop_data('jc1',T);
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

  Widget drop5_2() {
    return new Align(
      alignment: Alignment.center,
      child: Provide<teach_jw_teachcourse_viewmodel>(builder:(context,child,value){
        return DropdownButton(
          items: tju.getjcData(),
          hint: new Text('节次end', textAlign: TextAlign.center),
          //当没有默认值的时候可以设置的提示
          value: value.jc2,
          //下拉菜单选择完之后显示给用户的值
          onChanged: (T) {
            value.set_drop_data('jc2',T);
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

  //搜索按钮
  Widget buildSearchButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child:
        Provide<teach_jw_teachcourse_viewmodel>(builder: (context, child, value) {
          return RaisedButton(
            child: Text(
              '查询',
              style: TextStyle(color: Color(int.parse(color1))),
            ),
            color: Color(int.parse(color2)),
            onPressed: () {
              value.search();
            },
            shape: StadiumBorder(side: BorderSide()),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProviderNode(
      providers: providers,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(
            '教师课表查询                                       ',
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
            padding:
            EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(50)),
            children: <Widget>[
              Text(
                '   学期,学院:',
                style: TextStyle(
                    color: Color(int.parse(color2)),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal),
              ),
              Row(
                children: <Widget>[
                  Expanded(child: drop1(),flex: 1,),
                  Expanded(child: drop2(),flex: 1,),
                ],
              ),
              Text(
                '   周次:',
                style: TextStyle(
                    color: Color(int.parse(color2)),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal),
              ),
              Row(
                children: <Widget>[
                  Expanded(child: drop3_1(),flex: 1,),
                  Expanded(child: drop3_2(),flex: 1,),
                ],
              ),
              Text(
                '   星期:',
                style: TextStyle(
                    color: Color(int.parse(color2)),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal),
              ),
              Row(
                children: <Widget>[
                  Expanded(child: drop4_1(),flex: 1,),
                  Expanded(child: drop4_2(),flex: 1,),
                ],
              ),
//              Text(
//                '   Four:',
//                style: TextStyle(
//                    color: Color(int.parse(color2)),
//                    fontSize: 16,
//                    fontWeight: FontWeight.w600,
//                    fontStyle: FontStyle.normal),
//              ),
//              Row(
//                children: <Widget>[
//                  Expanded(child: drop5_1(),flex: 1,),
//                  Expanded(child: drop5_2(),flex: 1,),
//                ],
//              ),
              Text(
                '   教师名称:',
                style: TextStyle(
                    color: Color(int.parse(color2)),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal),
              ),
              skjs_input(),
              SizedBox(height: ScreenUtil().setHeight(100),),
              buildSearchButton()
            ],
          ),
        ),
      ),
    );
  }

}
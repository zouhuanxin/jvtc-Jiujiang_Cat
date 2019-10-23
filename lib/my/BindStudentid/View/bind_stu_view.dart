
import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/my/BindStudentid/Model/bind_stu_model.dart';
import 'package:flutter_app01/my/BindStudentid/ViewModel/bind_stu_viewmodel.dart';
import 'package:provide/provide.dart';

class bind_stu_view extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return bind_stu_view_State();
  }

}

class bind_stu_view_State extends State<bind_stu_view>{
  var providers = Providers();

  @override
  void initState() {
    super.initState();
    bind_stu_model bsm=bind_stu_model();
    var bsv= bind_stu_viewmodel(bsm,context);
    providers.provide(Provider<bind_stu_viewmodel>.value(bsv));
  }

  //学号输入框
  Widget studentid_input() {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.all(5.0),
      child: Provide<bind_stu_viewmodel>(builder: (context,child,value){
        return Column(
          children: <Widget>[
            TextField(
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: value.studentid,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0)),
              textAlign: TextAlign.start,
              onChanged: (T) {
                value.set_studentid_input(T);
              },
              autofocus: false,
            ),
            new Container(
              color: Color(int.parse(color2)),
              height: 1,
              margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
            )
          ],
        );
      }),
    );
  }

  //密码输入框
  Widget password_input() {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.all(5.0),
      child: Provide<bind_stu_viewmodel>(builder: (context,child,value){
        return Column(
          children: <Widget>[
            TextField(
              maxLines: 1,
              decoration: InputDecoration(
                  hintText: '学工平台密码',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0)),
              textAlign: TextAlign.start,
              onChanged: (T) {
                value.set_password_input(T);
              },
              autofocus: false,
            ),
            new Container(
              color: Color(int.parse(color2)),
              height: 1,
              margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
            )
          ],
        );
      }),
    );
  }

  //绑定学号按钮
  Align buildSubmitButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: Provide<bind_stu_viewmodel>(builder: (context,child,value){
          return RaisedButton(
            child: Text(
              '绑  定',
              style: TextStyle(color: Color(int.parse(color1))),
            ),
            color: Color(int.parse(color2)),
            onPressed: () {
              value.Submit();
            },
            shape: StadiumBorder(side: BorderSide()),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return ProviderNode(
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                '绑定学号                                       ',
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
                  color: Color(int.parse(color1))
              ),
              child: new ListView(
                children: <Widget>[
                  Provide<bind_stu_viewmodel>(builder:(context,child,value){
                    return Text(
                      '   '+value.prompt_message,
                      style: TextStyle(
                          color: Color(int.parse(color2)),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal),
                    );
                  }),
                  SizedBox(height: 15,),
                  Text(
                    '   学号',
                    style: TextStyle(
                        color: Color(int.parse(color2)),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal),
                  ),
                  studentid_input(),
                  Text(
                    '   密码',
                    style: TextStyle(
                        color: Color(int.parse(color2)),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal),
                  ),
                  password_input(),
                  SizedBox(height: 50,),
                  buildSubmitButton(),
                  SizedBox(height: 50,),
                ],
              ),
            )),
        providers: providers
    );
  }

}
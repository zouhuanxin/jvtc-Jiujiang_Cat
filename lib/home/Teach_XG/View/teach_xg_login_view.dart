import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_XG/ViewModel/teach_xg_login_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class teach_xg_login_view extends StatefulWidget {
  final teach_xg_login_viewmodel value;

  const teach_xg_login_view({Key key, this.value}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_xg_login_view_State(value);
  }
}

class teach_xg_login_view_State extends State<teach_xg_login_view> {
  var providers = Providers();
  var txlv;

  teach_xg_login_view_State(teach_xg_login_viewmodel value){
    this.txlv=value;
  }

  void _loading() {
    providers.provide(Provider<teach_xg_login_viewmodel>.value(txlv));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  //账号输入框
  Widget username_input() {
    return new Container(
      child: new Provide<teach_xg_login_viewmodel>(
          builder: (context, child, value) {
        return TextField(
          maxLines: 1,
          decoration: InputDecoration(
            hintText: value.username,
            labelText: '学工号',
            fillColor: Colors.white,
            filled: dart_model,
            contentPadding:
                EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(50)),
          ),
          textAlign: TextAlign.start,
          onChanged: (T) {
            value.set_username(T);
          },
          autocorrect: false,
        );
      }),
    );
  }

  //密码输入框
  Widget password_input() {
    return new Container(
      child: new Provide<teach_xg_login_viewmodel>(
          builder: (context, child, value) {
        return TextField(
          maxLines: 1,
          decoration: InputDecoration(
            hintText: value.password,
            labelText: '密码',
            fillColor: Colors.white,
            filled: dart_model,
            contentPadding:
                EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(50)),
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Color(int.parse(color4)),
                ),
                onPressed: () {
                  value.set_pass_vis();
                }),
          ),
          textAlign: TextAlign.start,
          onChanged: (T) {
            value.set_password(T);
          },
          obscureText: value.pass_vis,
          autocorrect: false,
        );
      }),
    );
  }

  //登陆按钮
  Widget buildLoginButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child:
            Provide<teach_xg_login_viewmodel>(builder: (context, child, value) {
          return RaisedButton(
            child: Text(
              '登陆',
              style: TextStyle(color: Color(int.parse(color1))),
            ),
            color: Color(int.parse(color2)),
            onPressed: () {
              value.login(context);
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
            '教师学工平台登陆                                       ',
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
              SizedBox(
                height: kToolbarHeight,
              ),
              new Container(
                padding: EdgeInsets.all(8.0),
                child: new Text(
                  '教师教务LOGIN',
                  style: TextStyle(
                      fontSize: 30.0, color: Color(int.parse(color2))),
                ),
              ),
              new Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 4.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      color: Color(int.parse(color2)),
                      width: 40.0,
                      height: 2.0,
                    ),
                  )),
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              username_input(),
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              password_input(),
              SizedBox(
                height: ScreenUtil().setHeight(200),
              ),
              buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

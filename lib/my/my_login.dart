import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Learn_teach/learn_teach.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/my/my_register.dart';

class my_login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new my_login_State();

}

class my_login_State extends State<my_login>{

  final _formKey = GlobalKey<FormState>();
  String _phone, _password;
  SharedPreferences prefs;
  bool _isObscure=true;

  //Used to initialize object data methods
  void new_object() async{
    prefs= await SharedPreferences.getInstance();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new_object();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    new_object();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('登陆                                       ',
            textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Color(int.parse(color2))),
          backgroundColor: Color(int.parse(color1)),
          centerTitle: true,
          actions: <Widget>[
            new Container()
          ],
        ),
      body: new Container(
        decoration: BoxDecoration(
          color: Color(int.parse(color1))
        ),
        child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                new Container(
                  padding: EdgeInsets.all(8.0),
                  child: new Text(
                    '登陆LOGIN',
                    style: TextStyle(fontSize: 30.0,color: Color(int.parse(color2))),
                  ),
                ),
                new Padding(padding: EdgeInsets.only(left: 12.0, top: 4.0),child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    color: Color(int.parse(color2)),
                    width: 40.0,
                    height: 2.0,
                  ),
                )
                ),
                SizedBox(height: 50.0),
                buildEmailTextField(),
                SizedBox(height: 20.0),
                buildPasswordTextField(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                buildRegisterButton(context)
              ],
            )),
      ));
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: '密码',
          fillColor: Colors.white,
          filled: dart_model,
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: Color(int.parse(color4)),
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              })),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      initialValue: _phone,
      decoration: InputDecoration(
        labelText: '手机号',
        fillColor: Colors.white,
        filled: dart_model,
      ),
      validator: (String value) {
        var emailReg = RegExp(
            r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
        if (!emailReg.hasMatch(value)) {
          return '请输入正确的手机号码';
        }
      },
      onSaved: (String value) => _phone = value,
    );
  }

  var showcon;
  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Login',
            style: TextStyle(color: Color(int.parse(color1))),
          ),
          color: Color(int.parse(color2)),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
             // print('email:$_phone , assword:$_password');
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (con) {
                    showcon=con;
                    return new LoadingDialog(
                      text: "账号登录中…",
                    );
                  });
              login();
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  Align buildRegisterButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '注册',
            style: TextStyle(color: Color(int.parse(color1))),
          ),
          color: Color(int.parse(color2)),
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new my_register()));
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  void login() async{
    _bmob_get_QTuser_username_information(_phone);
  }

  void _bmob_get_QTuser_username_information(String phone){
    print(phone);
    BmobQuery<QTuser> query = BmobQuery();
    query.addWhereEqualTo("phone", phone.toString().trim());
    query.queryObjects().then((data) {
      List<QTuser> sfs = data.map((i) => QTuser.fromJson(i)).toList();
      if(sfs.length==1){
        if(sfs[0].password==_password){
          _loading_login_data(sfs[0]);
        }else{
          Navigator.pop(showcon);
          Util.showTaost('密码错误', Toast.LENGTH_SHORT, Colors.red);
        }
      }else{
        Navigator.pop(showcon);
        Util.showTaost('账号不存在', Toast.LENGTH_SHORT, Colors.red);
      }
    }).catchError((e) {
      Navigator.pop(showcon);
      print(BmobError.convert(e).error);
      Util.showTaost('账号不存在', Toast.LENGTH_SHORT, Colors.red);
    });
  }

  void _loading_login_data(QTuser qtuser) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    now_login_image_base64=qtuser.imagebase64;
    username=qtuser.username;
    phone=qtuser.phone;
    objectid=qtuser.objectId;
    now_studentid=qtuser.studentid;
    login_state=true;

    sharedPreferences.setString('now_login_image_base64', now_login_image_base64);
    sharedPreferences.setString('username', username);
    sharedPreferences.setString('phone', phone);
    sharedPreferences.setString('objectid', objectid);
    sharedPreferences.setString('now_studentid', now_studentid);
    sharedPreferences.setString('login_state', 'true');

    Util.showTaost('登陆成功', Toast.LENGTH_SHORT, Colors.blue);

    Navigator.pop(showcon);
    Navigator.pop(context);
  }

}
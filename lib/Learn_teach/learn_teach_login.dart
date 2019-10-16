import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Learn_teach/learn_teach.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';

class learn_teach_login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new learn_teach_login_State();

}

class learn_teach_login_State extends State<learn_teach_login>{

  final _formKey = GlobalKey<FormState>();
  String _studeng_id, _jw_password,_xg_paddword;
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
          title: new Text('学教平台                                       ',
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
                    '学教平台LOGIN',
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
                jw_buildPasswordTextField(context),
                SizedBox(height: 20.0),
                xg_buildPasswordTextField(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
              ],
            )),
      ));
  }


  TextFormField jw_buildPasswordTextField(BuildContext context) {
    if(prefs.getString('teach_password')!=null)  _jw_password=prefs.getString('teach_password');
    return TextFormField(
      initialValue: _jw_password,
      onSaved: (String value) => _jw_password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: '教务系统密码',
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

  TextFormField xg_buildPasswordTextField(BuildContext context) {
    if(prefs.getString('learn_password')!=null)  _xg_paddword=prefs.getString('learn_password');
    return TextFormField(
      initialValue: _xg_paddword,
      onSaved: (String value) => _xg_paddword = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: '学工密码',
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
    if(prefs.getString('learn_teach_student_id')!=null)  _studeng_id=prefs.getString('learn_teach_student_id');
    return TextFormField(
      initialValue: _studeng_id,
      decoration: InputDecoration(
        labelText: '学号',
        fillColor: Colors.white,
        filled: dart_model,
      ),
      validator: (String value) {
//        var emailReg = RegExp(
//            r"(([0-9])){9}$");
//        if (!emailReg.hasMatch(value)) {
//          return '请输入正确的学号';
//        }
      },
      onSaved: (String value) => _studeng_id = value,
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
            style: TextStyle(color: Color(int.parse(color1)),)
          ),
          color: Color(int.parse(color2)),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              //TODO 执行登录方法
              //print('email:$_studeng_id , assword:$_jw_password');
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

  void login() async{
    String jw_res=await HttpUtil.jwlogin('jwlogin', _studeng_id, _jw_password);
    String xg_res=await HttpUtil.xglogin('login', _studeng_id, _xg_paddword);
    Navigator.pop(showcon);
    Map<String, dynamic> jw_maptemp = json.decode(jw_res);
    Map<String, dynamic> xg_maptemp = json.decode(xg_res);

    if(jw_maptemp['code'].toString().trim()!='0'){
      Fluttertoast.showToast(
          msg: "教务系统登陆失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    if(xg_maptemp['code'].toString().trim()!='0'){
      Fluttertoast.showToast(
          msg: "学工平台登陆失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    if(jw_maptemp['code'].toString().trim()=='0'&&xg_maptemp['code'].toString().trim()=='0'){
      Fluttertoast.showToast(
          msg: "登陆成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );

      prefs.setString('jwcookie', jw_maptemp['cookie'].toString());
      prefs.setString('xgtoken', xg_maptemp['token'].toString());

      //Get the token and ask for personal information
      String person_info=await HttpUtil.xg_query_personal_info('user_info',await prefs.getString('xgtoken'));
      Map<String, Object>learn_teach_data_maptemp = json.decode(person_info);
      prefs.setString('learn_teach_data', json.encode(learn_teach_data_maptemp['data']).toString());

      String tempstr=json.encode(learn_teach_data_maptemp['data']);
      Map<String, Object>learn_teach_data_maptemp2 = json.decode(tempstr);
      prefs.setString('learn_teach_student_name', json.decode(json.encode(learn_teach_data_maptemp2['basicsinfo']))['StudentName'].toString());

      //save Account information
      //For automatic login
      prefs.setString('learn_teach_student_id', _studeng_id);
      prefs.setString('learn_password', _xg_paddword);
      prefs.setString('teach_password', _jw_password);

      Navigator.pop(context);
    }
  }
}
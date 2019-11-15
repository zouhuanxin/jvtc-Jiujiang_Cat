import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Learn_teach/learn_teach.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_app01/Utils/Record_Text.dart';

class library_login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new library_login_State();

}

class library_login_State extends State<library_login>{

  final _formKey = GlobalKey<FormState>();
  String _studeng_id, _library_password,_library_Verification_code;
  SharedPreferences prefs;
  bool _isObscure=true;
  var _verification_code_image_Base64data='';

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
    _get_Verification_code_image();
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
          title: new Text('图书馆                                       ',
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
          color: Color(int.parse(color1)),
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
                    '图书馆LOGIN',
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
                SizedBox(height: 20.0),
                new GestureDetector(
                  onTap: (){
                    setState(() {
                      _get_Verification_code_image();
                    });
                  },
                  child: new Image.memory(base64.decode(_verification_code_image_Base64data),),
                ),
                buildVerificationTextField(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
              ],
            )),
      ));
  }


  TextFormField buildPasswordTextField(BuildContext context) {
    if(prefs.getString('library_password')!=null)  _library_password=prefs.getString('library_password');
    return TextFormField(
      initialValue: _library_password,
      onSaved: (String value) => _library_password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: '图书馆密码(默认为身份证后六位)',
          fillColor: Colors.white,
          filled: dart_model,
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              })),
    );
  }

  TextFormField buildVerificationTextField(BuildContext context) {
    return TextFormField(
      initialValue: _library_Verification_code,
      onSaved: (String value) => _library_Verification_code = value,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入验证码';
        }
      },
      decoration: InputDecoration(
          labelText: '验证码',
          fillColor: Colors.white,
          filled: dart_model,
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
              onPressed: () {

              })),
    );
  }

  TextFormField buildEmailTextField() {
    if(prefs.getString('library_student_id')!=null)  _studeng_id=prefs.getString('library_student_id');
    return TextFormField(
      initialValue: _studeng_id,
      decoration: InputDecoration(
        labelText: '学号',
        fillColor: Colors.white,
        filled: dart_model,
      ),
      validator: (String value) {
        var emailReg = RegExp(
            r"(([0-9])){9}$");
        if (!emailReg.hasMatch(value)) {
          return '请输入正确的学号';
        }
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
  
  void _get_Verification_code_image() async{
    http.Response response=await http.get('http://dyzuis.cn:8080/test/tsyzinfo');
    Map<String,Object>map1=json.decode(response.body.toString());
    prefs.setString('tscookie', map1['cookie'].toString().split(";")[0].split("=")[1]);
    setState(() {
      _verification_code_image_Base64data=map1['data'];
    });
    //print(response.body);
  }

  void login() async{
    String library_res=await HttpUtil.library_login('tslogininfo', _studeng_id, _library_password,_library_Verification_code,prefs.getString('tscookie'));
    Navigator.pop(showcon);
    Map<String, dynamic> library_maptemp = json.decode(library_res);
    if(library_maptemp['code'].toString().trim()!='0'){
      Fluttertoast.showToast(
          msg: "图书馆登陆失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    if(library_maptemp['code'].toString().trim()=='0'){
      Fluttertoast.showToast(
          msg: "登陆成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );

      //Get the token and ask for personal information
      String person_info=await HttpUtil.library_person_information('tsmyinfo',prefs.getString('tscookie'));
      Map<String, Object>library_maptemp = json.decode(person_info);
      prefs.setString('library_data', json.encode(library_maptemp['data']).toString());

      String tempstr=json.encode(library_maptemp['data']);
      List<dynamic>library_data_listtemp1 = json.decode(tempstr);
      prefs.setString('library_student_name', json.decode(json.encode(library_data_listtemp1[0]))['td2'].toString());

      //save Account information
      //For automatic login
      prefs.setString('library_student_id', _studeng_id);
      prefs.setString('library_password', _library_password);
      prefs.setString('verification_code', _library_Verification_code);

      Navigator.pop(context);
    }
  }

}
import 'dart:async';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/index/index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SMS_password2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SMS_password2_State();
  }
}

class SMS_password2_State extends State<SMS_password2> {
  SharedPreferences sharedPreferences;
  final _formKey = GlobalKey<FormState>();
  var  now_pass1, now_pass2;
  bool _isObscure2 = true,
      _isObscure3 = true;

  //Data initialization
  void _load_data() async{
    sharedPreferences=await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load_data();
  }

  Widget buildSearchTextField2() {
    return new Container(
      margin: EdgeInsets.all(5.0),
      child: TextFormField(
        obscureText: _isObscure2,
        validator: (String value) {
          if (value.isEmpty) {
            return '请输入新密码';
          }
        },
        decoration: InputDecoration(
            labelText: '新密码',
            fillColor: Colors.white,
            filled: dart_model,
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Color(int.parse(color4)),
                ),
                onPressed: () {
                  setState(() {
                    _isObscure2 = !_isObscure2;
                  });
                })),
        onSaved: (String value) => now_pass1 = value,
      ),
    );
  }

  Widget buildSearchTextField3() {
    return new Container(
      margin: EdgeInsets.all(5.0),
      child: TextFormField(
        obscureText: _isObscure3,
        validator: (String value) {
          if (value.isEmpty) {
            return '请确认新密码';
          }
        },
        decoration: InputDecoration(
            labelText: '确认新密码',
            fillColor: Colors.white,
            filled: dart_model,
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Color(int.parse(color4)),
                ),
                onPressed: () {
                  setState(() {
                    _isObscure3 = !_isObscure3;
                  });
                })),
        onSaved: (String value) => now_pass2 = value,
      ),
    );
  }

  Align buildUploadButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '修改',
            style: TextStyle(color: Color(int.parse(color1))),
          ),
          color: Colors.blue,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              if (now_pass1 == now_pass2) {
                _bmob_get_QTuser_information();
              } else {
                _showmodel('俩次密码输入不一致', Toast.LENGTH_SHORT);
              }
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  void _showmodel(String mes, var type) {
    Fluttertoast.showToast(
        msg: mes,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void _bmob_get_QTuser_information() {
    BmobQuery<QTuser> query = BmobQuery();
    query.addWhereEqualTo("phone", phone);
    query.queryObjects().then((data) {
      List<QTuser> sfs = data.map((i) => QTuser.fromJson(i)).toList();
      if (sfs.length == 1) {
        //upload
        _updateSingle(sfs[0].objectId);
      } else {
        _showmodel('账号错误', Toast.LENGTH_SHORT);
      }
    }).catchError((e) {

    });
  }

  ///修改一条数据
  _updateSingle(id) {
    QTuser blog = QTuser();
    blog.objectId = id;
    blog.password = now_pass1;
    blog.update().then((BmobUpdated bmobUpdated) {
      _cancel_login_stystem();
    }).catchError((e) {
      //print(BmobError.convert(e).error);
      _showmodel('修改密码失败', Toast.LENGTH_SHORT);
    });
  }

  void _cancel_login_stystem() {
    sharedPreferences.setString('now_login_image_base64', '');
    sharedPreferences.setString('username', '');
    sharedPreferences.setString('phone', '');
    sharedPreferences.setString('login_state', 'false');

    now_login_image_base64 = default_image;
    username = '未登陆';
    phone = '未登陆';
    login_state = false;

    _showmodel('修改密码成功', Toast.LENGTH_SHORT);
    Navigator.pop(context);
    Navigator.pop(context);
  }

@override
Widget build(BuildContext context) {
  return new Scaffold(
      appBar: new AppBar(
        title: new Text('短信验证码修改                                       ',
          textAlign: TextAlign.left,
          style: TextStyle(color: Color(int.parse(color2)),
              fontWeight: FontWeight.w800,
              fontSize: 17),),
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
        child: new Container(
          child: new ListView(
            children: <Widget>[
              new Form(
                  key: _formKey,
                  child: new Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
//                        color: Color(int.parse('0xffF1F1F1')),
//                        border: new Border.all(
//                            width: 1.0, color: Color(int.parse('0xffF1F1F1'))),
//                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: new Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        buildSearchTextField2(),
                        SizedBox(height: 10),
                        buildSearchTextField3(),
                        SizedBox(height: 50),
                        buildUploadButton(),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ));
}}
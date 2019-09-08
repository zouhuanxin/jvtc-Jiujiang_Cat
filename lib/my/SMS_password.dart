import 'dart:async';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/bmob_sms.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/response/bmob_sent.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/index/index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SMS_password2.dart';

class SMS_password extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SMS_password_State();
  }
}

class SMS_password_State extends State<SMS_password> {
  final _formKey = GlobalKey<FormState>();
  var _phone,_verification_code;
  bool _loading_frame = false;


  TextFormField buildPhoneTextField() {
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
  Widget verification_code(){
    return new Container(
      child: new Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextFormField(
              initialValue: _verification_code,
              decoration: InputDecoration(
                labelText: '验证码',
                fillColor: Colors.white,
                filled: dart_model,
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return '验证码不能为空';
                }
              },
              onSaved: (String value) => _verification_code = value,
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: 120,
            height: 50,
            child: RaisedButton(onPressed: (){
              _sendSms(context);
            },
              color: Color(int.parse(color2)),
              child: new Text(_codeCountdownStr,style: TextStyle(color: Color(int.parse(color1)),fontSize: 15),),),
          ),
        ],
      ),
    );
  }

  void _sendSms(BuildContext context) {
    _formKey.currentState.save();
    reGetCountdown();
    BmobSms bmobSms = BmobSms();
    bmobSms.template = "";
    bmobSms.mobilePhoneNumber = _phone ;
    bmobSms.sendSms().then((BmobSent bmobSent) {
      _showtoast('发送成功',Toast.LENGTH_SHORT,Colors.blue);
    }).catchError((e) {
      print(BmobError.convert(e).error);
      _showtoast(BmobError.convert(e).error,Toast.LENGTH_SHORT,Colors.red);
    });
  }

  Timer _countdownTimer;
  String _codeCountdownStr = '获取验证码';
  int _countdownNum = 59;
  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
      _codeCountdownStr = '${_countdownNum--}重新获取';
      _countdownTimer =
      new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr = '${_countdownNum--}重新获取';
          } else {
            _codeCountdownStr = '获取验证码';
            _countdownNum = 59;
            _countdownTimer.cancel();
            _countdownTimer = null;
          }
        });
      });
    });
  }

  void _showtoast(String mes,var type, var color) {
    Fluttertoast.showToast(
        msg: mes,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  var showmodel;
  Align buildjumpButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '验证',
            style: TextStyle(color: Color(int.parse(color1))),
          ),
          color: Color(int.parse(color2)),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              setState(() {
                _loading_frame = true;
              });
              _verifySmsCode(context);
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  void _verifySmsCode(BuildContext context) {
    BmobSms bmobSms = BmobSms();
    bmobSms.mobilePhoneNumber = _phone;
    bmobSms.verifySmsCode(_verification_code).then((BmobHandled bmobHandled) {
       //print('验证成功');
       //_showtoast('验证成功',Toast.LENGTH_SHORT,Colors.blue);
       phone=_phone;
       setState(() {
         _loading_frame = false;
       });
       Navigator.push(context,
           new MaterialPageRoute(builder: (context) => new SMS_password2()));
    }).catchError((e) {
      // print(BmobError.convert(e).error);
      setState(() {
        _loading_frame = false;
      });
      _showtoast(BmobError.convert(e).error,Toast.LENGTH_SHORT,Colors.red);
    });
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
      body: ModalProgressHUD(inAsyncCall: _loading_frame,
          child: new Container(
            decoration: BoxDecoration(
              color: Color(int.parse(color1)),
            ),
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 22.0),
                  children: <Widget>[
                    buildPhoneTextField(),
                    SizedBox(height: 20.0),
                    verification_code(),
                    SizedBox(height: 20.0),
                    buildjumpButton(),
                    SizedBox(height: 20.0),
                  ],
                )),
          )));
}}
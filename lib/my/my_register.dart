import 'dart:async';

import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_sent.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/QTuser.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Learn_teach/learn_teach.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:data_plugin/bmob/bmob_sms.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class my_register extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new my_register_State();

}

class my_register_State extends State<my_register>{

  final _formKey = GlobalKey<FormState>();
  String _phone, _password,_username,_verification_code;
  SharedPreferences prefs;
  bool _isObscure=true;
  bool _loading_frame = false;
  var _imageFile;
  String bs64;
  static const androidplatform = const MethodChannel("test");

  //Used to initialize object data methods
  void new_object() async{
    prefs= await SharedPreferences.getInstance();
    setState(() {

    });
  }

  void _selectedImage() async{
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  void _imagetobase64(File value) async{
    String path=await androidplatform.invokeMethod("getFile",{"path":value.path});
    File file=new File(path);
    List bytes=await file.readAsBytes();
    bs64 = base64Encode(bytes);
    if(bs64.length>160000){
      bs64=null;
      Fluttertoast.showToast(
          msg: "图片过大,请重新选择头像",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  Widget _previewImage() {
    return new GestureDetector(
      onTap: (){_selectedImage();},
      child: FutureBuilder<File>(
          future: _imageFile,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              File file=snapshot.data;
              new Future(()=>_imagetobase64(file));
              return new ClipOval(
                child: SizedBox(
                    width: 70.0,
                    height: 70.0,
                    child: Image.file(snapshot.data, fit: BoxFit.cover)
                ),
              );
            } else {
              return new Image.asset("images/2.0.x/choose_register_image.png", height: 70.0, width: 70.0,color: Color(int.parse(color2)),);
            }
          }),
    );
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
          title: new Text('QT注册                                       ',
            textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
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
                    SizedBox(
                      height: kToolbarHeight,
                    ),
                    new Container(
                      padding: EdgeInsets.all(8.0),
                      child: new Text(
                        '注册LOGIN',
                        style: TextStyle(fontSize: 30.0,color: Color(int.parse(color2)),),
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
                    SizedBox(height: 40.0),
                    new Align(
                      alignment: FractionalOffset.center,
                      child: _previewImage(),
                    ),
                    SizedBox(height: 20.0),
                    buildUsernameTextField(),
                    SizedBox(height: 20.0),
                    buildPasswordTextField(context),
                    SizedBox(height: 20.0),
                    buildPhoneTextField(),
                    SizedBox(height: 20.0),
                    verification_code(),
                    SizedBox(height: 50.0),
                    buildLoginButton(),
                    SizedBox(height: 20.0),
                  ],
                )),
          )));
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

  TextFormField buildUsernameTextField() {
    return TextFormField(
      initialValue: _username,
      decoration: InputDecoration(
        labelText: '用户名',
        fillColor: Colors.white,
        filled: dart_model,
      ),
      validator: (String value) {
        if(value.isEmpty){
          return '请输入用户名';
        }
      },
      onSaved: (String value) => _username = value,
    );
  }

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

  var showmodel;
  Align buildLoginButton() {
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
            if (_formKey.currentState.validate()) {
              if(bs64!=null&&bs64.length>1000){
                _formKey.currentState.save();
                setState(() {
                  _loading_frame = true;
                });
                _verifySmsCode(context);
              }else{
                Fluttertoast.showToast(
                    msg: "请重新选择头像,或者等待",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
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
      print('发送成功');
      Fluttertoast.showToast(
          msg: '发送成功',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }).catchError((e) {
      print(BmobError.convert(e).error);
      Fluttertoast.showToast(
          msg: BmobError.convert(e).error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }

  void _verifySmsCode(BuildContext context) {
    BmobSms bmobSms = BmobSms();
    bmobSms.mobilePhoneNumber = _phone;
    bmobSms.verifySmsCode(_verification_code).then((BmobHandled bmobHandled) {
     // print('验证成功');
      _saveSingle(context);
    }).catchError((e) {
     // print(BmobError.convert(e).error);
      setState(() {
        _loading_frame = false;
      });
      Fluttertoast.showToast(
          msg: BmobError.convert(e).error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }

  _saveSingle(BuildContext context) {
    QTuser qtuser = QTuser();
    qtuser.username=_username;
    qtuser.password=_password;
    qtuser.phone=_phone;
    qtuser.imagebase64=bs64;
    qtuser.save().then((BmobSaved bmobSaved) {
      setState(() {
        _loading_frame = false;
      });
      Fluttertoast.showToast(
          msg: '注册成功',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pop(context);
    }).catchError((e) {
      //print(BmobError.convert(e).error);
      setState(() {
        _loading_frame = false;
      });
      Fluttertoast.showToast(
          msg: BmobError.convert(e).error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
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

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

}
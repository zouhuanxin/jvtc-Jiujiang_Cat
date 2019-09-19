import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_app01/HttpUtil/Lose_HttpUtil.dart';

//失物招领

class lf_releasea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => lf_releasea_State();
}

class lf_releasea_State extends State<lf_releasea> {
  String now_choose_date =
      new DateTime.now().toString().split(' ')[0].toString(); //当前选择日期
  var imageFile1, imageFile2, imageFile3, bs641, bs642, bs643;
  static const androidplatform = const MethodChannel("test");
  bool _loading_frame = false;

  List<String>image_list=[]; //放置三个图片存储对象
  String introduce_str,address_str,reware_str;

  Widget introduce_input() {
    return new Container(
      margin: EdgeInsets.all(5.0),
      child: TextField(
        maxLength: 250,
        maxLines: 10,
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.grey.shade100,
            filled: true,
            hintText: '丢失物品大概介绍',
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0)),
        textAlign: TextAlign.start,
        onChanged: (T) {
          introduce_str=T;
        },
        autofocus: false,
      ),
    );
  }

  Widget address_input() {
    return new Container(
      margin: EdgeInsets.all(5.0),
      child: TextField(
        maxLength: 12,
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.grey.shade100,
            filled: true,
            hintText: '丢失物品大概地址',
            contentPadding: const EdgeInsets.symmetric(vertical: 5.0)),
        textAlign: TextAlign.start,
        onChanged: (T) {
          address_str=T;
        },
        autofocus: false,
      ),
    );
  }

  Widget time_select() {
    return new Container(
        //color:Color(int.parse('0xffF1F1F1')),
        padding:
            EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                //color:Color(int.parse('0xffF1F1F1')),
                child: Text(
                  now_choose_date,
                  style: TextStyle(color: Color(int.parse(color2))),
                  textAlign: TextAlign.center,
                ),
              ),
              flex: 5,
            ),
            Expanded(
              child: GestureDetector(
                  child: new Icon(Icons.date_range,
                      color: Color(int.parse(color2))),
                  onTap: () {
                    DatePicker.showDatePicker(context, showTitleActions: true,
                        onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      print('onConfirm $date');
                      setState(() {
                        now_choose_date = date.toString().split(' ')[0];
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.zh);
                  }),
              flex: 1,
            ),
          ],
        ));
  }

  Widget money_input() {
    return new Container(
      margin: EdgeInsets.all(5.0),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.grey.shade100,
            filled: true,
            hintText: '是否有奖励金，如果无则写0',
            contentPadding: const EdgeInsets.symmetric(vertical: 5.0)),
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly, //只输入数字
          LengthLimitingTextInputFormatter(4) //限制长度
        ],
        textAlign: TextAlign.start,
        onChanged: (T) {
          reware_str=T;
        },
        autofocus: false,
      ),
    );
  }

  Widget _previewImage1() {
    return new GestureDetector(
      onTap: () {
        _selectedImage();
      },
      child: FutureBuilder<File>(
          future: imageFile1,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              File file = snapshot.data;
              new Future(() => _imagetobase64(file));
              return new Container(
                child: SizedBox(
                    width: 70.0,
                    height: 90.0,
                    child: Image.file(snapshot.data, fit: BoxFit.fill)),
              );
            } else {
              return new Image.asset(
                "images/2.0.x/xz.png",
                height: 70.0,
                width: 70.0,
                color: Color(int.parse(color2)),
              );
            }
          }),
    );
  }

  void _selectedImage() async {
    setState(() {
      imageFile1 = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  void _imagetobase64(File value) async {
    String path =
        await androidplatform.invokeMethod("getFile", {"path": value.path});
    File file = new File(path);
    List bytes = await file.readAsBytes();
    bs641 = base64Encode(bytes);
  }

  Widget _previewImage2() {
    return new GestureDetector(
      onTap: () {
        _selectedImage2();
      },
      child: FutureBuilder<File>(
          future: imageFile2,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              File file = snapshot.data;
              new Future(() => _imagetobase642(file));
              return new Container(
                child: SizedBox(
                    width: 70.0,
                    height: 90.0,
                    child: Image.file(snapshot.data, fit: BoxFit.fill)),
              );
            } else {
              return new Image.asset(
                "images/2.0.x/xz.png",
                height: 70.0,
                width: 70.0,
                color: Color(int.parse(color2)),
              );
            }
          }),
    );
  }

  void _selectedImage2() async {
    setState(() {
      imageFile2 = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  void _imagetobase642(File value) async {
    String path =
        await androidplatform.invokeMethod("getFile", {"path": value.path});
    File file = new File(path);
    List bytes = await file.readAsBytes();
    bs642 = base64Encode(bytes);
  }

  Widget _previewImage3() {
    return new GestureDetector(
      onTap: () {
        _selectedImage3();
      },
      child: FutureBuilder<File>(
          future: imageFile3,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              File file = snapshot.data;
              new Future(() => _imagetobase643(file));
              return new Container(
                child: SizedBox(
                    width: 70.0,
                    height: 90.0,
                    child: Image.file(snapshot.data, fit: BoxFit.fill)),
              );
            } else {
              return new Image.asset(
                "images/2.0.x/xz.png",
                height: 70.0,
                width: 70.0,
                color: Color(int.parse(color2)),
              );
            }
          }),
    );
  }

  void _selectedImage3() async {
    setState(() {
      imageFile3 = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  void _imagetobase643(File value) async {
    String path =
        await androidplatform.invokeMethod("getFile", {"path": value.path});
    File file = new File(path);
    List bytes = await file.readAsBytes();
    bs643 = base64Encode(bytes);
  }

  Widget three_image() {
    return new Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(
            '请选择图片,如果没有图片可以不选择.',
            style: TextStyle(color: Color(int.parse(color2))),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _previewImage1(),
              ),
              Expanded(
                flex: 1,
                child: _previewImage2(),
              ),
              Expanded(
                flex: 1,
                child: _previewImage3(),
              )
            ],
          )
        ],
      ),
    );
  }

  Align buildSubmitButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '提交',
            style: TextStyle(color: Color(int.parse(color1))),
          ),
          color: Color(int.parse(color2)),
          onPressed: () {
            //处理图片
            if(bs641.toString().length>10){
              image_list.add(bs641.toString());
            }else{
              image_list.add('null');
            }
            if(bs642.toString().length>10){
              image_list.add(bs642.toString());
            }else{
              image_list.add('null');
            }
            if(bs643.toString().length>10){
              image_list.add(bs643.toString());
            }else{
              image_list.add('null');
            }
            //print('imagelist:$image_list');
            //判断数据是否为空
            if(introduce_str!=null&&address_str!=null&&reware_str!=null){
              _loading_frame=true;
              submit();
            }else{
              showTaost('请填写完信息', Toast.LENGTH_SHORT, Colors.red);
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  void submit() async{
    String str1=await Lose_HttpUtil.add_losea('losea_router/addlosea',image_list.toString(),introduce_str,address_str,now_choose_date,reware_str,phone);
    var emailReg = RegExp(r'[0-9_]+$');
    _loading_frame=false;
    if(emailReg.hasMatch(str1)){
      //提交成功后清除数据
//      introduce_str=null;
//      address_str=null;
//      reware_str=null;
      showTaost('提交成功', Toast.LENGTH_SHORT, Colors.blue);
    }else{
      showTaost('提交失败', Toast.LENGTH_SHORT, Colors.red);
    }
  }

  void showTaost(msg, type, color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: _loading_frame,
      child: Container(
        decoration: BoxDecoration(color: Color(int.parse(color1))),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            time_select(),
            introduce_input(),
            address_input(),
            money_input(),
            three_image(),
            SizedBox(
              height: 10,
            ),
            buildSubmitButton(),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    ));
  }
}

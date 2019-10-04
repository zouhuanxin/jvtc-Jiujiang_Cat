import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app01/Bean/competition.dart';
import 'package:flutter_app01/Bean/competition_type.dart';
import 'package:flutter_app01/HttpUtil/FileHttp.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_app01/HttpUtil/Lose_HttpUtil.dart';

//失物招领

class competition_release extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => competition_release_State();
}

class competition_release_State extends State<competition_release> {
  var imageFile1,imageFile2,imageFile3;
  static const androidplatform = const MethodChannel("test");
  bool _loading_frame = false;

  String introduce_str=null, url_str=null, drop_value=null;
  List<String> imageurls=[];
  File file1=null,file2=null,file3=null;
  bool bol2=true,bol3=true;

  List<competition_type> droptype = []; //服务器返回到分类数据

  Widget introduce_input() {
    return new Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(5.0),
      child: TextField(
        maxLength: 300,
        maxLines: 8,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0)),
        textAlign: TextAlign.start,
        onChanged: (T) {
          introduce_str = T;
        },
        autofocus: false,
      ),
    );
  }

  Widget url_input() {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.all(5.0),
      child: TextField(
        maxLines: 1,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 0)),
        textAlign: TextAlign.start,
        onChanged: (T) {
          url_str = T;
        },
        autofocus: false,
      ),
    );
  }

  gettype() async {
    BmobQuery<competition_type> query = BmobQuery();
    query.addWhereEqualTo("vis", "true");
    query.queryObjects().then((data) {
      setState(() {
        droptype = data.map((i) => competition_type.fromJson(i)).toList();
      });
    }).catchError((e) {});
  }

  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items = new List();
    for (var i = 0; i < droptype.length; i++) {
      DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
        child: new Text(droptype[i].text),
        value: droptype[i].text,
      );
      items.add(dropdownMenuItem);
    }
    return items;
  }

  Widget drop() {
    return new Align(
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              '分类',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(int.parse(color2))),
            ),
            flex: 1,
          ),
          Expanded(
            child: DropdownButton(
              items: getListData(),
              hint: new Text('请选择', textAlign: TextAlign.center),
              //当没有默认值的时候可以设置的提示
              value: drop_value,
              //下拉菜单选择完之后显示给用户的值
              onChanged: (T) {
                setState(() {
                  drop_value = T;
                });
              },
              elevation: 20,
              underline: Container(),
              //设置阴影的高度
              style: new TextStyle(
                  //设置文本框里面文字的样式
                  color: Colors.black),
              isDense: false,
              iconSize: 20.0, //设置三角标icon的大小
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  void _selectedImage() async {
    setState(() {
      imageFile1 = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  void _selectedImage2() async {
    setState(() {
      imageFile2 = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  void _selectedImage3() async {
    setState(() {
      imageFile3 = ImagePicker.pickImage(source: ImageSource.gallery);
    });
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
              file1 = snapshot.data;
              return new Container(
                child: SizedBox(
                    width: 70.0,
                    height: 90.0,
                    child: Image.file(snapshot.data, fit: BoxFit.fill)),
              );
            } else {
              return new Image.asset(
                "images/2.2.x/addimage.png",
                height: 70.0,
                width: 70.0,
                color: Color(int.parse(color2)),
              );
            }
          }),
    );
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
              file2 = snapshot.data;
              return new Container(
                child: SizedBox(
                    width: 70.0,
                    height: 90.0,
                    child: Image.file(snapshot.data, fit: BoxFit.fill)),
              );
            } else {
              return new Image.asset(
                "images/2.2.x/addimage.png",
                height: 70.0,
                width: 70.0,
                color: Color(int.parse(color2)),
              );
            }
          }),
    );
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
              file3 = snapshot.data;
              return new Container(
                child: SizedBox(
                    width: 70.0,
                    height: 90.0,
                    child: Image.file(snapshot.data, fit: BoxFit.fill)),
              );
            } else {
              return new Image.asset(
                "images/2.2.x/addimage.png",
                height: 70.0,
                width: 70.0,
                color: Color(int.parse(color2)),
              );
            }
          }),
    );
  }

  Widget three_image() {
    return new Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
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

  Align buildSubmitButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '报名',
            style: TextStyle(color: Color(int.parse(color1))),
          ),
          color: Color(int.parse(color2)),
          onPressed: () {
            if(drop_value!=null&&introduce_str!=null){
              //先上次三张图
              //再上传资料
              _uploadiamge();
            }else{
              showTaost("请填写完整信息",Toast.LENGTH_SHORT,Colors.red);
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  //上传图片
  void _uploadiamge() async{
    if(file1!=null){
      imageurls.add(await FileHttp.uploadFile(await androidplatform.invokeMethod("getFile", {"path": file1.path})));
    }
    if(file2!=null){
      imageurls.add(await FileHttp.uploadFile(await androidplatform.invokeMethod("getFile", {"path": file2.path})));
    }
    if(file3!=null){
      imageurls.add(await FileHttp.uploadFile(await androidplatform.invokeMethod("getFile", {"path": file3.path})));
    }
    if(file1==null&&file2==null&&file3==null){
      imageurls.add('https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3956878071,2257649761&fm=26&gp=0.jpg');
    }
    await _saveSingle();
  }

  ///保存一条数据
  _saveSingle() {
    competition cp = competition();
    cp.phone=phone;
    cp.number='0';
    cp.url=url_str;
    cp.introduce=introduce_str;
    cp.type=drop_value;
    cp.logo=imageurls[0];
    cp.image2=imageurls.length>1?imageurls[1]:null;
    cp.image3=imageurls.length>2?imageurls[2]:null;
    cp.save().then((BmobSaved bmobSaved) {
      showTaost('报名成功',Toast.LENGTH_SHORT,Colors.blue);
      Navigator.pop(context);
    }).catchError((e) {
      //print(BmobError.convert(e).error);
      showTaost(BmobError.convert(e).error,Toast.LENGTH_SHORT,Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '报名参赛                                       ',
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
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: <Widget>[new Container()],
        ),
        body: ModalProgressHUD(
          inAsyncCall: _loading_frame,
          child: Container(
            decoration: BoxDecoration(color: Color(int.parse(color1))),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  '   项目连接(选填)',
                  style: TextStyle(
                      color: Color(int.parse(color2)),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal),
                ),
                url_input(),
                Text(
                  '   项目介绍(必填)',
                  style: TextStyle(
                      color: Color(int.parse(color2)),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal),
                ),
                introduce_input(),
                Text(
                  '   参加活动项目(必选)',
                  style: TextStyle(
                      color: Color(int.parse(color2)),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal),
                ),
                drop(),
                Row(
                  children: <Widget>[
                    Text(
                      '   项目图片(必选)',
                      style: TextStyle(
                          color: Color(int.parse(color2)),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal),
                    ),
                    Text(
                      '   请按照主办方要求来填写',
                      style: TextStyle(
                        color: Color(int.parse(color2)),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettype();
  }
}

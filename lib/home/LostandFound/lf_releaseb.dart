import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class lf_releaseb extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => lf_releaseb_State();
}

class lf_releaseb_State extends State<lf_releaseb> {
  String now_choose_date =
      new DateTime.now().toString().split(' ')[0].toString(); //当前选择日期
  var imageFile1, imageFile2, imageFile3, bs641, bs642, bs643;
  static const androidplatform = const MethodChannel("test");
  bool _loading_frame = false;

  List<String> image_list = []; //放置三个图片存储对象
  String introduce_str, address_str, drop_value = null;

  String tz, wz, tp;

  int tz_net_num = 0,
      wz_net_num = 0,
      tp_net_num = 0; //应该发送网络请求当前个数  每个最大为3 分别是特征 文字 图片

  List<dynamic> droptype=[{"text":"请选择"}]; //服务器返回到分类数据

  Widget introduce_input() {
    return new Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(5.0),
      child: TextField(
        maxLength: 250,
        maxLines: 10,
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

  Widget address_input() {
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
          address_str = T;
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

  gettype() async{
    String str1 = await Lose_HttpUtil.get_losetype('losetype_router/getlosetype');
    droptype = json.decode(str1);
    getListData();
  }

  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items = new List();
    for (var i = 0; i < droptype.length; i++) {
      Map<String, dynamic> map = json.decode(json.encode(droptype[i]));
      DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
        child: new Text(map['text']),
        value: map['text'],
      );
      items.add(dropdownMenuItem);
    }
    setState(() {

    });
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
                "images/2.2.x/addimage.png",
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
                "images/2.2.x/addimage.png",
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
                "images/2.2.x/addimage.png",
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
            image_list.clear();
            if (bs641.toString().length > 10) {
              image_list.add(bs641.toString());
            } else {
              image_list.add('null');
            }
            if (bs642.toString().length > 10) {
              image_list.add(bs642.toString());
            } else {
              image_list.add('null');
            }
            if (bs643.toString().length > 10) {
              image_list.add(bs643.toString());
            } else {
              image_list.add('null');
            }
            //print('imagelist:$image_list');
            //判断数据是否为空
            if (introduce_str != null &&
                address_str != null &&
                drop_value != null) {
              setState(() {
                _loading_frame = true;
              });
              //验证通过提交顺序
              //1.提交百度服务器进行文字识别
              //2.提交百度服务器进行通用物体识别
              //3.保存本地服务器  把这个放在这一步是为了方便获取到唯一索引号以便于以图搜图获取本地数据信息
              //4.提交百度相似图库获取返回id 后面删除此张照片要用
              tz_net_num=0;
              wz_net_num=0;
              tp_net_num=0;
              tz='';
              wz='';
              tp='';
              sub_tz(image_list[tz_net_num]);
            } else {
              showTaost('请填写完信息', Toast.LENGTH_SHORT, Colors.red);
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  void sub_tz(bs64) async {
    if (bs64 != 'null') {
      String str1 = await Lose_HttpUtil.get_bdtoken();
      String str2 = await Lose_HttpUtil.advanced_general(
          convert.jsonDecode(str1)['access_token'], bs64);
      if (tz == null) {
        tz = str2;
      } else {
        tz = tz + ',' + str2;
      }
    }
    tz_net_num++;
    if (tz_net_num < image_list.length) {
      sub_tz(image_list[tz_net_num]);
    } else {
      sub_wz(image_list[wz_net_num]);
    }
  }

  void sub_wz(bs64) async {
    //这里取消使用百度通用文字识别 换成 网络文字识别 提高识别精准度问题
    if (bs64 != 'null') {
//      String str1 = await HttpUtil.image_text_sb('bdtextsb',
//          'pOyNhIyUDMMXBovrTEKb4TX8', 'NIDGGuijgHgbpcR5o3sQy33j1ORfwS7A', bs64);
      String str1 = await Lose_HttpUtil.get_bdtoken();
      String str2 = await Lose_HttpUtil.get_bdwlwz(convert.jsonDecode(str1)['access_token'], bs64);
      if (wz == null) {
        wz = str2;
      } else {
        wz = wz + ',' + str2;
      }
    }
    wz_net_num++;
    if (wz_net_num < image_list.length) {
      sub_wz(image_list[wz_net_num]);
    } else {
      submit_bd();
    }
  }

  //提交信息到自己服务器
  //暂时不适用tp字段 以id代替brief
  void submit_bd() async {
//    print('tz$tz');
//    print('wz$wz');
    String str1 = await Lose_HttpUtil.add_loseb(
        'loseb_router/addloseb',
        image_list.toString(),
        introduce_str,
        address_str,
        now_choose_date,
        drop_value,
        tz,
        wz,
        '',
        phone);
    var emailReg = RegExp(r'[0-9_]+$');
    if (emailReg.hasMatch(str1)) {
      sub_tp(image_list[tp_net_num],str1);
    } else {
      setState(() {
        _loading_frame=false;
      });
      showTaost('提交失败', Toast.LENGTH_SHORT, Colors.red);
    }
  }

  void sub_tp(bs64, id) async {
    if (bs64 != 'null') {
      String str1 = await Lose_HttpUtil.get_bdtoken();
      //入库
      //brief 等于 id
      String str2 = await Lose_HttpUtil.add_bdimage(
          convert.jsonDecode(str1)['access_token'], bs64, id);
      if (tp == null) {
        tp = str2;
      } else {
        tp = tp + ',' + str2;
      }
    }
    tp_net_num++;
    if (tp_net_num < image_list.length) {
      sub_tp(image_list[tp_net_num],id);
    } else {
      setState(() {
        _loading_frame = false;
      });
      bus.emit("fb", (arg){});
      showTaost('提交成功', Toast.LENGTH_SHORT, Colors.blue);
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
            Text('   拾取物品介绍(必填)',style: TextStyle(color: Color(int.parse(color2)),fontSize: 16,fontWeight: FontWeight.w600,fontStyle: FontStyle.normal),),
            introduce_input(),
            Text('   拾取物品地址(必填)',style: TextStyle(color: Color(int.parse(color2)),fontSize: 16,fontWeight: FontWeight.w600,fontStyle: FontStyle.normal),),
            address_input(),
            Text('   拾取物品分类(必选)',style: TextStyle(color: Color(int.parse(color2)),fontSize: 16,fontWeight: FontWeight.w600,fontStyle: FontStyle.normal),),
            drop(),
            Row(
              children: <Widget>[
                Text('   拾取物品图片(必选)',style: TextStyle(color: Color(int.parse(color2)),fontSize: 16,fontWeight: FontWeight.w600,fontStyle: FontStyle.normal),),
                Text('   如无图片可以不选择',style: TextStyle(color: Color(int.parse(color2)),fontSize: 10,),),
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

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

//失物招领多功能搜索框
class Search extends StatelessWidget {
  final ValueChanged<String> onChanged;

  final List<DropdownMenuItem> list1;
  final String drop_value;
  final ValueChanged<String> onChanged_drop;
  final res;  //搜索点击方法回调

  final imageFile;  //图片路径
  final selectimage;  //选择图片方法回调
  final base64_callback;  //最后得到的base64回调

  final String date_str; //日期时间
  final date_callback;

  const Search(
      {Key key,
      this.list1,
      this.onChanged,
      this.drop_value,
      this.onChanged_drop, this.res, this.imageFile, this.selectimage, this.base64_callback, this.date_str, this.date_callback})
      : super(key: key);

  void _ActiveChanged(String str) {
    onChanged(str);
  }

  void _drop_ActiveChanged(T) {
    onChanged_drop(T);
  }

  void _onclick_search(){
    res();
  }

  Widget drop() {
    return new DropdownButton(
      items: list1,
      hint: new Text(drop_value, textAlign: TextAlign.center),
      //当没有默认值的时候可以设置的提示
      value: drop_value,
      //下拉菜单选择完之后显示给用户的值
      onChanged: _drop_ActiveChanged,
      elevation: 20,
      underline: Container(),
      //设置阴影的高度
      style: new TextStyle(
          //设置文本框里面文字的样式
          color: Colors.black),
      isDense: false,
      iconSize: 20.0, //设置三角标icon的大小
    );
  }

  // 文本 地点 颜色 可以使用输入框
  // 图片则切换成上次图片按钮
  // 时间则换成日历时间选择器
  Widget Textinput() {
    return new TextField(
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入',
          contentPadding: const EdgeInsets.symmetric(vertical: 0.0)),
      textAlign: TextAlign.start,
      onChanged: _ActiveChanged,
      autofocus: false,
    );
  }

  Widget Text_image(){
    return new GestureDetector(
      child: Container(
        decoration: new UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.0, color: Colors.black),
            insets: EdgeInsets.fromLTRB(0,0,0,-2)
        ),
        child: Column(
          children: <Widget>[
            _previewImage()
          ],
        ),
      ),
    );
  }

  Widget _previewImage() {
    return new GestureDetector(
      onTap: _selectedImage,
      child: FutureBuilder<File>(
          future: imageFile,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              File file=snapshot.data;
              new Future(()=>_imagetobase64(file));
              return new Container(
                child: SizedBox(
                    width: 70.0,
                    height: 90.0,
                    child: Image.file(snapshot.data, fit: BoxFit.fill)
                ),
              );
            } else {
              return new Image.asset("images/2.2.x/addimage.png", height: 50.0, width: 50.0,color: Color(int.parse(color2)),);
            }
          }),
    );
  }
  void _selectedImage() {
    selectimage();
  }

  void _imagetobase64(File value) async{
    const androidplatform = const MethodChannel("test");
    String path=await androidplatform.invokeMethod("getFile",{"path":value.path});
    File file=new File(path);
    List bytes=await file.readAsBytes();
    base64_callback(base64Encode(bytes));
  }

  Widget Search_Text() {
    return new GestureDetector(
      onTap: _onclick_search,
      child: new Text(
        "搜索",
        style: TextStyle(
            color: Color(int.parse(color2)), fontSize: 16.0, fontWeight: FontWeight.w100),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    //写里面是为了取到上下文
    //2019-09-16 03:29:00.000
    Widget select_date(){
      return new GestureDetector(
        onTap:(){ //DateTimePickerWidget
          DatePicker.showDatePicker(context,
              showTitleActions: true, onChanged: (date) {
                print('change $date');
              }, onConfirm: (date){
                print('onConfirm $date');
                date_callback(date.toString().split(' ')[0]);
              }, currentTime: DateTime.now(), locale: LocaleType.zh);
        },
        child: Text(date_str==null||date_str==''?'日期':date_str,textAlign: TextAlign.center,),
      );
    }


    return Container(
      decoration: BoxDecoration(
        color: Color(int.parse(color1)),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
          children: <Widget>[
            Container(
                height: drop_value=='图片'?MediaQueryData.fromWindow(ui.window).size.height * 0.1:MediaQueryData.fromWindow(ui.window).size.height * 0.05,
                width: MediaQueryData.fromWindow(ui.window).size.width * 0.8,
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0, 0),
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Color(int.parse('0xfff1f1f1')),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: drop(),
                      flex: 1,
                    ),
                    Expanded(
                      child: drop_value=='图片'?Text_image():drop_value=='时间'?select_date():Textinput(),
                      flex: 4,
                    ),
                  ],
                )),
            Container(
              width: MediaQueryData.fromWindow(ui.window).size.width * 0.17,
              child: Search_Text(),
            )
          ],
        ),
      ),
    );
  }
}

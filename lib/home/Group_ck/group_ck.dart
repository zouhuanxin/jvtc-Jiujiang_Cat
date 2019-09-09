import 'dart:convert';
import 'dart:io';
import 'dart:convert';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/WebViewPage.dart';
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class group_ck extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => group_ck_State();
}

class group_ck_State extends State<group_ck> {
  String _studentid='', _name='';
  final _formKey = GlobalKey<FormState>();
  List<group> mblist = [];
  List<String> vislist = [];

//  loaddata() {
//    //目前就只有软件协会
//    group g1 = new group();
//    g1.association = '软件协会';
//    g1.projectname = '招新';
//    g1.groupnumber = '123456789';
//    mblist.add(g1);
//  }

  void _showmodel(mes, var type, var color) {
    Fluttertoast.showToast(
        msg: mes,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  //弹窗
  _shodialog(String title, String content) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text((content)),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("关闭"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _bmob_get_group_information() {
    BmobQuery<group> query = BmobQuery();
    query.addWhereNotEqualTo("imageurl", "12%%%3");
    query.queryObjects().then((data) {
      mblist.clear();
      mblist = data.map((i) => group.fromJson(i)).toList();
    }).catchError((e) {});
  }

  TextFormField buildStudentidTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '学号',
        fillColor: Colors.white,
        filled: dart_model,
      ),
      validator: (String value) {
//        if (value.isEmpty) {
//          return '请输入查询学号';
//        }
      },
      onSaved: (String value) => _studentid = value,
    );
  }

  TextFormField buildNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '名字',
        fillColor: Colors.white,
        filled: dart_model,
      ),
      validator: (String value) {
//        if (value.isEmpty) {
//          return '请输入查询名字';
//        }
      },
      onSaved: (String value) => _name = value,
    );
  }

  var showcon;
  Widget buildqueryButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '查询',
            style: TextStyle(color: Color(int.parse(color1))),
          ),
          color: Color(int.parse(color2)),
          onPressed: () {
            _formKey.currentState.validate();
            _formKey.currentState.save();
            if(_studentid!=''||_name!=''){
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (con) {
                    showcon=con;
                    return new LoadingDialog(
                      text: "查询中…",
                    );
                  });
              query();
            }else{
              _showmodel('请输入至少一个', Toast.LENGTH_SHORT, Colors.red);
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  query() async {
    vislist.clear();
    List<Map<String, dynamic>> templist = [];
    String res;
    if (_studentid != '') {
      res = await HttpUtil.query_collection_information(
          'getcollection_single', '%', '%', _studentid, '%');

      } else if (_name != '') {
        res = await HttpUtil.query_collection_information(
            'getcollection_single', '%', _name, '%', '%');
      }else{
        _showmodel('请输入至少一个', Toast.LENGTH_SHORT, Colors.red);
    }
      List<dynamic> list = json.decode(res);
      for (var i = 0; i < list.length; i++) {
        Map<String, dynamic> map = json.decode(json.encode(list[i]));
        templist.add(map);
      }
      for (var i = 0; i < templist.length; i++) {
        for (var j = 0; j < mblist.length; j++) {
          if (templist[i]['collection_association'] == mblist[j].association) {
            print('${templist[i]['collection_projectname']}');
            print('${mblist[j].projectname}');
            if (templist[i]['collection_projectname'] ==mblist[j].projectname) {
              vislist.add('欢迎加入' +
                  mblist[j].association +'  '+mblist[j].projectname+
                  '\n群号码:' +
                  mblist[j].groupnumber+'\n你的编号为:'+templist[i]['collection_id'].toString().split(' ')[1]+'\n');
            }
          }
        }
      }
      Navigator.pop(showcon);
      if (vislist.toString().length > 2) {
        _shodialog('欢迎加入九职协会',
            vislist.toString().substring(1, vislist.toString().length - 1));
      } else {
        _showmodel('暂无你的信息', Toast.LENGTH_SHORT, Colors.red);
      }
    }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '协会群号码                                       ',
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
          actions: <Widget>[new Container()],
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: buildStudentidTextField(),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: buildNameTextField(),
                ),
                SizedBox(
                  height: 30,
                ),
                buildqueryButton(context),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text('如上学号名字任意填写一个即可,如果俩个都填写我们则优选选择在学号作为查询条件。',style: TextStyle(color: Color(int.parse(color2))),),
                ),
              ],
            )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loaddata();
    _bmob_get_group_information();
  }
}

class group {
  String association;
  String projectname;
  String groupnumber;

  group({this.association, this.projectname, this.groupnumber});

  group.fromJson(Map<String, dynamic> json)
      : association = json['association'],
        projectname = json['projectname'],
        groupnumber = json['groupnumber'];

  Map<String, dynamic> toJson() => {
        'association': association,
        'projectname': projectname,
        'groupnumber': groupnumber,
      };
}

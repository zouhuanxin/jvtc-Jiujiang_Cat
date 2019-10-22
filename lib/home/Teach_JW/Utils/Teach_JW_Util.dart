
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/home/Teach_JW/View/teach_jw_login_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Teach_JW_Util{

  //周次选择
  List<DropdownMenuItem> getzcData() {
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem;
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('所有'),
      value: '',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第一周'),
      value: '1',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第二周'),
      value: '2',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第三周'),
      value: '3',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第四周'),
      value: '4',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第五周'),
      value: '5',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第六周'),
      value: '6',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第七周'),
      value: '7',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第八周'),
      value: '8',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第九周'),
      value: '9',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第十周'),
      value: '10',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第十一周'),
      value: '11',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第十二周'),
      value: '12',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第十三周'),
      value: '13',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第十四周'),
      value: '14',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第十五周'),
      value: '15',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第十六周'),
      value: '16',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第十七周'),
      value: '17',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第十八周'),
      value: '18',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第十九周'),
      value: '19',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第二十周'),
      value: '20',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第二十一周'),
      value: '21',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第二十二周'),
      value: '22',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第二十三周'),
      value: '23',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第二十四周'),
      value: '24',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第二十五周'),
      value: '25',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第二十六周'),
      value: '26',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第二十七周'),
      value: '27',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第二十八周'),
      value: '28',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第二十九周'),
      value: '29',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('第三十周'),
      value: '30',
    );
    items.add(dropdownMenuItem);
    return items;
  }

  //星期选择
  List<DropdownMenuItem> getxqData() {
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem;
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('所有'),
      value: '',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('星期一'),
      value: '1',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('星期二'),
      value: '2',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('星期三'),
      value: '3',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('星期四'),
      value: '4',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('星期五'),
      value: '5',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('星期六'),
      value: '6',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('星期天'),
      value: '7',
    );
    items.add(dropdownMenuItem);
    return items;
  }

  //节次选择
  List<DropdownMenuItem> getjcData() {
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem;
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('所有'),
      value: '',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('01'),
      value: '01',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('02'),
      value: '02',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('03'),
      value: '03',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('04'),
      value: '04',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('05'),
      value: '05',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('06'),
      value: '06',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('07'),
      value: '07',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('08'),
      value: '08',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('09'),
      value: '09',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('10'),
      value: '10',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('11'),
      value: '11',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('12'),
      value: '12',
    );
    items.add(dropdownMenuItem);
    return items;
  }


  //自动登陆方法
  static void auto_login() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    if(prefs.getString('teach_jwstudentid')==null||prefs.getString('teach_jwpassword')==null){
      return;
    }
    String jw_res=await HttpUtil.jwlogin('jwlogin', prefs.getString('teach_jwstudentid'), prefs.getString('teach_jwpassword'));
    Map<String, dynamic> jw_maptemp = json.decode(jw_res);
    print(jw_res);
    if(jw_maptemp['code'].toString().trim()=='0'){
      prefs.setString('jwcookie', jw_maptemp['cookie'].toString());
      Util.showTaost('自动登陆成功', Toast.LENGTH_SHORT, Colors.blue);
    }else{
      Util.showTaost('自动登陆失败', Toast.LENGTH_SHORT, Colors.red);
    }
  }

  //跳转方法
  static void jump(BuildContext context,object){
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => object));
  }

}
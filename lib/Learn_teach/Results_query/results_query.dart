import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_app01/Learn_teach/learn_teach.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter_app01/Bean/lunbo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';

class results_query extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => results_query_State();
}

class results_query_State extends State<results_query>{

  List<dynamic> results_data_list=[];
  Map<String,Object> results_data_map=null;

  List<DropdownMenuItem> getListData1(){
    List<DropdownMenuItem> items=new List();
    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
      child:new Text('2016-2017-1'),
      value: '2016-2017-1',
    );
    items.add(dropdownMenuItem1);
    DropdownMenuItem dropdownMenuItem2=new DropdownMenuItem(
      child:new Text('2016-2017-2'),
      value: '2016-2017-2',
    );
    items.add(dropdownMenuItem2);
    DropdownMenuItem dropdownMenuItem3=new DropdownMenuItem(
      child:new Text('2017-2018-1'),
      value: '2017-2018-1',
    );
    items.add(dropdownMenuItem3);
    DropdownMenuItem dropdownMenuItem4=new DropdownMenuItem(
      child:new Text('2017-2018-2'),
      value: '2017-2018-2',
    );
    items.add(dropdownMenuItem4);
    DropdownMenuItem dropdownMenuItem5=new DropdownMenuItem(
      child:new Text('2018-2019-1'),
      value: '2018-2019-1',
    );
    items.add(dropdownMenuItem5);
    DropdownMenuItem dropdownMenuItem6=new DropdownMenuItem(
      child:new Text('2018-2019-2'),
      value: '2018-2019-2',
    );
    items.add(dropdownMenuItem6);
    DropdownMenuItem dropdownMenuItem7=new DropdownMenuItem(
      child:new Text('2019-2020-1'),
      value: '2019-2020-1',
    );
    items.add(dropdownMenuItem7);
    DropdownMenuItem dropdownMenuItem8=new DropdownMenuItem(
      child:new Text('2019-2020-2'),
      value: '2019-2020-2',
    );
    items.add(dropdownMenuItem8);
    return items;
  }

  List<DropdownMenuItem> getListData2(){
    List<DropdownMenuItem> items=new List();
    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
      child:new Text('全部'),
      value: '',
    );
    items.add(dropdownMenuItem1);
    DropdownMenuItem dropdownMenuItem2=new DropdownMenuItem(
      child:new Text('公共课'),
      value: '01',
    );
    items.add(dropdownMenuItem2);
    DropdownMenuItem dropdownMenuItem3=new DropdownMenuItem(
      child:new Text('专业基础课'),
      value: '03',
    );
    items.add(dropdownMenuItem3);
    DropdownMenuItem dropdownMenuItem4=new DropdownMenuItem(
      child:new Text('专业课'),
      value: '04',
    );
    items.add(dropdownMenuItem4);
    DropdownMenuItem dropdownMenuItem5=new DropdownMenuItem(
      child:new Text('公共选修课'),
      value: '06',
    );
    items.add(dropdownMenuItem5);
    DropdownMenuItem dropdownMenuItem6=new DropdownMenuItem(
      child:new Text('其他'),
      value: '07',
    );
    items.add(dropdownMenuItem6);
    return items;
  }

  var value1=null,value2=null;

  Widget xl1(){
    return new DropdownButton(
      items: getListData1(),
      hint:new Text('开课时间',textAlign: TextAlign.center),//当没有默认值的时候可以设置的提示
      value: value1,//下拉菜单选择完之后显示给用户的值
      onChanged: (T){//下拉菜单item点击之后的回调
        setState(() {
          value1=T;
        });
      },
      elevation: 24,//设置阴影的高度
      style: new TextStyle(//设置文本框里面文字的样式
          color: Colors.grey
      ),
//              isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
      iconSize: 30.0,//设置三角标icon的大小
    );
  }

  Widget xl2(){
    return new DropdownButton(
      items: getListData2(),
      hint:new Text('课程性质',textAlign: TextAlign.center,),//当没有默认值的时候可以设置的提示
      value: value2,//下拉菜单选择完之后显示给用户的值
      onChanged: (T){//下拉菜单item点击之后的回调
        setState(() {
          value2=T;
        });
      },
      elevation: 24,//设置阴影的高度
      style: new TextStyle(//设置文本框里面文字的样式
          color: Colors.grey
      ),
//              isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
      iconSize: 30.0,//设置三角标icon的大小
    );
  }

  Widget table1(){
    return new Container(
      decoration: BoxDecoration(
        color: Color(int.parse(color4))
      ),
      margin: EdgeInsets.all(5.0),
      child: new Column(
        children: <Widget>[
          Text('成绩表',style: TextStyle(fontSize: 18),),
          SizedBox(height: 5,),
          Table(
            //表格边框样式
            border: TableBorder.all(
              color: Colors.black12,
              width: 2.0,
              style: BorderStyle.solid,
            ),
            children: TableRow_list_ui,
          ),
        ],
      ),
    );
  }

  List<TableRow>TableRow_list_ui=[];
  void _loading_TableRow(){
    TableRow_list_ui.clear();
    for(var i=0;i<results_data_list.length;i++){
      results_data_map=json.decode(json.encode(results_data_list[i]));
      TableRow_list_ui.add(TableRow(
          children: [
            Text(results_data_map==null?'':results_data_map['c1'],textAlign: TextAlign.center,),
            Text(results_data_map==null?'':results_data_map['c3'],textAlign: TextAlign.center,),
            Text(results_data_map==null?'':results_data_map['c4'],textAlign: TextAlign.center,),
            Text(results_data_map==null?'':results_data_map['c12'],textAlign: TextAlign.center,),
          ]
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('成绩查询                                       ',
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
        child: new ListView(
          children: <Widget>[
            new Row(
              children: <Widget>[
                Expanded(
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: xl1(),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: xl2(),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: new RaisedButton(onPressed: (){
                      if(value1!=null&&value2!=null){
                        _get_Academic_performance();
                      }else{
                        Fluttertoast.showToast(
                            msg: "请选择查询条件",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                    },color: Colors.blue,child: new Text('查询',style: TextStyle(color: Colors.white),),),
                  ),
                  flex: 2,
                ),
              ],
            ),
            table1()
          ],
        ),
      )
    );
  }

  var login_number=0;
  void _get_Academic_performance() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str1=await HttpUtil.jw_resluts_information('cjinfo', value1, value2, prefs.getString('jwcookie'));
    if(int.parse(json.decode(str1)['code'].toString())==0){
      //Successful request , token vaild
      String str2=json.encode(json.decode(str1)['data']).substring(1,json.encode(json.decode(str1)['data']).toString().length-1).replaceAll('\\', '');
      results_data_list=json.decode(str2);
    }else if(login_number<1){
      //Failed request , token invaild
      //Exit this screen and log in agein
      login_number=1;
      if(await HttpUtil.Automatic_landing()=='0'){
        _get_Academic_performance();
      }else{
        Navigator.pop(context);
      }
    }else{
      Navigator.pop(context);
    }
    //print(json.encode(results_data_list[0]));
    setState(() {
      _loading_TableRow();
    });
  }
  

}
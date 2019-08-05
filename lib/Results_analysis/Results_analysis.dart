import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Results_analysis extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Results_analysis_State();

}

class LinearClicks {
  final String coursename;
  final double course_result;

  LinearClicks(this.coursename, this.course_result);
}

class Results_analysis_State extends State<Results_analysis>{
  List<bool> offst=[false,true,true];
  List<charts.Series<LinearClicks, String>> data_list=[];
  List<charts.Series<LinearClicks, String>> data_list2=[];
  List<charts.Series<LinearClicks, String>> data_list3=[];

  List<charts.Series<LinearClicks, String>> _createSampleData() {
    final List<LinearClicks> myonelist=[];
    for(var i=0;i<course_list.length;i++){
      double sum1=0;
      for(var m=0;m<course_list[i].courseresults.length;m++){
        sum1=double.parse(course_list[i].courseresults[m].toString())+sum1;
      }
      myonelist.add(new LinearClicks(course_list[i].coursename, sum1));
    }

    return [
      new charts.Series<LinearClicks, String>(
          id: 'Fake Series',
          domainFn: (LinearClicks clickCount, _) => clickCount.coursename,
          measureFn: (LinearClicks clickCount, _) => clickCount.course_result,
          data: []),
      new charts.Series<LinearClicks, String>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearClicks clickCount, _) => clickCount.coursename,
        measureFn: (LinearClicks clickCount, _) => clickCount.course_result,
        data: myonelist,
        labelAccessorFn: (LinearClicks clickCount, _) =>'${clickCount.coursename}: \成绩${clickCount.course_result.toString()}'
      )
    ];
  }

  List<charts.Series<LinearClicks, String>> _createSampleData2() {
    final List<LinearClicks> myonelist=[];
    for(var i=0;i<course_list.length;i++){
      double sum1=0;
      for(var m=0;m<course_list[i].courseresults.length;m++){
        sum1=double.parse(course_list[i].courseresults[m].toString())+sum1;
      }
      myonelist.add(new LinearClicks(course_list[i].coursename, sum1));
    }

    return [
      new charts.Series<LinearClicks, String>(
          id: 'Fake Series',
          domainFn: (LinearClicks clickCount, _) => clickCount.coursename,
          measureFn: (LinearClicks clickCount, _) => clickCount.course_result,
          data: []),
      new charts.Series<LinearClicks, String>(
          id: 'Desktop',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (LinearClicks clickCount, _) => clickCount.coursename,
          measureFn: (LinearClicks clickCount, _) => clickCount.course_result,
          data: myonelist,
      )
      ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }

  List<charts.Series<LinearClicks, String>> _createSampleData3() {
    final List<LinearClicks> myonelist=[];
    for(var i=0;i<course_list.length;i++){
      double sum1=0;
      for(var m=0;m<course_list[i].coursercredits.length;m++){
        sum1=double.parse(course_list[i].coursercredits[m].toString())+sum1;
      }
      myonelist.add(new LinearClicks(course_list[i].coursename, sum1));
    }

    return [
      new charts.Series<LinearClicks, String>(
          id: 'Fake Series',
          domainFn: (LinearClicks clickCount, _) => clickCount.coursename,
          measureFn: (LinearClicks clickCount, _) => clickCount.course_result,
          data: []),
      new charts.Series<LinearClicks, String>(
          id: 'Desktop',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (LinearClicks clickCount, _) => clickCount.coursename,
          measureFn: (LinearClicks clickCount, _) => clickCount.course_result,
          data: myonelist,
          labelAccessorFn: (LinearClicks clickCount, _) =>'${clickCount.coursename}: \学分${clickCount.course_result.toString()}'
      )
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _get_Academic_performance();
  }

  Widget top_choose(){
    return new Container(
      decoration: BoxDecoration(
          color: Color(int.parse(color1))
      ),
      child: new Row(
        children: <Widget>[
          Expanded(
            child: new GestureDetector(
              onTap:(){
                setState(() {
                  for(var i=0;i<offst.length;i++){
                    offst[i]=true;
                  }
                  offst[0]=false;
                });
              },
              child: new Text('总成绩统计图1',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
            ),
            flex: 1,
          ),
          Expanded(
            child: new GestureDetector(
              onTap:(){
                setState(() {
                  for(var i=0;i<offst.length;i++){
                    offst[i]=true;
                  }
                  offst[1]=false;
                });
              },
              child: new Text('总成绩统计图2',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
            ),
            flex: 1,
          ),
          Expanded(
            child: new GestureDetector(
              onTap:(){
                setState(() {
                  for(var i=0;i<offst.length;i++){
                    offst[i]=true;
                  }
                  offst[2]=false;
                });
              },
              child: new Text('学分统计图',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('成绩分析                                       ',
          textAlign:TextAlign.left,style: TextStyle(color:  Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(int.parse(color2))),
        backgroundColor: Color(int.parse(color1)),
        centerTitle: true,
      ),
      body: new Container(
        decoration: BoxDecoration(
            color: Color(int.parse(color1))
        ),
    child: new ListView(
      children: <Widget>[
        top_choose(),
        new Offstage(
            offstage: offst[0], //这里控制
            child:  new Container(
              decoration: BoxDecoration(
                  color: Color(int.parse(color1))
              ),
              height:700,
              child: charts.BarChart(data_list,
                animate: true,  vertical: false,
                barRendererDecorator: new charts.BarLabelDecorator<String>(),
                domainAxis:
                new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),),
            )
        ),
        new Offstage(
          offstage: offst[1], //这里控制
          child:  new Container(
            height: 300,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                new Container(
                  decoration: BoxDecoration(
                      color: Color(int.parse(color1))
                  ),
                  width: double.parse('${course_list.length*100}'),
                  child: charts.OrdinalComboChart(data_list2,
                      animate: true,
                      defaultRenderer: new charts.BarRendererConfig(
                          groupingType: charts.BarGroupingType.grouped),
                      customSeriesRenderers: [
                        new charts.LineRendererConfig(
                            customRendererId: 'customLine')
                      ]),
                )
              ],
            ),
          ),
        ),
        new Offstage(
            offstage: offst[2], //这里控制
            child:  new Container(
              decoration: BoxDecoration(
                  color: Color(int.parse(color1))
              ),
              height:700,
              child: charts.BarChart(data_list3,
                animate: true,  vertical: false,
                barRendererDecorator: new charts.BarLabelDecorator<String>(),
                domainAxis:
                new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),),
            )
        ),
      ],
    ),
      ),
    );
  }

  List<dynamic>results_data_list=[];
  var login_number=0;
  void _get_Academic_performance() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str1=await HttpUtil.jw_resluts_information('cjinfo', '', '', prefs.getString('jwcookie'));
    if(int.parse(json.decode(str1)['code'].toString())==0){
      //Successful request , token vaild
      String str2=json.encode(json.decode(str1)['data']).substring(1,json.encode(json.decode(str1)['data']).toString().length-1).replaceAll('\\', '');
      results_data_list=json.decode(str2);
      _loading_course_data();
    }else if(login_number<1){
      //Failed request , token invaild
      //Exit this screen and log in agein
      login_number=1;
      if(await HttpUtil.Automatic_landing()=='0'){
        _get_Academic_performance();
      }else{

      }
    }else{
      Navigator.pop(context);
    }
  }

  List<Course_bean01>course_list=[];
  RegExp exp = RegExp(
      r'^(-?[1-9]\d*(\.\d*[1-9])?)|(-?0\.\d*[1-9])$');
  void _loading_course_data(){
    for(var i=1;i<results_data_list.length;i++){
      Map<String,Object>tempmap=results_data_list[i];
      if(course_list.length==0){
        if(exp.hasMatch(tempmap['c4'].toString().trim())==true&&tempmap!=null){
          List<double>templistresults=[];
          List<String>templistdate=[];
          List<double>templistcredits=[];
          templistresults.add(tempmap['c4']==''?0:double.parse(tempmap['c4'].toString().trim()));
          templistdate.add(tempmap['c1']==''?'0':tempmap['c1'].toString().trim());
          templistcredits.add(tempmap['c6']==''?0:double.parse(tempmap['c6'].toString().trim()));
          Course_bean01 course_bean01=new Course_bean01(tempmap['c3'], templistresults,templistdate,templistcredits);
          course_list.add(course_bean01);
        }
      }else{
        for(var j=0;j<course_list.length;j++){
          if(_check_repeat_coursename(course_list, tempmap['c3'])==false){
            if(exp.hasMatch(tempmap['c4'].toString().trim())==true&&tempmap!=null){
              List<double>templistresults=[];
              List<String>templistdate=[];
              List<double>templistcredits=[];
              templistresults.add(tempmap['c4']==''?0:double.parse(tempmap['c4'].toString().trim()));
              templistdate.add(tempmap['c1']==''?'0':tempmap['c1'].toString().trim());
              templistcredits.add(tempmap['c6']==''?0:double.parse(tempmap['c6'].toString().trim()));
              Course_bean01 course_bean01=new Course_bean01(tempmap['c3'], templistresults,templistdate,templistcredits);
              course_list.add(course_bean01);
            }
          }else if(_check_repeat_coursename(course_list, tempmap['c3'])==true&&_check_repeat_coursedate(course_list[j].courserdate, tempmap['c1'])==false
          &&course_list[j].coursename==tempmap['c3']){
            if(exp.hasMatch(tempmap['c4'].toString().trim())==true&&tempmap!=null){
              course_list[j].courseresults.add(tempmap['c4']==''?0:double.parse(tempmap['c4'].toString().trim()));
              course_list[j].courserdate.add(tempmap['c1']==''?0:tempmap['c1'].toString().trim());
            }
          }
        }
      }
    }
    setState(() {
      data_list=_createSampleData();
      data_list2=_createSampleData2();
      data_list3=_createSampleData3();
    });
  }

  _check_repeat_coursename(List<Course_bean01> list,String str){
    bool iss=false;
    for(var i=0;i<list.length;i++){
      if(list[i].coursename==str){
        iss=true;
      }
    }
    return iss;
  }

  _check_repeat_coursedate(List<String> list,String str){
    bool iss=false;
    for(var i=0;i<list.length;i++){
      if(list[i]==str){
        iss=true;
      }
    }
    return iss;
  }

}

class Course_bean01{
  final String coursename;
  final List<double> courseresults;
  final List<String> courserdate;
  final List<double> coursercredits;

  Course_bean01(this.coursename,this.courseresults,this.courserdate,this.coursercredits);
}

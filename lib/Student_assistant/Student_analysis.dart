import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/learn_assistant.dart';
import 'package:flutter_app01/Bean/learn_assistant03.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Student_analysis extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Student_analysis_State();

}

class Student_analysis_State extends State<Student_analysis>{
  List<bool> offst=[false,true,true];
  List<charts.Series<Learn_bean01, String>> data_list=[];
  List<charts.Series<Learn_bean01, String>> data_list2=[];
  List<charts.Series<Learn_bean01, String>> data_list3=[];
  List<learn_assistant>learn_list=[];
  double linechart1_width=0;

  List<charts.Series<Learn_bean01, String>> _createSampleData() {
    final List<Learn_bean01> myonelist=[];
    for(var i=0;i<learn_list.length;i++){
      List<learn_assistant03>templist03=[];
      List<dynamic>list=json.decode(json.encode(learn_list[i].learn02))['learn03_list'];
      linechart1_width=double.parse('${list.length*200}');
      for(var n=0;n<list.length;n++){
        learn_assistant03 la03=new learn_assistant03();
        la03.starttime=json.decode(json.encode(list[n]))['starttime'];
        la03.endtime=json.decode(json.encode(list[n]))['endtime'];
        la03.sum=json.decode(json.encode(list[n]))['sum'];
        templist03.add(la03);
        myonelist.add(new Learn_bean01(la03.starttime.toString().split(' ')[1].substring(0,5), 0.0));
        myonelist.add(new Learn_bean01(la03.starttime.toString().split(' ')[1].substring(0,5), double.parse(la03.sum)));
        myonelist.add(new Learn_bean01('${la03.sum}分钟', double.parse(la03.sum)));
        myonelist.add(new Learn_bean01(la03.endtime.toString().split(' ')[1].substring(0,5), double.parse(la03.sum)));
        myonelist.add(new Learn_bean01(la03.endtime.toString().split(' ')[1].substring(0,5), 0.0));
      }
    }

    return [
      new charts.Series<Learn_bean01, String>(
          id: 'Fake Series',
          domainFn: (Learn_bean01 clickCount, _) => clickCount.learndate,
          measureFn: (Learn_bean01 clickCount, _) => clickCount.lerannumber,
          data: []),
      new charts.Series<Learn_bean01, String>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Learn_bean01 clickCount, _) => clickCount.learndate,
        measureFn: (Learn_bean01 clickCount, _) => clickCount.lerannumber,
        data: myonelist,
      )
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }

  List<charts.Series<Learn_bean01, String>> _createSampleData2() {
    final List<Learn_bean01> myonelist=[];
    for(var i=0;i<learn_list.length;i++){
      List<learn_assistant03>templist03=[];
      List<dynamic>list=json.decode(json.encode(learn_list[i].learn02))['learn03_list'];
      for(var n=0;n<list.length;n++){
        learn_assistant03 la03=new learn_assistant03();
        la03.starttime=json.decode(json.encode(list[n]))['starttime'];
        la03.endtime=json.decode(json.encode(list[n]))['endtime'];
        la03.sum=json.decode(json.encode(list[n]))['sum'];
        templist03.add(la03);
        myonelist.add(new Learn_bean01(
            la03.starttime.toString().split(' ')[1].substring(0,5)+'-'+la03.endtime.toString().split(' ')[1].substring(0,5),
            double.parse(la03.sum)));
      }
    }

    return [
      new charts.Series<Learn_bean01, String>(
          id: 'Fake Series',
          domainFn: (Learn_bean01 clickCount, _) => clickCount.learndate,
          measureFn: (Learn_bean01 clickCount, _) => clickCount.lerannumber,
          data: []),
      new charts.Series<Learn_bean01, String>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Learn_bean01 clickCount, _) => clickCount.learndate,
        measureFn: (Learn_bean01 clickCount, _) => clickCount.lerannumber,
        data: myonelist,
        labelAccessorFn: (Learn_bean01 clickCount, _) =>'${clickCount.learndate}: \时长${clickCount.lerannumber.toString()}',
      )
    ];
  }

  List<charts.Series<Learn_bean01, String>> _createSampleData3() {
    final List<Learn_bean01> myonelist=[];
    myonelist.add(new Learn_bean01('睡觉时间',540));
    myonelist.add(new Learn_bean01('必备生活时间',300));
    myonelist.add(new Learn_bean01('学习时间',sum_minutes));
    myonelist.add(new Learn_bean01('剩余时间',600-sum_minutes));

    return [
      new charts.Series<Learn_bean01, String>(
        id: 'Sales',
        domainFn: (Learn_bean01 sales, _) => sales.learndate,
        measureFn: (Learn_bean01 sales, _) => sales.lerannumber,
        data: myonelist,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (Learn_bean01 row, _) => '${row.learndate}: ${row.lerannumber}分钟',
      )
    ];
  }
  
  double sum_minutes=0;
  void _judge_Res(){
    for(var i=0;i<learn_list.length;i++){
      List<dynamic>list=json.decode(json.encode(learn_list[i].learn02))['learn03_list'];
      for(var n=0;n<list.length;n++){
        learn_assistant03 la03=new learn_assistant03();
        la03.starttime=json.decode(json.encode(list[n]))['starttime'];
        la03.endtime=json.decode(json.encode(list[n]))['endtime'];
        la03.sum=json.decode(json.encode(list[n]))['sum'];
        sum_minutes=sum_minutes+double.parse(la03.sum);
      }
    }
  }

  Widget rescomponent(){
    return new Container(
      margin: EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          SizedBox(height: 10,),
          new Text(DateTime.now().toString().split(' ')[0]+'日报告',style: TextStyle(color: Color(int.parse(color2)),fontSize: 30)),
          SizedBox(height: 30,),
          new Text('正常人睡觉为9小时540分钟那么你不睡觉的时间有900分钟15个小时,休息时间300分钟5小时,还剩600分钟10小时自由安排时间。',style: TextStyle(color: Color(int.parse(color2)),fontSize: 15)),
          new Text('你花了$sum_minutes分钟时间学习',style: TextStyle(color: Color(int.parse(color2)),fontSize: 20)),
          SizedBox(height: 20,),
          new Text('如果你不放假，系统参考结果如下:',style: TextStyle(color: Color(int.parse(color2)),fontSize: 15)),
          new Text(sum_minutes<30?'过少':(sum_minutes<60?'养生时间':(sum_minutes<90?'达标':(sum_minutes<120?'good':'very good'))),style: TextStyle(color: Color(int.parse(color2)),fontSize: 20)),
          SizedBox(height: 20,),
          new Text('如果你放假，系统参考结果如下:',style: TextStyle(color: Color(int.parse(color2)),fontSize: 15)),
          new Text(sum_minutes<60?'过少':(sum_minutes<120?'养生时间':(sum_minutes<180?'一般':
          (sum_minutes<240?'达标':(sum_minutes<360?'good':'正常工作时间是八小时你很接近')))),style: TextStyle(color: Color(int.parse(color2)),fontSize: 20)),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _query_all();
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
              child: new Text('分析图1',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
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
              child: new Text('分析图2',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
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
              child: new Text('分析图3',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
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
        title: new Text('学习报表                                       ',
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
          child:  new Column(
            children: <Widget>[
              new Container(
                height:200,
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    new Container(
                      decoration: BoxDecoration(
                          color: Color(int.parse(color1))
                      ),
                      height:200,
                      width: linechart1_width,
                      child: charts.OrdinalComboChart(data_list,
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
              rescomponent()
            ],
          )
        ),
        new Offstage(
            offstage: offst[1], //这里控制
            child:  new Column(
              children: <Widget>[
                new Container(
                  decoration: BoxDecoration(
                      color: Color(int.parse(color1))
                  ),
                  height:200,
                  child: charts.BarChart(data_list2,
                      animate: true,vertical: false,
                    barRendererDecorator: new charts.BarLabelDecorator<String>(),
                    domainAxis:
                    new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),),
                ),
                rescomponent()
              ],
            )
        ),
        new Offstage(
            offstage: offst[2], //这里控制
            child:  new Column(
              children: <Widget>[
                new Container(
                  decoration: BoxDecoration(
                      color: Color(int.parse(color1))
                  ),
                  height:200,
                  child: new charts.PieChart(data_list3,
                      animate: true,
                      defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.outside)
                      ])),
                ),
                rescomponent(),
                SizedBox(height: 30,),
              ],
            )
        ),
      ],
    ),
      ),
    );
  }

  void _query_all(){
    if(login_state==true){
      String str=DateTime.now().toString().split(' ')[0].toString().trim();
      BmobQuery<learn_assistant> query = BmobQuery();
      query.addWhereEqualTo("time_phone", '$str\and$phone');
      query.queryObjects().then((data) {
        learn_list = data.map((i) => learn_assistant.fromJson(i)).toList();
        setState(() {
          _judge_Res();
          data_list=_createSampleData();
          data_list2=_createSampleData2();
          data_list3=_createSampleData3();
        });
      }).catchError((e) {
        print(BmobError.convert(e).error);
        Toastmodel(BmobError.convert(e).error, Colors.red);
      });
    }else{
      Toastmodel('请先登陆', Colors.red);
      Navigator.pop(context);
    }
  }

  void Toastmodel(str,color){
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}

class Learn_bean01{
  final String learndate;
  final double lerannumber;

  Learn_bean01(this.learndate,this.lerannumber);
}

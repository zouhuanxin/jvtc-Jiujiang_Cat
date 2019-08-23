import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';

import 'course.dart';

//第二版本课表ui设计
Widget buildButtonColumn_ui2(String label, color, int index,int xia,String date) {
  var today=DateTime.parse(date);
//  print('today:${today.weekday.toString()}');
  //print(json.decode(json.encode(json.decode(course_class_time)[int.parse((8/8).toString().split('.')[0])]))['time']);
  return new GestureDetector(
    onTap: () {
      if(label!=''){
        CoursePageState cp = new CoursePageState();
        cp.course_click(index);
      }
    },
    child: new Column(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            color: label == '' ? Color(int.parse(color1)) : color,
            borderRadius: new BorderRadius.all(new Radius.circular(index < 8 ||
                index == 8 ||
                index == 16 ||
                index == 24 ||
                index == 32 ||
                index == 40 ||
                index == 48
                ? 0
                : 2.0)),
          ),
          height:index < 8 ||
              index == 8 ||
              index == 16 ||
              index == 24 ||
              index == 32 ||
              index == 40 ||
              index == 48
              ? index < 8 ?55:90
              : 86,
          width: index < 8 ||
              index == 8 ||
              index == 16 ||
              index == 24 ||
              index == 32 ||
              index == 40 ||
              index == 48
              ? index==xia||index==xia+8||index==xia+2*8||index==xia+3*8||index==xia+4*8||index==xia+5*8||index==xia+6*8?80:50
              : index==xia||index==xia+8||index==xia+2*8||index==xia+3*8||index==xia+4*8||index==xia+5*8||index==xia+6*8?76:46,
          padding: const EdgeInsets.all(5.0),
          margin: index < 8 ||
              index == 8 ||
              index == 16 ||
              index == 24 ||
              index == 32 ||
              index == 40 ||
              index == 48
              ? const EdgeInsets.all(0.0)
              : const EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0),
          alignment: Alignment.center,
          child: Text(
            index<8&&index>0
                ?(index==int.parse(today.weekday.toString())?label+'\n'+date.substring(5,date.length):
            index<int.parse(today.weekday.toString())?label+'\n'+'${today.subtract(new Duration(days: 4-index)).toString().substring(5,10)}':
            label+'\n'+'${today.add(new Duration(days: index-4)).toString().substring(5,10)}')
                :(index == 8 ||
                index == 16 ||
                index == 24 ||
                index == 32 ||
                index == 40 ||
                index == 48?label+'\n'+json.decode(json.encode(json.decode(course_class_time)[int.parse((index/8).toString().split('.')[0])-1]))['time']:label),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
            style: new TextStyle(
              fontSize: index==xia?14.0:8.5,
              fontWeight: FontWeight.w400,
              color: index==xia?Colors.greenAccent:Color(int.parse(color2)),
            ),
          ),
        ),
        Container(
          height: index==xia?2:0,
          width: index==xia?50:0,
          color: Colors.greenAccent,
        )
      ],
    ),
  );
}

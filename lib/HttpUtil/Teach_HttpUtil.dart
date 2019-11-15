import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Teach_HttpUtil{
  static final host = 'http://dyzuis.cn:8080';
  static final baseUrl = host + '/test/';

  static Future<String> teach_teach_info(url,cookie) async {
    String dataURL = baseUrl+url;
    var temp={'cookie': cookie};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  static Future<String> teacher_info(url,token) async {
    String dataURL = 'http://api.ncgame.cc/jvtc/teacher_info';
    var headmap={'Authorization':'Bearer ' + token};
    http.Response response = await http.get(dataURL,headers: headmap);
    return response.body.toString();
  }

  static Future<String> TeacherReSetpass(url,token,studentid) async {
    String dataURL = 'http://api.ncgame.cc/jvtc/TeacherReSetpass?StudentNo='+studentid;
    var headmap={'Authorization':'Bearer ' + token};
    http.Response response = await http.get(dataURL,headers: headmap);
    return response.body.toString();
  }

  static Future<String> FDYAllLeaveExam(url,token,TermNo,Status) async {
    String dataURL = 'http://api.ncgame.cc/jvtc/FDYAllLeaveExam';
    var headmap={'Authorization':'Bearer ' + token,'Content-Type':'application/json'};
    var temp='{"TermNo": "'+TermNo+'","ClassNo": "","StudentNo": "","StudentName": "","Status": "'+Status+'"}';
    http.Response response = await http.post(dataURL,headers: headmap,body: temp);
    return response.body.toString();
  }

  static Future<String> FDYAllLeaveExam_Edit(url,token,id,type) async {
    String dataURL = 'http://api.ncgame.cc/jvtc/FDYAllLeaveExam_Edit?id='+id+'&type='+type.toString();
    var headmap={'Authorization':'Bearer ' + token};
    http.Response response = await http.get(dataURL,headers: headmap);
    return response.body.toString();
  }

  static Future<String> FDYDisAllLeave(url,token,TermNo) async {
    String dataURL = 'http://api.ncgame.cc/jvtc/FDYDisAllLeave';
    var headmap={'Authorization':'Bearer ' + token,'Content-Type':'application/json'};
    var temp='{"TermNo": "'+TermNo+'","ClassNo": "","StudentNo": "","StudentName": "","LeaveType":""}';
    http.Response response = await http.post(dataURL,headers: headmap,body: temp);
    return response.body.toString();
  }

  static Future<String> FDYDisAllLeave2(url,token,ids) async {
    String dataURL = 'http://api.ncgame.cc/jvtc/FDYDisAllLeave';
    var headmap={'Authorization':'Bearer ' + token,'Content-Type':'application/json'};
    var temp='{"TermNo": "","ClassNo": "","StudentNo": "","StudentName": "","LeaveType":"","ids":["'+ids+'"]}';
    http.Response response = await http.post(dataURL,headers: headmap,body: temp);
    return response.body.toString();
  }

  static Future<String> teach_teachcourse_info(url,cookie,xnxqh,skyx,skjs,zc1,zc2,skxq1,skxq2,jc1,jc2) async {
    String dataURL = baseUrl+url;
    var temp='{"xnxqh":"'+xnxqh+'","skyx":"'+skyx+'","skjs":"'+skjs+'","zc1":"'+zc1+'","zc2":"'+zc2+'","skxq1":"'+skxq1+'","skxq2":"'+skxq2+'","jc1":"'+jc1+'","jc2":"'+jc2+'","cookie":"'+cookie+'"}';
    http.Response response = await http.post(dataURL,body: temp);
    return response.body.toString();
  }

  static Future<String> teach_classcourse_info(url,cookie,xnxqh,skyx,xqid,jzwid,skjs,zc1,zc2,skxq1,skxq2,jc1,jc2) async {
    String dataURL = baseUrl+url;
    var temp='{"xnxqh":"'+xnxqh+'","skyx":"'+skyx+'","xqid":"'+xqid+'","jzwid":"'+jzwid+'","skjs":"'+skjs+'","zc1":"'+zc1+'","zc2":"'+zc2+'","skxq1":"'+skxq1+'","skxq2":"'+skxq2+'","jc1":"'+jc1+'","jc2":"'+jc2+'","cookie":"'+cookie+'"}';
    http.Response response = await http.post(dataURL,body: temp);
    return response.body.toString();
  }

  static Future<String> teach_hmc_info(url,cookie,jx0404id) async {
    String dataURL = baseUrl+url;
    var temp='{"cookie":"'+cookie+'","jx0404id":"'+jx0404id+'"}';
    http.Response response = await http.post(dataURL,body: temp);
    return response.body.toString();
  }

  static Future<String> jw_uploadpas(url,cookie,oldpassword,password1,password2) async {
    String dataURL = baseUrl+url;
    var temp='{"cookie":"'+cookie+'","oldpassword":"'+oldpassword+'","password1":"'+password1+'","password2":"'+password2+'"}';
    http.Response response = await http.post(dataURL,body: temp);
    return response.body.toString();
  }

  static Future<String> xg_uploadpas(url,token,OldPass,NewPass,NewPassAgin) async {
    String dataURL = 'http://api.ncgame.cc/jvtc/TeacherChangePass';
    var temp='{"OldPass":"'+OldPass+'","NewPass":"'+NewPass+'","NewPassAgin":"'+NewPassAgin+'"}';
    var headmap={'Authorization':'Bearer ' + token,'Content-Type':'application/json'};
    http.Response response = await http.post(dataURL,body: temp,headers: headmap);
    return response.body.toString();
  }
}
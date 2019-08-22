import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class HttpUtil {
  static String token;

  //Learn platform Server address
  static final learn_host = 'http://47.94.255.154:8080';
  static final learn_baseUrl = learn_host + '/test/';

  //node Server //192.168.0.105
  static final node_host = 'http://47.94.255.154:3000';
  static final node_baseUrl = node_host + '/rjxhmange/collection/';

  //Teach platform Server address
  static final teach_host = 'http://api.ncgame.cc';
  static final teach_baseUrl = teach_host + '/jvtc/';

  //Educational administration stystem login interface
   static Future<String> jwlogin(url,jwstudeng_id,jw_password) async {
     String dataURL = learn_baseUrl+url;
     var temp={'jwusername': jwstudeng_id, 'jwpassword': jw_password};
     http.Response response = await http.post(dataURL,body: json.encode(temp));;
     return response.body.toString();
   }

   //Academic performance enquiry
  static Future<String> jw_resluts_information(url,kksj,kcxz,jwcookie) async {
    String dataURL = learn_baseUrl+url;
    var temp={'kksj': kksj, 'kcxz': kcxz,'kcmc': '','xsfs': 'all','cookie': jwcookie};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  static Future<String> image_text_sb(url,client_id,client_secret,image) async {
    String dataURL = learn_baseUrl+url;
    var temp={'client_id': client_id, 'client_secret': client_secret,'image': image};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  //Student platform login interface
  static Future<String> xglogin(url,xgstudeng_id,xg_password) async {
    String dataURL = teach_baseUrl+url;
    var temp={'loginName': xgstudeng_id, 'loginPwd': xg_password};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  //Student platform  personal info
  static Future<String> xg_query_personal_info(url,token) async {
    String dataURL = teach_baseUrl+url;
    var headmap={'Authorization':'Bearer ' + token};
    http.Response response = await http.get(dataURL,headers:headmap);
    return response.body.toString();
  }

  //Activity in the query and evaluation
  static Future<String> xg_query_activity_info(url,token) async {
    String dataURL = teach_baseUrl+url;
    var headmap={'Authorization':'Bearer ' + token};
    http.Response response = await http.get(dataURL,headers:headmap);
    return response.body.toString();
  }

  //Activity in the evaluation
  static Future<String> xg_query_activity_evaluation(url,id,token) async {
    String dataURL = teach_baseUrl+url;
    var headmap={'Authorization':'Bearer ' + token};
    var temp='[{"id":' + id + '}]';
    http.Response response = await http.post(dataURL,headers:headmap,body: id);
    return response.body.toString();
  }

  //Search for individual activity score information
  static Future<String> xg_query_activity_score_info(url,token) async {
    String dataURL = teach_baseUrl+url;
    var headmap={'Authorization':'Bearer ' + token};
    http.Response response = await http.get(dataURL,headers:headmap);
    return response.body.toString();
  }

  //course queries interface
  static Future<String> query_course(url,cookie,date) async {
    String dataURL = learn_baseUrl+url;
    var temp={'cookie': cookie,'rq':date};
    //print(json.encode(temp));
    http.Response response = await http.post(dataURL,body: json.encode(temp));
    return response.body.toString();
  }

  //online translation interface
  static Future<String> online_translation(String str) async{
     http.Response response = await http.get('http://fanyi.youdao.com/translate?&doctype=json&type=AUTO&i='+str);
     String res=response.body.toString().split('tgt')[1];
     return res.substring(3,res.length).split('"')[0];
  }

  //Automatic landing
  static Future<String> Automatic_landing() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jw_res=await HttpUtil.jwlogin('jwlogin', prefs.getString('learn_teach_student_id'), prefs.getString('teach_password'));
    String xg_res=await HttpUtil.xglogin('login', prefs.getString('learn_teach_student_id'), prefs.getString('learn_password'));
    Map<String, dynamic> jw_maptemp = json.decode(jw_res);
    Map<String, dynamic> xg_maptemp = json.decode(xg_res);
    if(jw_maptemp['code'].toString().trim()=='0'&&xg_maptemp['code'].toString().trim()=='0'){
      prefs.setString('jwcookie', jw_maptemp['cookie'].toString());
      prefs.setString('xgtoken', xg_maptemp['token'].toString());
      Fluttertoast.showToast(
          msg: "自动登陆成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return '0';
    }else{
      Fluttertoast.showToast(
          msg: "自动登陆失败,请重新登陆",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return '-1';
    }
  }

  //library model api
  static Future<String> library_login(url,number,passwd,captcha,cookie) async {
    String dataURL = learn_baseUrl+url;
    var temp={'number': number, 'passwd': passwd,'captcha': captcha,'cookie': cookie};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  static Future<String> library_book_query(url,strText,strSearchType,page) async {
    String dataURL = learn_baseUrl+url;
    var temp={'strText': strText, 'strSearchType': strSearchType,'page': page,'onlylendable': 'no'};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  static Future<String> library_book_history_query(url,cookie) async {
    String dataURL = learn_baseUrl+url;
    var temp={'para_string': 'all', 'cookie': cookie};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  static Future<String> now_library_book_query(url,cookie) async {
    String dataURL = learn_baseUrl+url;
    var temp={'cookie': cookie};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  static Future<String> renew_book_query(url,bar_code,check,captcha,cookie) async {
    String dataURL = learn_baseUrl+url;
    var temp={'bar_code': bar_code,'check': check,'captcha': captcha,'cookie': cookie};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  static Future<String> library_accounts_query(url,cookie) async {
    String dataURL = learn_baseUrl+url;
    var temp={'cookie': cookie};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  static Future<String> cancel_booking(url,call_no,marc_no,loca,cookie) async {
    String dataURL = learn_baseUrl+url;
    var temp={'call_no':call_no,'marc_no':marc_no,'loca':loca,'time':'','cookie': cookie};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  static Future<String> library_person_information(url,cookie) async {
    String dataURL = learn_baseUrl+url;
    var temp={'cookie': cookie};
    http.Response response = await http.post(dataURL,body: json.encode(temp));;
    return response.body.toString();
  }

  static Future<String> add_collection_information(url,collection_image,collection_name,collection_association,collection_studentid,collection_projectname,collection_time) async {
    String dataURL = node_baseUrl+url;
    var temp={'collection_image': collection_image,'collection_name': collection_name,'collection_association': collection_association,'collection_studentid': collection_studentid,'collection_projectname': collection_projectname,'collection_time': collection_time};
    http.Response response = await http.post(dataURL,body: temp);;
    return response.body.toString();
  }

}
import 'dart:convert';

import 'package:http/http.dart' as http;

class Lose_HttpUtil {
  static String token;

  //node Server //192.168.0.104
  static final node_host = 'http://47.94.255.154:3000';
  static final node_baseUrl = node_host + '/rjxhmange/';

  //losea表增删改查
  static Future<String> add_losea(url,image,introduce,address,time,reward_money,userphone) async {
    String dataURL = node_baseUrl+url;
    var temp={'image': image,'introduce': introduce,'address': address,'time': time,'reward_money': reward_money,'userphone': userphone};
    http.Response response = await http.post(dataURL,body: temp);;
    return response.body.toString();
  }

  static Future<String> get_losea(url,currentPage,linesize) async {
    String dataURL = node_baseUrl+url;
    http.Response response = await http.get(dataURL+'?currentPage='+currentPage.toString()+'&linesize='+linesize.toString());
    return response.body.toString();
  }

  static Future<String> delect_losea(url,id) async {
    String dataURL = node_baseUrl+url;
    http.Response response = await http.get(dataURL+'?id='+id);
    return response.body.toString();
  }

  static Future<String> upload_losea(url,image,introduce,address,time,reward_money,id) async {
    String dataURL = node_baseUrl+url;
    var temp={'image': image,'introduce': introduce,'address': address,'time': time,'reward_money': reward_money,'id': id};
    http.Response response = await http.post(dataURL,body: temp);;
    return response.body.toString();
  }

  //losetype表改
  static Future<String> get_losetype(url) async {
    String dataURL = node_baseUrl+url;
    http.Response response = await http.get(dataURL);
    return response.body.toString();
  }

  //loseb表增删改查
  static Future<String> add_loseb(url,image,introduce,address,time,type,tz,wz,tp,userphone) async {
    String dataURL = node_baseUrl+url;
    var temp={'image': image,'introduce': introduce,'address': address,'time': time,'type': type,'tz':tz,'wz':wz,'tp':tp,'userphone':userphone};
    http.Response response = await http.post(dataURL,body: temp);;
    return response.body.toString();
  }

  static Future<String> get_loseb(url,currentPage,linesize) async {
    String dataURL = node_baseUrl+url;
    http.Response response = await http.get(dataURL+'?currentPage='+currentPage.toString()+'&linesize='+linesize.toString());
    return response.body.toString();
  }

  static Future<String> get_loseb2(url,introduce,tz,wz,currentPage,linesize) async {
    String dataURL = node_baseUrl+url;
    http.Response response = await http.get(dataURL+'?currentPage='+currentPage.toString()+'&linesize='+linesize.toString()+'&introduce='+introduce.toString()+'&tz='+tz.toString()+'&wz='+wz.toString());
    return response.body.toString();
  }

  static Future<String> get_loseb3(url,address,currentPage,linesize) async {
    String dataURL = node_baseUrl+url;
    http.Response response = await http.get(dataURL+'?currentPage='+currentPage.toString()+'&linesize='+linesize.toString()+'&address='+address);
    return response.body.toString();
  }

  static Future<String> get_loseb4(url,time,currentPage,linesize) async {
    String dataURL = node_baseUrl+url;
    http.Response response = await http.get(dataURL+'?currentPage='+currentPage.toString()+'&linesize='+linesize.toString()+'&time='+time);
    return response.body.toString();
  }

  static Future<String> get_loseb5(url,tp,currentPage,linesize) async {
    String dataURL = node_baseUrl+url;
    http.Response response = await http.get(dataURL+'?currentPage='+currentPage.toString()+'&linesize='+linesize.toString()+'&tp='+tp);
    return response.body.toString();
  }

  static Future<String> get_loseb6(url,type,currentPage,linesize) async {
    String dataURL = node_baseUrl+url;
    http.Response response = await http.get(dataURL+'?currentPage='+currentPage.toString()+'&linesize='+linesize.toString()+'&type='+type);
    return response.body.toString();
  }

  static Future<String> get_loseb7(url,userphone,currentPage,linesize) async {
    String dataURL = node_baseUrl+url;
    http.Response response = await http.get(dataURL+'?currentPage='+currentPage.toString()+'&linesize='+linesize.toString()+'&userphone='+userphone);
    return response.body.toString();
  }

  static Future<String> delect_loseb(url,id) async {
    String dataURL = node_baseUrl+url;
    http.Response response = await http.get(dataURL+'?id='+id);
    return response.body.toString();
  }

  static Future<String> upload_loseb(url,introduce,address,time,type,id) async {
    String dataURL = node_baseUrl+url;
    var temp={'introduce': introduce,'address': address,'time': time,'type': type,'id': id};
    http.Response response = await http.post(dataURL,body: temp);;
    return response.body.toString();
  }

  //获取百度token
  static Future<String> get_bdtoken() async {
    http.Response response = await http.get('https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=Z4Gz3IMG09AZkb7xFNvfFY27&client_secret=sPUl64jF2jRFHrLoyh6n7FCbw4LYaucq');
    return response.body.toString();
  }
  //百度相似图片入库
  //brief为本地数据id
  static Future<String> add_bdimage(token,image,brief) async {
    var temp={'image': image,'brief': brief};
    http.Response response = await http.post('https://aip.baidubce.com/rest/2.0/image-classify/v1/realtime_search/similar/add?access_token='+token,
        headers: {"content-type": "application/x-www-form-urlencoded"},body: temp);;
    return response.body.toString();
  }
  //百度相似图片检索
  static Future<String> get_bdimage(token,image) async {
    var temp={'image': image};
    http.Response response = await http.post('https://aip.baidubce.com/rest/2.0/image-classify/v1/realtime_search/similar/search?access_token='+token,
        headers: {"content-type": "application/x-www-form-urlencoded"},body: temp);;
    return response.body.toString();
  }
  //百度相似图片删除
  static Future<String> delect_bdimage(token,image) async {
    var temp={'image': image};
    http.Response response = await http.post('https://aip.baidubce.com/rest/2.0/image-classify/v1/realtime_search/similar/delete?access_token='+token,
        headers: {"content-type": "application/x-www-form-urlencoded"},body: temp);;
    return response.body.toString();
  }
  //百度通用物体识别
  static Future<String> advanced_general(token,image) async {
    var temp={'image': image};
    http.Response response = await http.post('https://aip.baidubce.com/rest/2.0/image-classify/v2/advanced_general?access_token='+token,
        headers: {"content-type": "application/x-www-form-urlencoded"},body: temp);
    Utf8Decoder uft8=new Utf8Decoder();
    var result = json.decode(uft8.convert(response.bodyBytes));
    return result.toString();
  }
}
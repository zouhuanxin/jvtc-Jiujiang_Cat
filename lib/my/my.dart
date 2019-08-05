import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter_app01/Bean/lunbo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'dart:convert';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/my/my_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/index/index.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:flutter_app01/index/index.dart';

class my extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>my_State();

}

class my_State extends State<my>{
  SharedPreferences sharedPreferences;

  //Data initialization
  void _load_data() async{
    sharedPreferences=await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load_data();
  }

  void component02_click(String str){
    switch(str){
      case '检查更新':
        IndexState().bmob_get_app_Version_information(context,'my');
        break;
      case '退出登陆':
        _showmodel_cancel_login_stystem('退出登陆','你确定退出登陆吗?');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('个人中心                                       ',
            textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 25),),
          elevation: 0.0,
          leading: new Container(
            margin: EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: (){
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new my_login()));
              },
              child: new ClipOval(
                child: new Image.memory(base64.decode(now_login_image_base64),fit: BoxFit.fill),
              ),
            ),
          ),
          backgroundColor: Color(int.parse(color1)),
          centerTitle: true,
        ),
          body: new Container(
            decoration: BoxDecoration(
              color: Color(int.parse(color1)),
            ),
            child: new Column(
              children: <Widget>[
                topimage(),
                SizedBox(height: 30,),
                new Align(
                  alignment: FractionalOffset.center,
                  child: new Text(username,textAlign: TextAlign.center,style: TextStyle(color:Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 30),),
                ),
                SizedBox(height: 30,),
                body_component01('images/2.0.x/dark_model.png', '暗黑模式'),
                body_component02('images/2.0.x/app_update.png',45, '检查更新'),
                body_component02('images/2.0.x/cancel_stystem.png',35, '退出登陆'),
              ],
            ),
          ),
      ),
    );
  }

  //top
  Widget topimage(){
    return new Container(
      margin: EdgeInsets.all(10.0),
      child: new Align(
        alignment: FractionalOffset.center,
        child: new GestureDetector(
          child: new ClipOval(
            child: new Image.memory(base64.decode(now_login_image_base64),fit: BoxFit.fill,height: 100,width: 100,),
          ),
        ),
      ),
    );
  }

  Widget body_component01(String imageurl,String label){
    return new Container(
      decoration: new BoxDecoration(
        border: new Border.all(width: 1.0, color: Color(int.parse(color1))),
        color: Color(int.parse(color1)),
      ),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(5.0),
      child:  new GestureDetector(
        child: new Row(
          children: <Widget>[
            Expanded(
              child: new ImageIcon(AssetImage(imageurl),size: 45,color: Color(int.parse(color2)),),
              flex: 2,
            ),
            Expanded(
              child: new Text(label,
                textAlign: TextAlign.left,style: TextStyle(fontSize: 20,color: Color(int.parse(color2)),),),
              flex: 10,
            ),
            Expanded(
              child: new Switch(
                value: dart_model,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                onChanged: (bool value) {
                  setState(() {
                    dart_model=value;
                    if(dart_model==true){
                      sharedPreferences.setString('color1', '0xff000000');
                      sharedPreferences.setString('color2', '0xffFFFAFA');
                    }else{
                      sharedPreferences.setString('color1', '0xffFFFAFA');
                      sharedPreferences.setString('color2', '0xff000000');
                    }
                    sharedPreferences.setString('dart_model', dart_model.toString());
                    color1=sharedPreferences.getString('color1');
                    color2=sharedPreferences.getString('color2');
                    bus.emit("dart_event", (arg){});
                  });
                },
              ),
              flex: 1,
            ),
          ],
        ),
        onTap:(){
          
        },
      ),
    );
  }

  Widget body_component02(String imageurl,double imagesize,String label){
    return new Container(
      decoration: new BoxDecoration(
        border: new Border.all(width: 1.0, color: Color(int.parse(color1))),
        color: Color(int.parse(color1)),
      ),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(5.0),
      child:  new GestureDetector(
        child: new Row(
          children: <Widget>[
            Expanded(
              child: new ImageIcon(AssetImage(imageurl),size: imagesize,color: Color(int.parse(color2)),),
              flex: 2,
            ),
            Expanded(
              child: new Text(label,
                textAlign: TextAlign.left,style: TextStyle(fontSize: 20,color: Color(int.parse(color2)),),),
              flex: 10,
            ),
            Expanded(
              child: new Text(''),
              flex: 1,
            ),
          ],
        ),
        onTap:(){
          component02_click(label);
        },
      ),
    );
  }

   //弹窗
  _showmodel_cancel_login_stystem(String title,String content){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text((content)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("确定"),
              onPressed: () {
                _cancel_login_stystem();
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }


  void _cancel_login_stystem(){
    Fluttertoast.showToast(
        msg: "你已退出",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );

    sharedPreferences.setString('now_login_image_base64', '');
    sharedPreferences.setString('username', '');
    sharedPreferences.setString('phone', '');
    sharedPreferences.setString('login_state', 'false');

    now_login_image_base64='R0lGODlh9AE6AfcAABAjIhAjJBMmKRs0Px9CTiBFUiI9SywqOCkmKSUlIyQkHyUgGiUfHCYjIyUmJiUmJiQmJiUmJSUlJSUjJSIkJSAkJR4dJRwlJBwlJCQnJS8uJzg4Kz8sLEknMk4zLVU9Ll5BLHU5LHQpO3UlQmklQlYlQ0UnS0QoVUYpXE0qbFMrd1Yse1ksgV8timAtjWEtjWEtjWEtjXopfJAkZJskXKojUbMjVbMiarsigb8ihMEihcIihcIihsIhhsUig+MiZOkiXuoiXuUiXNoiWNEnUt9KPetaNexaNN5YM8NZMKp5K8aRK96kLOqtLfCxLfS0Lfa1LfW1LtCyPZqtVA2hkQGhlQWYkxGAmRR3rxZ0uRdztSh7m0uVbmqlPnOuO3m5PX7BP4DEQIDFQITFRpfGa7LInMzMzM7OztDQ0NLS0tTU1NbW1tjY2Nra2tzc3N7e3uDg4OLi4uTk5Obm5ujo6Orq6uzs7O7u7vDw8PLy8vT09Pb29vj4+Pr6+vz8/P7+/gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQABAAAACwAAAAA9AE6AQAI/gAdCBxIsKDBgwgTKlzIsKHDhxAjSpxIsaLFixgzatzIsaPHjyBDihxJsqTJkyhTqlzJsqXLlzBjypxJs6bNmzhz6tzJs6fPn0CDCh1KtKjRo0iTKl3KtKnTp1CjSp1KtarVq1izat3KtavXr2DDih1LtqzZs2jTql3Ltq3bt3Djyp1Lt67du3jz6t3Lt6/fv4ADCx5MuLDhw4gTK17MuLHjx5AjS55MubLly5gza97MubPnz6BDix5NurTp06hTq17NurXr17Bjy55Nu7bt27hz697Nu7fv38CDCx9OvLjx48iTK1/OvLnz59CjS59Ovbr169iza9/Ovbv37+DD/osfT768+fPo06tfz769+/fw48uffzYC/fkRIiRIoKC///8A+rdffveFt99/CBxwgAkmnHACChBGCKGDJ5igIAIR/JdAgdXlt99+CZqAQgoqrMBCCy3EoOKKLLYYgwsosrBCCiiccAACGXiYgH0cJqefAg6EOKKJKbpo5JFHxqhCjTciwB+PPQaXoQIRLIiCCiciqeWWWqI4o40I9AdllLnlp0ACB1yZJZdstplkCyqkYEKYO5JZm34JJIjCCkW6iWKMLMi4wqCEmhjony64uSILciLg5IZ2upZhgieo0OeWMMoYZ40WKuhpkwl+uqCDI2KJYpstrIDCnHVGmtqT/iaksKaWMM64apMC4fnhrrzump+jjh5wAomzItkCozae6SppeCJQ6aVGHrukhRnumB+BFV3rYX+UygotizGmYGOuy3qmnwNpskBrqreGeeaYIU2JZpqmsgjjsSvECWa5nPGX5gqJJqkqte+y9GMElGKZaIz5xkmjhQ7Ay29kk6LAQsBGMjonnhK3pF8ED/zLsMMTWojAxJPph4DFxqpwAp088ZeAiCrUnAKNDpqMMmQqmwDwkRrD/FOGVYpII6cX7uxYhgek8K2KLKBwY6tCfawghSafrPRiG56gbsZSD5jUr59qvTViGx6gAtBSK+uUfY6enZgCK3/dYgspHOAA/qRQYSt3YUw7baQKrI4JQQXA/h1dfl5n/DLVh0PAQQkldGC24szlicK3eB9A5UAQYOBAByPMMAMJJXBwOebIoZkCxos+ThAGGJBOAw2mj0CC5awrp4DasKuowgFUOxAAAiPcgAMON+Cue+qr9y7lzHYvisIDfIeOAQk38MDD8s3nXkL00v/G+LcsmLAf6LXPgIP3POgA/gwjjA9B+cPlt7mLw1NNO/c6gJ/3coADGozPAffD3/T2B64UOIl9CHCfAOGHgxEgAAMJVCBwEIYCF7UABecSCAZL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';
    username='未登陆';
    phone='未登陆';
    login_state=false;

    setState(() {

    });
  }
}
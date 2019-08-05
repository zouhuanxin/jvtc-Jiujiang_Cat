import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';

class library_query extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => library_query_State();

}

class library_query_State extends State<library_query>{

  var query_context;
  List<Widget>library_query_ui_list=[];
  List<dynamic>library_query_data=[];
  final _formKey = GlobalKey<FormState>();
  //Start with the first page
  //This is different from other paging methods,where pages ares processed on the server and pages arep processed locally
  var now_page=1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('书籍查询                                       ',
            textAlign:TextAlign.left,style: TextStyle( color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
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
          child: Form(
              key: _formKey,
              child:  new ListView(children: <Widget>[
                buildSearchTextField(),
                book_card(),
                paging_component()],)),
        ));
  }

  Widget paging_component(){
    return new Container(
      child: new Row(
        children: <Widget>[
          new Container(
            child: Expanded(child: new RaisedButton(onPressed:(){
              if(now_page>1){
                setState(() {
                  now_page--;
                  _query_book();
                });
              }
            },color: Color(int.parse(color2)),child: new Text('上一页',style: TextStyle(color: Color(int.parse(color1))),),),flex: 1,),
          ),
          new Container(
            child: Expanded(child: new Text('$now_page',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),flex: 1,),
          ),
          new Container(
            child: Expanded(child: new RaisedButton(onPressed: (){
              setState(() {
                now_page++;
                _query_book();
              });
            },color: Color(int.parse(color2)),child: new Text('下一页',style: TextStyle(color: Color(int.parse(color1)))),),flex: 1,),
          )
        ],
      ),
    );
  }

  Widget buildSearchTextField() {
    return new Container(
      margin: EdgeInsets.all(5.0),
      child: TextFormField(
        validator: (String value) {
          if(value.isEmpty){
            return '请输入书籍名称';
          }
        },
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: dart_model,
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    ///只有输入的内容符合要求通过才会到达此处
                    _formKey.currentState.save();
                    _query_book();
                  }
                })),
        onSaved: (String value) => query_context = value,
      ),
    );
  }

  var showcon;
  void _query_book() async{
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (con) {
          showcon=con;
          return new LoadingDialog(
            text: "查询中…",
          );
        });
    String str1=await HttpUtil.library_book_query('tscxinfo', query_context, 'title', now_page);
    library_query_data=json.decode(json.encode(json.decode(str1)['data']));
    _loading_book_card();
  }

  Widget book_card(){
    return new Container(
      child: new Column(
        children: library_query_ui_list,
      )
    );
  }

  static String id='';
  void _loading_book_card(){
    Navigator.pop(showcon);
    library_query_ui_list.clear();
    for(var i=0;i<10;i++){
      Map<String,Object> tempmap=json.decode(json.encode(library_query_data[i]));
      library_query_ui_list.add(
          Container(
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(int.parse(color4)),
              border: new Border.all(width: 1.0, color: Colors.blue),
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Column(
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Text('图书标题',textAlign: TextAlign.center),
                        Expanded(
                          flex: 1,
                          child: new Text(tempmap==null?'':tempmap['title'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blue),),
                        ),
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Text('图书介绍',textAlign: TextAlign.center),
                        Expanded(
                          flex: 1,
                          child: new Text(tempmap==null?'':tempmap['introduce'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 3,),
                        ),
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Text('图书类型',textAlign: TextAlign.center),
                        Expanded(
                          flex: 1,
                          child: new Text(tempmap==null?'':tempmap['booktype'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                        ),
                        Expanded(
                          flex: 1,
                          child: new GestureDetector(
                            onTap: (){
                              List<dynamic>templist=tempmap['bookdetails'];
                              //print(json.decode(json.encode(templist[0]))['id']);
                              id=json.decode(json.encode(templist[0]))['id'].toString();
                              Navigator.push(context,
                                  new MaterialPageRoute(builder: (context) => new library_reservation()));
                            },
                            child: new Text('点击预约',textAlign:TextAlign.center,style: TextStyle(color: Colors.red),),
                          ),
                        ),
                      ],
                    ),
                    new Column(
                      children: book_card_details(tempmap['bookdetails']),
                    )
                  ],
                )
              ],
            ),
          ),
      );};
    setState(() {

    });
  }

  List<Widget> book_card_details(List<dynamic>templist){
    List<Widget>library_query_ui_details=[];
    for(var i=1;i<templist.length;i++){
      library_query_ui_details.add(new Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.0,color: Colors.grey)
        ),
        margin: EdgeInsets.all(5.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Text('索书号',textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(templist==null?'':json.decode(json.encode(templist[i]))['td1'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                ),
                new Text('条码号',textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(templist==null?'':json.decode(json.encode(templist[i]))['td2'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('年卷号',textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(templist==null?'':json.decode(json.encode(templist[i]))['td3'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                ),
                new Text('馆藏号',textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(templist==null?'':json.decode(json.encode(templist[i]))['td4'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('书刊状态',textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(templist==null?'':json.decode(json.encode(templist[i]))['td5'],textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                ),
              ],
            )
          ],
        ),
      ));
    }
    return library_query_ui_details;
  }

}

class library_reservation extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => library_reservation_State();

}

class library_reservation_State extends State<library_reservation> {

  List<dynamic>library_reservation_list = [];
  List<Widget>library_reservation_ui_list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // print(library_query_State.id);
    _library_reservation(library_query_State.id);
  }

  void _library_reservation(String id) async {
    library_reservation_list.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var temp = {'id': id, 'cookie': sharedPreferences.getString('tscookie')};
    http.Response response = await http.post(
        'http://47.94.255.154:8080/test/tsjylbinfo', body: json.encode(temp));
    //print(response.body);
    library_reservation_list =
        json.decode(json.encode(json.decode(response.body.toString())['data']));
    _loading_library_reservation_ui();
  }


  Widget library_reservation_ui() {
    return new Container(
        child: new Column(
          children: library_reservation_ui_list,
        )
    );
  }

  void _loading_library_reservation_ui() {
    library_reservation_ui_list.clear();
    for (var i = 1; i < library_reservation_list.length; i++) {
      Map<String, Object>tempmap = json.decode(
          json.encode(library_reservation_list[i]));
      //print(tempmap);
      library_reservation_ui_list.add(new Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(int.parse(color4)),
          border: Border.all(width: 1.0,color: Colors.black12),
        ),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Text('索书号', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap == null ? '' : tempmap['td1'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,),
                ),
                new Text('馆藏地', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap == null ? '' : tempmap['td2'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('可借', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap == null ? '' : tempmap['td3'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,),
                ),
                new Text('在馆', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap == null ? '' : tempmap['td4'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('排队', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap == null ? '' : tempmap['td5'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,),
                ),
                new Text('可否预约', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap == null ? '' : tempmap['td6'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,maxLines: 2,),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text('取书地', textAlign: TextAlign.center),
                Expanded(
                  flex: 1,
                  child: new Text(tempmap == null ? '' : json.decode(json.encode(tempmap['td7']))['text'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,),
                ),
                Expanded(
                  flex: 1,
                  child: new GestureDetector(
                    onTap: (){
                      _reservation_book(tempmap,i.toString());
                    },
                    child: Text('点击预约',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.red),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
    }
    setState(() {

    });
  }

  void _reservation_book(Map<String,Object>map,String index) async{
    //print(json.decode(json.encode(map)));
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    var temp = {'marc_no': map['marc_no'],'count':map['count'],'preg_days1':'30','take_loca1':json.decode(json.encode(map['td7']))['take_loca']
      ,'callno1':json.decode(json.encode(map['td8']))['callno1'],'location1':json.decode(json.encode(map['td8']))['location1']
      ,'pregKeepDays1':json.decode(json.encode(map['td8']))['pregKeepDays1'],'check':json.decode(json.encode(map['td8']))['check'],'csrf_token':''
      ,'cookie':sharedPreferences.getString('tscookie')};
    http.Response response = await http.post(
        'http://47.94.255.154:8080/test/tsydinfo', body: json.encode(temp));
    if(int.parse(json.decode(response.body)['code'].toString().trim())==0){
      Fluttertoast.showToast(
          msg: "预约成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        _library_reservation(library_query_State.id);
      });
    }else{
      Fluttertoast.showToast(
          msg: "预约失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('图书预约列表                                       ',
            textAlign:TextAlign.left,style: TextStyle( color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
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
              library_reservation_ui()
            ],
          ),
        ),
      );
    }
}
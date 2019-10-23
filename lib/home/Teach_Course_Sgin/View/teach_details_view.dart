import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class teach_details_view extends StatefulWidget{
  final Course_Sgin cs;

  const teach_details_view({Key key, this.cs}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_details_view_State(cs);
  }

}

class teach_details_view_State extends State<teach_details_view>{
  List<DropdownMenuItem> dropitems=[];

  Course_Sgin cs;
  teach_details_view_State(Course_Sgin cs){
    this.cs=cs;
    load_data();
    print('cs:$cs');
  }

  List<Widget>list_ui=[];
  List<Widget>list_ui2=[];
  void load_data(){
    List list1=[];
    if(cs.s_sgin.length>5){
      list1=cs.s_sgin.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
    }
    List list2=[];
    if(cs.f_sgin.length>5){
      list2=cs.f_sgin.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
    }
    list_ui.add(new Container(
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          '   已签到学生信息',
          style: TextStyle(
              color: Color(int.parse(color2)),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal),
        ),
      ),
    ));
    list_ui.add(new Container(
      child: new Row(
        children: <Widget>[
          Expanded(child: Text('学号',style: TextStyle(color: Colors.green),textAlign: TextAlign.center,),flex: 1,),
          Expanded(child: Text('姓名',style: TextStyle(color: Colors.green),textAlign: TextAlign.center,),flex: 1,),
          Expanded(child: Text('状态',style: TextStyle(color: Colors.green),textAlign: TextAlign.center,),flex: 1,),
        ],
      ),
    ));
    try{
      for(int i=0;i<list1.length;i++){
        list_ui.add(new Container(
          margin: EdgeInsets.all(5),
          child: new Row(
            children: <Widget>[
              Expanded(child: Text(list1[i].toString().split('&')[0],style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,),flex: 1,),
              Expanded(child: Text(list1[i].toString().split('&')[1],style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,),flex: 1,),
              Expanded(child: Text(list1[i].toString().split('&')[2],style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,),flex: 1,),
            ],
          ),
        ));
      }
    }catch(e){}
    list_ui2.add(new Container(
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          '   未签到学生信息',
          style: TextStyle(
              color: Color(int.parse(color2)),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal),
        ),
      ),
    ));
    list_ui2.add(new Container(
      child: new Row(
        children: <Widget>[
          Expanded(child: Text('学号',style: TextStyle(color: Colors.green),textAlign: TextAlign.center,),flex: 1,),
          Expanded(child: Text('姓名',style: TextStyle(color: Colors.green),textAlign: TextAlign.center,),flex: 1,),
          Expanded(child: Text('操作',style: TextStyle(color: Colors.green),textAlign: TextAlign.center,),flex: 1,),
        ],
      ),
    ));
    for(int i=0;i<list2.length;i++){
      list_ui2.add(new Container(
        margin: EdgeInsets.all(5),
        child: new Row(
          children: <Widget>[
             Expanded(child: Text(list2[i].toString().split('&')[0].trim(),style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,),flex: 1,),
             Expanded(child: Text(list2[i].toString().split('&')[1].trim(),style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,),flex: 1,),
             Expanded(child: GestureDetector(
               onTap: (){
                 _showmodel(list2[i].toString().split('&')[0],list2[i].toString().split('&')[1]);
               },
               child: Text('补录',style: TextStyle(color: Colors.red),textAlign: TextAlign.center,),
             ),flex: 1,),
          ],
        ),
      ));
    }
  }

  //补录弹窗
  String remrak='其他';
  _showmodel(String id,String name) {
    showDialog(
        context: context,
        builder: (context) => new StatefulBuilder(
          builder: (context, state){
            return AlertDialog(
              title: Text('补录提示'),
              content: Container(
                height: ScreenUtil().setHeight(300),
                child: Column(
                  children: <Widget>[
                    Text(('学号:${id.trim()}\n姓名:${name.trim()}')),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Text('            请假事由:'),
                          new Align(
                            alignment: Alignment.center,
                            child: DropdownButton(
                              items: dropitems,
                              hint: new Text('请选择', textAlign: TextAlign.center),
                              //当没有默认值的时候可以设置的提示
                              value: remrak,
                              //下拉菜单选择完之后显示给用户的值
                              onChanged: (T) {
                                state(() {
                                  remrak=T;
                                });
                              },
                              elevation: 20,
                              underline: Container(),
                              //设置阴影的高度
                              style: new TextStyle(
                                //设置文本框里面文字的样式
                                  color: Colors.black),
                              isDense: false,
                              iconSize: 20.0, //设置三角标icon的大小
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("关闭"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("补录",style: TextStyle(color: Colors.red),),
                  onPressed: () {
                    bulu(id, name);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ));
  }

  //补录
  void bulu(String id,String blname) async{
    //取出原来的数据
    //为尽可能保证数据的同步性这里再发送一次查询请求
    List<Course_Sgin> cs2=await this.queryWhereEqual2(cs.objectId);
    List arr1=[],arr2=[];
    if(cs2[0].s_sgin.length>5){
      arr1=cs2[0].s_sgin.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
    }
    if(cs2[0].f_sgin.length>5){
      arr2=cs2[0].f_sgin.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
      for(int i=0;i<arr2.length;i++){
        if(arr2[i].split('&')[0].toString().trim()==id.trim()){
          arr2.removeAt(i);
        }
      }
    }
    String temp=id+'&'+blname+'&'+remrak;
    arr1.add(temp);
    int i=await this.updateSingle(arr1.toString(),arr2.toString(), cs.objectId);
    if(i==0){
      await queryWhereEqual();
    }
  }

  void queryWhereEqual() async{
    BmobQuery<Course_Sgin> query = BmobQuery();
    query.addWhereEqualTo("teachid", now_studentid);
    await query.queryObjects().then((data) {
      List<Course_Sgin> blogs = data.map((i) => Course_Sgin.fromJson(i)).toList();
      for(int i=0;i<blogs.length;i++){
        if(this.cs.objectId.trim()==blogs[i].objectId.trim()){
          setState(() {
            this.cs=blogs[i];
            list_ui=[];
            list_ui2=[];
            load_data();
          });
        }
      }
    }).catchError((e) {
      print(BmobError.convert(e).error);
    });
    //通知上一层ui数据刷新了
    bus.emit("teach_details_view", (arg){});
  }

  Future<List<Course_Sgin>> queryWhereEqual2(String objectid) async{
    List<Course_Sgin>blogs=[];
    BmobQuery<Course_Sgin> query = BmobQuery();
    query.addWhereEqualTo("objectId", objectid);
    await query.queryObjects().then((data) {
      blogs = data.map((i) => Course_Sgin.fromJson(i)).toList();
    }).catchError((e) {
      print(BmobError.convert(e).error);
    });
    return blogs;
  }

  Future<int>updateSingle(String arr1,String arr2,String currentObjectId) async{
    int type=0;
    Course_Sgin blog = Course_Sgin();
    blog.objectId = currentObjectId;
    blog.s_sgin = arr1;
    blog.f_sgin = arr2;
    await blog.update().then((BmobUpdated bmobUpdated) {
      Util.showTaost('补录成功', Toast.LENGTH_SHORT, Colors.blue);
      type=0;
    }).catchError((e) {
      type=-1;
      Util.showTaost('补录失败', Toast.LENGTH_SHORT, Colors.red);
      print(BmobError.convert(e).error);
    });
    return type;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          '签到记录详情                                       ',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(int.parse(color2)),
              fontWeight: FontWeight.w800,
              fontSize: 17),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(int.parse(color2))),
        backgroundColor: Color(int.parse(color1)),
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: new Container(
          decoration: BoxDecoration(color: Color(int.parse(color1))),
          child: Column(
            children: [
              Expanded(child: ListView(children: list_ui,),flex: 1,),
              Expanded(child: ListView(children: list_ui2,),flex: 1,),
              SizedBox(height: ScreenUtil().setHeight(50),)
            ],
          )),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListData();
  }


  //签到状态数据
  void getListData() {
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem;
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('正常'),
      value: '正常',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('求职'),
      value: '求职',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('实习'),
      value: '实习',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('返家'),
      value: '返家',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('培训'),
      value: '培训',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('旅游'),
      value: '旅游',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('病假'),
      value: '病假',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('事假'),
      value: '事假',
    );
    items.add(dropdownMenuItem);
    dropdownMenuItem = new DropdownMenuItem(
      child: new Text('其他'),
      value: '其他',
    );
    items.add(dropdownMenuItem);
    dropitems=items;
  }

}
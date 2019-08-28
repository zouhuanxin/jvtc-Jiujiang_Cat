import 'dart:convert';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app01/HttpUtil/HttpUtil.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/Utils/WebViewPage.dart';
import 'package:flutter_app01/component/LoadingDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Collection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Collection_State();
}

class Collection_State extends State<Collection> {
  var _association=null,_projectname=null,_name=null,_studentid=null,_imageFile=null;
  final _formKey = GlobalKey<FormState>();
  String bs64=null;
  static const androidplatform = const MethodChannel("test");
  List<dynamic>association_drow=[{"name":"请刷新"}];
  List<dynamic>collection_drow=[{"name":"请刷新"}];
  int _collection_max_number=0;

  get_association_drow() async{
    String res=await HttpUtil.get_association_drow_single_information('/association_drow_router/get_association_drow_single');
    association_drow=json.decode(res);
    getListData1();
//    print('association_drow:$association_drow');
  }

  get_collection_drow() async{
    String res=await HttpUtil.get_collection_drow_single_information('/collection_drow_router/get_collection_drow_single',_association);
    collection_drow=json.decode(res);
    getListData2();
//    print('association_drow:$association_drow');
  }

  get_collection_id() async{
    String res=await HttpUtil.query_collection_information('getcollection_single', _association, '%', '%',_projectname);
    List<dynamic> list=json.decode(res);
    for(var i=0;i<list.length;i++){
      Map<String,dynamic> map =json.decode(json.encode(list[i]));
      if(int.parse(map['collection_id'].toString())>_collection_max_number){
        _collection_max_number=int.parse(map['collection_id'].toString());
      }
    }
    //print('_collection_max_number:$_collection_max_number');
    return _collection_max_number+1;
  }


  void _showmodel(mes,var type,var color){
    Fluttertoast.showToast(
        msg: mes,
        toastLength: type,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Widget top = new Container(
    padding: const EdgeInsets.all(10.0),
    child: new Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: new Image(image: new NetworkImage('http://47.94.255.154:8080/zhximage/wxyb1.png'),height: 200,),
        ),
        Expanded(
          flex: 1,
          child: new Image(image: new NetworkImage('http://47.94.255.154:8080/zhximage/zfbyb1.png'),height: 200,),
        ),
      ],
    ),
  );

  void _selectedImage() async{
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }
  void _imagetobase64(File value) async{
    String path=await androidplatform.invokeMethod("getFile",{"path":value.path});
    File file=new File(path);
    List bytes=await file.readAsBytes();
    bs64 = base64Encode(bytes);
    //此处用自己的服务器 上传大小限制为10M 所以这里不加限制
//    if(bs64.length>160000){
//      bs64=null;
//       _showmodel('图片过大,请重新选择一张.', Toast.LENGTH_SHORT,Colors.red);
//    }
  }
  Widget _previewImage() {
    return new GestureDetector(
      onTap: (){_selectedImage();},
      child: FutureBuilder<File>(
          future: _imageFile,
          builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              File file=snapshot.data;
              new Future(()=>_imagetobase64(file));
              return new Container(
                child: SizedBox(
                    width: 70.0,
                    child: Image.file(snapshot.data, fit: BoxFit.fill)
                ),
              );
            } else {
              return new Image.asset("images/2.0.x/xz.png", height: 70.0, width: 70.0,color: Color(int.parse(color2)),);
            }
          }),
    );
  }
  List<DropdownMenuItem> getListData1(){
    List<DropdownMenuItem> items=new List();
    for(var i=0;i<association_drow.length;i++){
      Map<String,dynamic> map =json.decode(json.encode(association_drow[i]));
      DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
        child:new Text(map['name']),
        value: map['name'],
      );
      items.add(dropdownMenuItem1);
    }
    setState(() {


    });
    return items;
  }

  List<DropdownMenuItem> getListData2(){
    List<DropdownMenuItem> items=new List();
    for(var i=0;i<collection_drow.length;i++){
      Map<String,dynamic> map =json.decode(json.encode(collection_drow[i]));
      DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
        child:new Text(map['name']),
        value: map['name'],
      );
      items.add(dropdownMenuItem1);
    }
    setState(() {

    });
    return items;
  }

  Widget xl1(){
    return new DropdownButton(
      items: getListData1(),
      hint:new Text('单位协会',textAlign: TextAlign.center),//当没有默认值的时候可以设置的提示
      value: _association,//下拉菜单选择完之后显示给用户的值
      onChanged: (T){//下拉菜单item点击之后的回调
        setState(() {
          _association=T;
          get_collection_drow();
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
      hint:new Text('收款项目名称',textAlign: TextAlign.center),//当没有默认值的时候可以设置的提示
      value: _projectname,//下拉菜单选择完之后显示给用户的值
      onChanged: (T){//下拉菜单item点击之后的回调
        setState(() {
          _projectname=T;
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

  TextFormField buildProjectnameTextField() {
    return TextFormField(
      initialValue: _projectname,
      decoration: InputDecoration(
        labelText: '收款项目名称',
        fillColor: Colors.white,
        filled: dart_model,
      ),
      validator: (String value) {
        if(value.isEmpty){
          return '请输入收款项目名称';
        }
      },
      onSaved: (String value) => _projectname = value,
    );
  }

  TextFormField buildNameTextField() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(
        labelText: '姓名',
        fillColor: Colors.white,
        filled: dart_model,
      ),
      validator: (String value) {
        if(value.isEmpty){
          return '请输入你的姓名';
        }
      },
      onSaved: (String value) => _name = value,
    );
  }

  TextFormField buildStudentidTextField() {
    return TextFormField(
      initialValue: _studentid,
      decoration: InputDecoration(
        labelText: '学号',
        fillColor: Colors.white,
        filled: dart_model,
      ),
      validator: (String value) {
        if(value.isEmpty){
          return '请输入你的学号';
        }
      },
      onSaved: (String value) => _studentid = value,
    );
  }

  var showcon; //Navigator.pop(showcon);
  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '提交',
            style: TextStyle(color: Color(int.parse(color1))),
          ),
          color: Color(int.parse(color2)),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              if(bs64!=null&&bs64.length>1000&&_association!=null&&_association.toString().length>1
              &&bs64!=null&&_name!=null&&_association!=null&&_studentid!=null&&_projectname!=null){
                _yz_image_wz();
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (con) {
                      showcon=con;
                      return new LoadingDialog(
                        text: "提交中…",
                      );
                    });
              }else{
                _showmodel('请把信息填写完整', Toast.LENGTH_SHORT, Colors.red);
              }
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  //验证图片

  _yz_image_wz() async{
    String str1=await HttpUtil.image_text_sb('bdtextsb','pOyNhIyUDMMXBovrTEKb4TX8','NIDGGuijgHgbpcR5o3sQy33j1ORfwS7A',bs64);
    String query_str='成功';
    for(var i=0;i<collection_drow.length;i++){
      if(json.decode(json.encode(collection_drow[i]))['name']==_projectname){
        query_str=json.decode(json.encode(collection_drow[i]))['money'];
      }
    }
    if(str1.toString().indexOf('支付成功')!=-1||str1.toString().indexOf('交易成功')!=-1){
      if(str1.toString().indexOf(query_str.toString())!=-1){
        _post_data();
      }else{
        Navigator.pop(showcon);
        _showmodel('金额不符合', Toast.LENGTH_SHORT, Colors.red);
      }
    }else{
      Navigator.pop(showcon);
      _showmodel('截图不符合规范', Toast.LENGTH_SHORT, Colors.red);
    }
  }

  _post_data() async{
    String _time=new DateTime.now().toString().split('.')[0];
    String a=bs64.toString();
    String b=_name.toString();
    String c=_association.toString();
    String d=_studentid.toString();
    String e=_projectname.toString();
    int f=await get_collection_id();
    String str1=await HttpUtil.add_collection_information('addcollection',a,b,c,d,e,_time,f.toString());
    //print('str1:$str1');
    if(str1=='0'){
      Navigator.pop(showcon);
      Navigator.pop(context);
      _showmodel('提交成功', Toast.LENGTH_SHORT, Colors.blue);
    }else{
      Navigator.pop(showcon);
      _showmodel('提交失败', Toast.LENGTH_SHORT, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '协会收款                                       ',
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
          actions: <Widget>[new Container()],
        ),
        body: new Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Color(int.parse(color4)),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: new Column(
                    children: <Widget>[
                      new Text('请截取以下界面图片提交'),
                      top,
                      new GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (context) => new WebViewPage(url:'http://47.94.255.154:8080/zhxword/jzxms_collection_sm.html',title:'收款使用说明')));
                        },
                        child:  Align(
                          alignment: Alignment.topRight,
                          child: new Text('点击查看详细教程 >'),
                        )
                      )
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(int.parse(color4)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: new Column(
                    children: <Widget>[
                      new Text('选择付款截图'),
                      SizedBox(height: 10,),
                      _previewImage(),
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Color(int.parse(color4)),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: new Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: xl1(),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text(''),
                            flex: 1,
                          ),
                          Expanded(
                            child: xl2(),
                            flex: 2,
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
//                      buildProjectnameTextField(),
                      SizedBox(height: 10,),
                      buildNameTextField(),
                      SizedBox(height: 10,),
                      buildStudentidTextField(),
                      SizedBox(height: 20,),
                      buildLoginButton(context),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ],
            )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_association_drow();
  }
}

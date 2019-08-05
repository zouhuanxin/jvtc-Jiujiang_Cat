import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:flutter_app01/Utils/Record_Text.dart';

class PersonPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {

  Map<String,Object> learn_teach_data_map=null;

  Widget table1(){
    return new Container(
      child: new Column(
        children: <Widget>[
          Text('学生基本信息',style: TextStyle(fontSize: 18,color: Color(int.parse(color2))),),
          SizedBox(height: 5,),
          Table(
            //表格边框样式
            border: TableBorder.all(
              color: Colors.black12,
              width: 2.0,
              style: BorderStyle.solid,
            ),
            children: [
              TableRow(
                  children: [
                    Text('姓名',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'': json.decode(json.encode(learn_teach_data_map['basicsinfo']))['StudentName'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('校区',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'': json.decode(json.encode(learn_teach_data_map['basicsinfo']))['Campus'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('入学文化程度',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'': json.decode(json.encode(learn_teach_data_map['basicsinfo']))['WHCD'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('出生日期',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'': json.decode(json.encode(learn_teach_data_map['basicsinfo']))['BirthDay'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('民族',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['basicsinfo']))['National'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('政治面貌',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['basicsinfo']))['Polity'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('籍贯',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['basicsinfo']))['NativePlace'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('入学时间',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['basicsinfo']))['InTime'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('入学成绩',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['basicsinfo']))['RXCJ'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('科类',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['basicsinfo']))['KL'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('学号',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['basicsinfo']))['StudentNo'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('身份证号',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['basicsinfo']))['IdCard'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('银行名称',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['basicsinfo']))['BankName'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('银行帐号',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['basicsinfo']))['BankNo'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget table2(){
    return new Container(
      child: new Column(
        children: <Widget>[
          Text('个人联系方式',style: TextStyle(fontSize: 18,color: Color(int.parse(color2))),),
          SizedBox(height: 5,),
          Table(
            //表格边框样式
            border: TableBorder.all(
              color: Colors.black12,
              width: 2.0,
              style: BorderStyle.solid,
            ),
            children: [
              TableRow(
                  children: [
                    Text('移动电话',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['contactinfo']))['MoveTel'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('电子邮件',textAlign: TextAlign.center,),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['contactinfo']))['Email'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('QQ号码',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['contactinfo']))['QQCard'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('微信号码',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['contactinfo']))['WXH'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget table3(){
    return new Container(
      child: new Column(
        children: <Widget>[
          Text('家庭信息',style: TextStyle(fontSize: 18,color: Color(int.parse(color2))),),
          SizedBox(height: 5,),
          Table(
            //表格边框样式
            border: TableBorder.all(
              color: Colors.black12,
              width: 2.0,
              style: BorderStyle.solid,
            ),
            children: [
              TableRow(
                  children: [
                    Text('父亲姓名',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['homeinfo']))['FatherName'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('母亲姓名',textAlign: TextAlign.center,),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['homeinfo']))['MotherName'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('父亲电话号码',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['homeinfo']))['FatherTel'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('母亲电话号码',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['homeinfo']))['MotherTel'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget table4(){
    return new Container(
      child: new Column(
        children: <Widget>[
          Text('在校信息',style: TextStyle(fontSize: 18,color: Color(int.parse(color2))),),
          SizedBox(height: 5,),
          Table(
            //表格边框样式
            border: TableBorder.all(
              color: Colors.black12,
              width: 2.0,
              style: BorderStyle.solid,
            ),
            children: [
              TableRow(
                  children: [
                    Text('学生类型',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['schoolinfo']))['SpeType'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('在校状态',textAlign: TextAlign.center,),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['schoolinfo']))['InStatus'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('院系',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['schoolinfo']))['CollegeNo'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('专业',textAlign: TextAlign.center,),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['schoolinfo']))['SpecialtyNo'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('年级',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['schoolinfo']))['Grade'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('班级',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['schoolinfo']))['ClassNo'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                  ]
              ),
              TableRow(
                  children: [
                    Text('班级',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(learn_teach_data_map==null?'':json.decode(json.encode(learn_teach_data_map['schoolinfo']))['BedNo'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2)))),
                    Text('',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text('',textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                  ]
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('我的资料                                       ',
            textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
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
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            table1(),
            SizedBox(height: 30,),
            table2(),
            SizedBox(height: 30,),
            table3(),
            SizedBox(height: 30,),
            table4(),
          ],
        ),
      )
    );
  }

  //Access to personal information
  //Get information from local storage
  void _get_person_information() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   if(prefs.getString('learn_teach_data')==null){
     Fluttertoast.showToast(
         msg: "请先登陆",
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.TOP,
         timeInSecForIos: 1,
         backgroundColor: Colors.red,
         textColor: Colors.white,
         fontSize: 16.0
     );
     Navigator.pop(context);
   }else{
     setState(() {
       var learn_teach_data=prefs.getString('learn_teach_data');
       learn_teach_data_map=json.decode(learn_teach_data);
       //print(learn_teach_data_map);
     });
   }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _get_person_information();
  }

}

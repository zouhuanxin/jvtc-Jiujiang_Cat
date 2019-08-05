import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:flutter_app01/Utils/Record_Text.dart';

class library_person_info extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new library_person_infoState();
}

class library_person_infoState extends State<library_person_info> {

  List<dynamic> library_data_list=[];

  Widget table1(){
    return new Container(
      child: new Column(
        children: <Widget>[
          Text('图书证件基本信息',style: TextStyle(fontSize: 18,color: Color(int.parse(color2))),),
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
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[0]))['td2'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[0]))['td3'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[0]))['td4'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                  ]
              ),
              TableRow(
                  children: [
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[1]))['td1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[1]))['td2'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[1]))['td3'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                  ]
              ),
              TableRow(
                  children: [
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[2]))['td1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[2]))['td2'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[2]))['td3'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                  ]
              ),
              TableRow(
                  children: [
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[3]))['td1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[3]))['td2'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[3]))['td3'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                  ]
              ),
              TableRow(
                  children: [
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[4]))['td1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[4]))['td2'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[4]))['td3'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                  ]
              ),
              TableRow(
                  children: [
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[5]))['td2'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[6]))['td1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[6]))['td4'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                  ]
              ),
              TableRow(
                  children: [
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[8]))['td1'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[8]))['td3'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
                    Text(library_data_list.length<1?'': json.decode(json.encode(library_data_list[8]))['td4'],textAlign: TextAlign.center,style: TextStyle(color: Color(int.parse(color2))),),
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
          title: new Text('个人信息                                       ',
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
          ],
        ),
      )
    );
  }

  //Access to personal information
  //Get information from local storage
  void _get_person_information() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   if(prefs.getString('library_data')==null){
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
       library_data_list=json.decode(prefs.getString('library_data'));
       //print(json.decode(json.encode(library_data_list[0]))['td2']);
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

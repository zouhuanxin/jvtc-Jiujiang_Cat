
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app01/home/Teach_JW/ViewModel/teach_jw_hmc_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class hmc_ui{

  static Widget Card1(text1,text2,id,teach_jw_hmc_viewmodel tjhm){
    return new Container(
      height: ScreenUtil().setHeight(260),
      padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setHeight(20), ScreenUtil().setWidth(20), ScreenUtil().setHeight(20)),
      child: Card(
        child: Row(
          children: <Widget>[
            Expanded(child: Column(
              children: <Widget>[
                Text('\n'+text1),
                Text(text2),
              ],
            ),flex: 4,),
            Expanded(child: GestureDetector(
              onTap: (){
                tjhm.teach_hmc_info1(id);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(10), 0),
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), ScreenUtil().setHeight(10), ScreenUtil().setWidth(10), ScreenUtil().setHeight(10)),
                decoration: BoxDecoration(
                  color: Colors.grey
                ),
                child:  Text('花名册',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),textAlign: TextAlign.center,),
              ),
            ),flex: 1,),
          ],
        ),
      ),
    );
  }


}
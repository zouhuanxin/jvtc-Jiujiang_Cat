

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app01/Bean/Course_Sgin.dart';
import 'package:flutter_app01/Utils/Util.dart';
import 'package:flutter_app01/Utils/WebViewPage.dart';
import 'package:flutter_app01/home/Student_course_sgin/ViewModel/student_home_viewmodel.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/View/teach_details_view.dart';
import 'package:flutter_app01/home/Teach_Course_Sgin/ViewModel/teach_home_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provide/provide.dart';

class teach_sgin_ui{

  //卡片1
  static Widget card1(Course_Sgin cs,teach_home_viewmodel thv,String text1,String text2,String text3,BuildContext context){
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: GestureDetector(
        onTap: (){
          Util.jump(context, new teach_details_view(cs: cs,));
        },
        child: new Container(
          child: Card(
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Align(child: Text(cs.course_name.split('-')[0],style: TextStyle(fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(60)),),alignment: Alignment.topLeft,),
                      Align(child: Text(cs.course_name.split('-').length>1?'  '+cs.course_name.split('-')[1]:'',style: TextStyle(fontWeight: FontWeight.w400,fontSize: ScreenUtil().setSp(35)),overflow: TextOverflow.ellipsis,maxLines: 1,),alignment: Alignment.topLeft),
                    ],
                  ),
                  Align(child: Text('教师:'+cs.teachname,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                  Align(child: Text('学工号:'+cs.teachid,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.topLeft,),
                  Align(child: Text('创建时间:'+cs.createdAt,style: TextStyle(fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(40),color: Colors.green,),),alignment: Alignment.topLeft,),
                  Row(
                    children: <Widget>[
                      Expanded(child: Align(child: Text('班级总人数:'+text1,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.center,),flex: 1,),
                      Expanded(child: Align(child: Text('已签到人数:'+text2,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.center,),flex: 1,),
                      Expanded(child: Align(child: Text('未签到人数:'+text3,style: TextStyle(fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(40),color: Colors.black38),),alignment: Alignment.center,),flex: 1,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
        actions: <Widget>[
          IconSlideAction(
            caption: '删除',
            color: Colors.red,
            icon: Icons.delete,
            onTap: (){
              thv.deleteSingle_showmodel(cs.objectId);
            },
            closeOnTap: true,
          ),
          IconSlideAction(
            caption: '签到统计',
            color: Colors.blue,
            icon: Icons.format_align_center,
            onTap: () {
              //http://dyzuis.cn:8080/bjtable/index.html?id=11041&name=%E8%BD%AF%E4%BB%B6%E5%BB%BA%E6%A8%A1-%E7%A7%BB%E5%8A%A8%E4%BA%92%E8%81%941801%E7%8F%AD
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new WebViewPage(
                          url: 'http://dyzuis.cn:8080/bjtable/index.html?id='+cs.teachid+'&name='+cs.course_name+'',
                          title: '班级签到统计')));
            },
            closeOnTap: true,
          ),
        ],
    );
  }

}
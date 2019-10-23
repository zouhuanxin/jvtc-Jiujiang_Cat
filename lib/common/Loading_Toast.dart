import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/EventCallback.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading_Toast {
  BuildContext context,context2,context3;
  String text;

  Loading_Toast(BuildContext context,String text) {
    this.context=context;
    this.text = text;
  }

  //更新数据
  void Upload_data(T){
    text=T;
    bus.emit("Loading_Toast_meg", (arg){});
  }

  Open_Loading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (con) {
          this.context2=con;
          return StatefulBuilder(
              builder: (context, state){
                this.context3=context;
                //注册广播
                bus.on("Loading_Toast_meg", (arg) {
                  state(() {

                  });
                });
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(text,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      decoration: TextDecoration.none)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
          );
        });
  }

  void Close_Loading() {
    Timer time;
    if(context2==null){
        time=new Timer.periodic(new Duration(seconds: 1), (timer) {
        Close_Loading();
        time.cancel();
      });
    }else{
      Navigator.pop(context2);
      bus.off("Loading_Toast_meg"); //移除广播机制
    }
  }

}

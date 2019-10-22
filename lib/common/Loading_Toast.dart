import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading_Toast {
  BuildContext context,context2;
  String text;

  Loading_Toast(BuildContext context,String text) {
    this.context=context;
    this.text = text;
  }

  Open_Loading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (con) {
          this.context2=con;
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
    }
  }

}

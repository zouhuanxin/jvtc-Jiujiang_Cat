import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app01/index/index.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  Timer _timer;
  int count = 3;

  startTime() async {
    //设置启动图生效时间
    var _duration = new Duration(seconds: 1);
    new Timer(_duration, () {
      // 空等1秒之后再计时
      _timer = new Timer.periodic(const Duration(milliseconds: 1000), (v) {
        count--;
        if (count == 0) {
          navigationPage();
        } else {
          setState(() {});
        }
      });
      return _timer;
    });
  }

  void navigationPage() {
    _timer.cancel();
    Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => new Index()), (check) => false);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: const Alignment(1.0, -1.0), // 右上角对齐
      children: [
        new ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Image(image: NetworkImage('http://47.94.255.154:8080/zhximage/qidong02.png'), fit: BoxFit.fill,),
        ),
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 30.0, 10.0, 0.0),
          child: new FlatButton(
            onPressed: () {
              navigationPage();
            },
//            padding: EdgeInsets.all(0.0),
            color: Colors.grey,
            child: new Text(
              "$count 小猫奔跑",
              style: new TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),
        )
      ],
    );
  }
}